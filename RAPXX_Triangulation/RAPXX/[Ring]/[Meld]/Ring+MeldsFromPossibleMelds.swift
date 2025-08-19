//
//  Ring+FirstMeld.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 1/30/24.
//

import Foundation

extension Ring {
    
    func calculateMeldsFromPossibleMelds(ringProbePointIndex: Int,
                                         numberOfPointsToMeld: Int) -> Bool {
        
        if numberOfPointsToMeld < 2 {
            return false
        }
        
        if meldProbePointCount < 1 {
            return false
        }
        
        var result = false
        
        let meldProbePointFirst = meldProbePoints[0]
        let meldProbePointLast = meldProbePoints[meldProbePointCount - 1]
        
        var meldProbePointBeforeFirstIndex = meldProbePointFirst.ringIndex - 1
        if meldProbePointBeforeFirstIndex == -1 {
            meldProbePointBeforeFirstIndex = ringProbePointCount - 1
        }
        let meldProbePointBeforeFirst = ringProbePoints[meldProbePointBeforeFirstIndex]
        
        var meldProbePointAfterLastIndex = meldProbePointLast.ringIndex + 1
        if meldProbePointAfterLastIndex == ringProbePointCount {
            meldProbePointAfterLastIndex = 0
        }
        let meldProbePointAfterLast = ringProbePoints[meldProbePointAfterLastIndex]
        
        for possibleMeldIndex in 0..<possibleMeldCount {
            let possibleMeld = possibleMelds[possibleMeldIndex]
            
            for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
                let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
                meldProbeSpoke.precomputeStep2(x: possibleMeld.x, y: possibleMeld.y)
            }
            
            var minSpokeAngle = Math.pi2
            if !calculateMeldsFromPossibleMeldsSpokeAngles(possibleMeld: possibleMeld, minSpokeAngle: &minSpokeAngle) {
                continue
            }
            
            // We want to get this check over with relatively quickly, or we could waste a lot of
            // crunching on a cluster that is too far inset...
            if !calculateMeldsFromPossibleMeldsOneSpokeIntersectsProbeSegment() {
                continue
            }
            
            if !calculateMeldsFromPossibleSpokesTooClose() {
                continue
            }
            
            var minBeforeAngle = Math.pi2
            var minAfterAngle = Math.pi2
            if !calculateMeldsFromPossibleMeldsEdgeAngles(possibleMeld: possibleMeld,
                                                          meldProbePointFirst: meldProbePointFirst,
                                                          meldProbePointLast: meldProbePointLast,
                                                          meldProbePointBeforeFirst: meldProbePointBeforeFirst,
                                                          meldProbePointAfterLast: meldProbePointAfterLast,
                                                          minBeforeAngle: &minBeforeAngle,
                                                          minAfterAngle: &minAfterAngle) {
                continue
            }
            
            var minDistanceToLineSegmentSquared = Float(100_000_000.0)
            var maxDistanceToLineSegmentSquared = Float(-100_000_000.0)
            if !calculateMeldsFromPossibleMeldsRayTooClose1(possibleMeld: possibleMeld,
                                                            meldProbePointBeforeFirst: meldProbePointBeforeFirst,
                                                            minDistanceToLineSegmentSquared: &minDistanceToLineSegmentSquared,
                                                            maxDistanceToLineSegmentSquared: &maxDistanceToLineSegmentSquared) {
                if calculateMeldsFromPossibleMeldsRayTooClose1_Opposite(meldProbePointFirst: meldProbePointFirst,
                                                                        meldProbePointBeforeFirst: meldProbePointBeforeFirst) {
                    continue
                }
            }

            
            if !calculateMeldsFromPossibleMeldsRayTooClose2(possibleMeld: possibleMeld,
                                                            meldProbePointAfterLast: meldProbePointAfterLast,
                                                            minDistanceToLineSegmentSquared: &minDistanceToLineSegmentSquared,
                                                            maxDistanceToLineSegmentSquared: &maxDistanceToLineSegmentSquared) {
                if calculateMeldsFromPossibleMeldsRayTooClose2_Opposite(meldProbePointLast: meldProbePointLast,
                                                                        meldProbePointAfterLast: meldProbePointAfterLast) {
                    continue
                }
            }

            if !calculateMeldsFromPossibleMeldsRayWedgeTooClose(meldProbePointBeforeFirst: meldProbePointBeforeFirst,
                                                                meldProbePointAfterLast: meldProbePointAfterLast) {
                continue
            }
            
            var wedgeNormalX = preComputedLineSegment1.normalX + preComputedLineSegment2.normalX
            var wedgeNormalY = preComputedLineSegment1.normalY + preComputedLineSegment2.normalY
            var wedgeNormalLength = wedgeNormalX * wedgeNormalX + wedgeNormalY * wedgeNormalY
            let wedgeAngle: Float
            if wedgeNormalLength > Math.epsilon {
                wedgeNormalLength = sqrtf(wedgeNormalLength)
                wedgeNormalX /= wedgeNormalLength
                wedgeNormalY /= wedgeNormalLength
                let normalAngle = -atan2f(wedgeNormalX, wedgeNormalY) - Math.pi
                let halfAngle = Math.distanceBetweenAnglesAbsoluteUnsafe(preComputedLineSegment1.directionAngle,
                                                                         normalAngle)
                wedgeAngle = halfAngle + halfAngle
                
            } else {
                wedgeAngle = Math.distanceBetweenAnglesAbsolute(preComputedLineSegment1.normalAngle,
                                                                preComputedLineSegment2.normalAngle)
            }
            
            var minSpokeLength = Float(100_000_000.0)
            var maxSpokeLength = Float(0.0)
            
            for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
                let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
                if meldProbeSpoke.length < minSpokeLength {
                    minSpokeLength = meldProbeSpoke.length
                }
                if meldProbeSpoke.length > maxSpokeLength {
                    maxSpokeLength = meldProbeSpoke.length
                }
            }
            
