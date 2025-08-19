//
//  Ring+CapOff.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/13/24.
//

import Foundation

extension Ring {
    
    func attemptCapOffIfSmallEnough() -> Bool {
        
        /*
        if POLY_MESH_MONO_CAP_OFF_ENABLED {
            if depth == POLY_MESH_MONO_CAP_OFF_LEVEL {
            } else {
                return false
            }
        } else {
            if POLY_MESH_OMNI_CAP_OFF_ENABLED && (depth <= POLY_MESH_OMNI_CAP_OFF_LEVEL) {
                
            } else {
                return false
            }
        }
        */
        
        let minX = getMinX()
        let maxX = getMaxX()
        let minY = getMinY()
        let maxY = getMaxY()
        let rangeX = maxX - minX
        let rangeY = maxY - minY
        if rangeX < PolyMeshConstants.capOffThreshold && rangeY < PolyMeshConstants.capOffThreshold {
            
            var ringPointIndex1 = 0
            while ringPointIndex1 < ringPointCount {
                let ringPoint1 = ringPoints[ringPointIndex1]
                let point1 = ringPoint1.point
                var ringPointIndex2 = ringPointIndex1 + 1
                
                while ringPointIndex2 < ringPointCount {
                    let ringPoint2 = ringPoints[ringPointIndex2]
                    let point2 = ringPoint2.point
                    let distanceSquared = point1.distanceSquaredTo(point2)
                    if distanceSquared > PolyMeshConstants.capOffThresholdSquared {
                        return false
                    }
                    ringPointIndex2 += 1
                }
                ringPointIndex1 += 1
            }
            
            if attemptCapOffUnsafe() {
                return true
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
    
    func attemptCapOffUnsafe() -> Bool {
        
        var fudge = 0
        while fudge < 24 {
            
            if ringPointCount < 3 {
                return false
            }
            
            purgeRingCapOffs()
            purgeMeldProbeSpokes()
            for ringPointIndex in 0..<ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                let ringProbeSpoke = PolyMeshPartsFactory.shared.withdrawRingProbeSpoke()
                ringProbeSpoke.precomputeStep1(connection: ringPoint)
                addMeldProbeSpoke(ringProbeSpoke)
            }
            
            if ringPointCount == 3 {
                let ringPoint0 = ringPoints[0]
                let ringPoint1 = ringPoints[1]
                let ringPoint2 = ringPoints[2]
                let area = Math.triangleAreaAbsolute(x1: ringPoint0.x,
                                                     y1: ringPoint0.y,
                                                     x2: ringPoint1.x,
                                                     y2: ringPoint1.y,
                                                     x3: ringPoint2.x,
                                                     y3: ringPoint2.y)
                if area < PolyMeshConstants.smallTriangleAreaThreshold {
                    if attemptCapOffWithOneTriangle() {
                        return true
                    }
                }
            }
            
            var centerX = Float(0.0)
            var centerY = Float(0.0)
            for ringPointIndex in 0..<ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                centerX += ringPoint.x
                centerY += ringPoint.y
            }
            
            let countf = Float(ringPointCount)
            centerX /= countf
            centerY /= countf

            for notchIndex in 0..<PolyMeshConstants.capOffNotchX.count {
            
                let x = centerX + PolyMeshConstants.capOffNotchX[notchIndex]
                let y = centerY + PolyMeshConstants.capOffNotchY[notchIndex]
                    
                calculateCapOffIfPossible(x, y)
            }
            
            if let bestCapOff = getBestCapOff() {
                if attemptCapOffWithPoint(bestCapOff.x, bestCapOff.y) {
                    return true
                }
            }
            
            if attemptToClipEarForCapOff() {
                
            } else {
                
                if ringPointCount == 3 {
                    
                    if attemptCapOffWithOneTriangle() {
                        
                        return true
                    } else {
                        
                        return false
                    }
                    
                } else {
                    
                    return false
                }
            }
            fudge += 1
        }
        
        return false
    }
    
    func calculateCapOffIfPossible(_ x: Float, _ y: Float) {
        
        var maxSpokeLength = Float(-100_000_000.0)
        for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
            let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
            meldProbeSpoke.precomputeStep2(x: x, y: y)
            if meldProbeSpoke.length > maxSpokeLength {
                maxSpokeLength = meldProbeSpoke.length
            }
        }
        
        var minSpokeAngle = Math.pi2
        var index1 = 0
        var index2 = 1
        while index2 < meldProbeSpokeCount {
            let meldProbeSpoke1 = meldProbeSpokes[index1]
            let meldProbeSpoke2 = meldProbeSpokes[index2]
            let x1 = x
            let y1 = y
            let x2 = meldProbeSpoke2.x2
            let y2 = meldProbeSpoke2.y2
            let x3 = meldProbeSpoke1.x2
            let y3 = meldProbeSpoke1.y2
            
            let spokeAngle = Math.triangleMinimumAngle(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3)
            if spokeAngle < PolyMeshConstants.illegalTriangleAngleThreshold { return }
            if spokeAngle < minSpokeAngle { minSpokeAngle = spokeAngle }
            
            index1 = index2
            index2 += 1
        }
        
        
        var maxDistanceToLineSegmentSquared = Float(-100_000_000.0)
        var minDistaceToLineSegmentSquared = Float(100_000_000.0)
        for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
            let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
            
            for ringLineSegmentIndex in 0..<ringLineSegmentCount {
                let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
                
                if ringLineSegment.ringPointLeft === meldProbeSpoke.connection { continue }
                if ringLineSegment.ringPointRight === meldProbeSpoke.connection { continue }
                
                
                let distanceSquared = meldProbeSpoke.distanceSquaredToLineSegment(ringLineSegment)
                if distanceSquared < PolyMeshConstants.capOffGeometryTooCloseSquared {
                    
                    
                    return
                }
                if distanceSquared < minDistaceToLineSegmentSquared {
                    minDistaceToLineSegmentSquared = distanceSquared
                }
                if distanceSquared > maxDistanceToLineSegmentSquared {
                    maxDistanceToLineSegmentSquared = distanceSquared
                }
            }
        }
        
        let ringCapOff = PolyMeshPartsFactory.shared.withdrawRingCapOff()
        ringCapOff.x = x
        ringCapOff.y = y
        
        ringCapOff.capOffQuality.maxDistanceToLineSegment = RingCapOffQuality.classifyMaxDistanceToLineSegment(maxDistanceToLineSegmentSquared)
        ringCapOff.capOffQuality.minDistanceToLineSegment = RingCapOffQuality.classifyMinDistanceToLineSegment(minDistaceToLineSegmentSquared)
        ringCapOff.capOffQuality.minSpokeAngle = RingCapOffQuality.classifyMinSpokeAngle(minSpokeAngle)
        ringCapOff.capOffQuality.maxSpokeLength = RingCapOffQuality.classifyMaxSpokeLength(maxSpokeLength)
        
        addRingCapOff(ringCapOff)
    }
    
}
