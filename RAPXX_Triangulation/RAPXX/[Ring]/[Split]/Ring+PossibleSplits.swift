//
//  Ring+FindSplits.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/29/23.
//

import Foundation

extension Ring {
    
    //@Precondition: calculateRingLineSegmentContentions
    func calculatePossibleSplits() {
        
        for ringPointIndex in 0..<ringPointCount {
            ringPoints[ringPointIndex].purgePossibleSplits()
        }
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            for lineSegmentContentionIndex in 0..<ringPoint.lineSegmentContentionCount {
                let lineSegmentContention = ringPoint.lineSegmentContentions[lineSegmentContentionIndex]
                if lineSegmentContention.distanceSquared <= PolyMeshConstants.ringSplitDistanceSquared {
                    let lineSegment = lineSegmentContention.ringLineSegment!
                    
                    let ringPointLeft = lineSegment.ringPointLeft!
                    if Math.polygonIndexDistance(index1: ringPointIndex,
                                                 index2: ringPointLeft.ringIndex,
                                                 count: ringPointCount) > 2 {
                        if !ringPoint.possibleSplitsContains(ringPoint: ringPointLeft) {
                            let possibleSplit = PolyMeshPartsFactory.shared.withdrawPossibleSplit()
                            possibleSplit.ringPoint = ringPointLeft
                            possibleSplit.distanceSquared = ringPoint.point.distanceSquaredTo(ringPointLeft.point)
                            ringPoint.addPossibleSplit(possibleSplit)
                        }
                        
                        if !ringPointLeft.possibleSplitsContains(ringPoint: ringPoint) {
                            let possibleSplit = PolyMeshPartsFactory.shared.withdrawPossibleSplit()
                            possibleSplit.ringPoint = ringPoint
                            possibleSplit.distanceSquared = ringPointLeft.point.distanceSquaredTo(ringPoint.point)
                            ringPointLeft.addPossibleSplit(possibleSplit)
                        }
                    } 
                    
                    let ringPointRight = lineSegment.ringPointRight!
                    if Math.polygonIndexDistance(index1: ringPointIndex,
                                                 index2: ringPointRight.ringIndex,
                                                 count: ringPointCount) > 2 {
                        if !ringPoint.possibleSplitsContains(ringPoint: ringPointRight) {
                            let possibleSplit = PolyMeshPartsFactory.shared.withdrawPossibleSplit()
                            possibleSplit.ringPoint = ringPointRight
                            possibleSplit.distanceSquared = ringPoint.point.distanceSquaredTo(ringPointRight.point)
                            ringPoint.addPossibleSplit(possibleSplit)
                        }
                        
                        if !ringPointRight.possibleSplitsContains(ringPoint: ringPoint) {
                            let possibleSplit = PolyMeshPartsFactory.shared.withdrawPossibleSplit()
                            possibleSplit.ringPoint = ringPoint
                            possibleSplit.distanceSquared = ringPointRight.point.distanceSquaredTo(ringPoint.point)
                            ringPointRight.addPossibleSplit(possibleSplit)
                        }
                    }
                }
            }
        }
        proceedToCalculatePossibleSplitPairs()
    }
    
    private func proceedToCalculatePossibleSplitPairs() {
        
        purgePossibleSplitPairs()
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            
            for possibleSplitIndex in 0..<ringPoint.possibleSplitCount {
                let possibleSplit = ringPoint.possibleSplits[possibleSplitIndex]
                
                var ringPoint1: RingPoint
                var ringPoint2: RingPoint
                if possibleSplit.ringPoint.ringIndex < ringPoint.ringIndex {
                    ringPoint1 = possibleSplit.ringPoint
                    ringPoint2 = ringPoint
                } else {
                    ringPoint1 = ringPoint
                    ringPoint2 = possibleSplit.ringPoint
                }
                if !possibleSplitPairsContains(ringPoint1: ringPoint1,
                                               ringPoint2: ringPoint2) {
                    let possibleSplitPair = PolyMeshPartsFactory.shared.withdrawPossibleSplitPair()
                    possibleSplitPair.ringPoint1 = ringPoint1
                    possibleSplitPair.ringPoint2 = ringPoint2
                    possibleSplitPair.distanceSquared = possibleSplit.distanceSquared
                    addPossibleSplitPair(possibleSplitPair)
                }
            }
        }
    }
    
    // It's either 0, 1, or 2
    func getSplitPointCount(index1: Int, index2: Int) -> Int {
        guard index1 >= 0 && index1 < ringPointCount else { return 0 }
        guard index2 >= 0 && index2 < ringPointCount else { return 0 }
        let distanceSquared = ringPoints[index1].distanceSquared(ringPoint: ringPoints[index2])
        if distanceSquared < PolyMeshConstants.splitLineIntoTwoPointsDistanceSquared {
            return 0
        } else if distanceSquared < PolyMeshConstants.splitLineIntoThreePointsDistanceSquared {
            return 1
        } else {
            return 2
        }
    }
}