            let ringMeld = PolyMeshPartsFactory.shared.withdrawRingMeld()
            
            ringMeld.x = possibleMeld.x
            ringMeld.y = possibleMeld.y
            
            //ringMeld.reset()
            for meldProbePointIndex in 0..<meldProbePointCount {
                let meldProbePoint = meldProbePoints[meldProbePointIndex]
                ringMeld.add(ringProbePoint: meldProbePoint)
            }
            
            //ringMeld.ringProbePointIndex = ringProbePointIndex
            //ringMeld.numberOfPointsToMeld = numberOfPointsToMeld
            
            let minEdgeAngle = min(minBeforeAngle, minAfterAngle)
            //let minEdgeLength = min(preComputedLineSegment1.length, preComputedLineSegment2.length)
            let maxEdgeLength = max(preComputedLineSegment1.length, preComputedLineSegment2.length)
            
            ringMeld.meldQuality.maxDistanceToLineSegment = RingMeldQuality.classifyMaxDistanceToLineSegment(maxDistanceToLineSegmentSquared)
            
            if meldProbeSpokeCount == 0 {
                ringMeld.meldQuality.minSpokeAngle = .excellent
                ringMeld.meldQuality.maxSpokeLength = .excellent
            } else {
                ringMeld.meldQuality.minSpokeAngle = RingMeldQuality.classifyMinSpokeAngle(minSpokeAngle)
                ringMeld.meldQuality.maxSpokeLength = RingMeldQuality.classifyMaxSpokeLength(maxSpokeLength)
            }
            ringMeld.meldQuality.minEdgeAngle = RingMeldQuality.classifyMinEdgeAngle(minEdgeAngle)
            ringMeld.meldQuality.wedgeAngle = RingMeldQuality.classifyWedgeAngle(wedgeAngle)
            ringMeld.meldQuality.maxEdgeLength = RingMeldQuality.classifyMaxEdgeLength(maxEdgeLength)
            
            ringMeld.meldQuality.calculateWeight()
            
            addRingMeld(ringMeld)
            
            result = true
        }
        return result
    }
    
}
