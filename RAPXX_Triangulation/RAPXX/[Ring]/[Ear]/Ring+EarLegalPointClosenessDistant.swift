//
//  Ring+EarLegalPointClosenessDistant.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/12/24.
//

import Foundation

extension Ring {
    
    func measureEarLegalPointClosenessDistantHelper(index1: Int, index2: Int) -> Bool {
        
        if ringPointCount < 6 {
            return true
        }
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        let ringPointCount1 = ringPointCount - 1
        
        var ceiling1 = index2 - 1
        if ceiling1 == -1 {
            ceiling1 = ringPointCount1
        }
        
        var ringPointIndex1 = index1 + 2
        while ringPointIndex1 < ceiling1 {
            let ringPoint = ringPoints[ringPointIndex1]
            var closestX = Float(0.0)
            var closestY = Float(0.0)
            
            preComputedLineSegment1.closestPoint(ringPoint.x, ringPoint.y, &closestX, &closestY)
            let distanceSquared = ringPoint.distanceSquared(x: closestX, y: closestY)
            if distanceSquared < PolyMeshConstants.splitPointDistantTooCloseToLineSegmentSquared {
            if isSafeConnectionForEar(ringPoint: ringPoint,
                                      splitRingPoint1: splitRingPoint1,
                                      splitRingPoint2: splitRingPoint2, splitSegment: preComputedLineSegment1, closestX: closestX, closestY: closestY) {
                    return false
                }
            }
            ringPointIndex1 += 1
        }
        
        // How many points will we cross?
        let numberOfPointsInSpan2 = (ringPointCount1 - index2) + (index1)
        
        if numberOfPointsInSpan2 < 3 {
            return true
        }
        
        var ceiling2 = index1 - 1
        if ceiling2 == -1 {
            ceiling2 = ringPointCount1
        }
        
        var ringPointIndex2 = index2 + 2
        if ringPointIndex2 >= ringPointCount {
            ringPointIndex2 -= ringPointCount
        }
        
        while ringPointIndex2 != ceiling2 {
            let ringPoint = ringPoints[ringPointIndex2]
            var closestX = Float(0.0)
            var closestY = Float(0.0)
            preComputedLineSegment1.closestPoint(ringPoint.x, ringPoint.y, &closestX, &closestY)
            let distanceSquared = ringPoint.distanceSquared(x: closestX, y: closestY)
            if distanceSquared < PolyMeshConstants.splitPointDistantTooCloseToLineSegmentSquared {
                if isSafeConnectionForEar(ringPoint: ringPoint,
                                          splitRingPoint1: splitRingPoint1,
                                          splitRingPoint2: splitRingPoint2, splitSegment: preComputedLineSegment1, closestX: closestX, closestY: closestY) {
                    return false
                }
            }
            ringPointIndex2 += 1
            if ringPointIndex2 == ringPointCount {
                ringPointIndex2 = 0
            }
        }
        return true
    }
}
