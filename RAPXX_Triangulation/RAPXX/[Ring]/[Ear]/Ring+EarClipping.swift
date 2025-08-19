//
//  Ring+EarClipping.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/29/23.
//

import Foundation

extension Ring {
    
    func attemptToClipEar() -> Bool {
        
        if ringPointCount <= 3 {
            return false
        }

        var bestEarIndex = -1
        var worstEarAngle = Float(100_000_000.0)
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.angularSpan < PolyMeshConstants.earClipThresholdRegular {
                if measureEarLegalRegular(index: ringPointIndex) {
                    if ringPoint.angularSpan < worstEarAngle {
                        worstEarAngle = ringPoint.angularSpan
                        bestEarIndex = ringPointIndex
                    }
                }
            }
        }
        
        guard bestEarIndex != -1 else {
            return false
        }
        
        proceedToClipEarUnsafe(bestEarIndex: bestEarIndex)
        return true
    }
    
    func attemptToClipEarForCapOff() -> Bool {
        
        if ringPointCount <= 3 {
            return false
        }
        
        var bestEarIndex = -1
        var worstEarAngle = Float(100_000_000.0)
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            //if ringPoint.angularSpan < PolyMeshConstants.earClipThresholdCapOff {
                if measureEarLegalForCapOff(index: ringPointIndex) {
                    if ringPoint.angularSpan < worstEarAngle {
                        worstEarAngle = ringPoint.angularSpan
                        bestEarIndex = ringPointIndex
                    }
                }
            //}
        }
        
        guard bestEarIndex != -1 else {
            return false
        }
        
        proceedToClipEarUnsafe(bestEarIndex: bestEarIndex)
        return true
    }
    
    func proceedToClipEarUnsafe(bestEarIndex: Int) {
        
        guard let triangleData = triangleData else {
            return
        }
        
        var ringPointIndexPrevious = bestEarIndex - 1
        if ringPointIndexPrevious < 0 { ringPointIndexPrevious = ringPointCount - 1 }
        
        var ringPointIndexNext = bestEarIndex + 1
        if ringPointIndexNext == ringPointCount { ringPointIndexNext = 0 }
        
        let ringPointEar = ringPoints[bestEarIndex]
        
        let numberOfPointsForSplit = getSplitPointCount(index1: ringPointIndexPrevious, index2: ringPointIndexNext)
        if numberOfPointsForSplit == 0 {
            
            _ = earClipReplaceRingPointZeroRingPoints(ringPointIndex: bestEarIndex)
            
            // In this case, we are point 0
            if ringPointIndexPrevious == ringPointCount {
                // Point at the tail.
                ringPointIndexPrevious = ringPointCount - 1
            }
            
            // In this case, we were the tail.
            if bestEarIndex == ringPointCount {
                // Point at 0.
                ringPointIndexNext = 0
            } else {
                // Since we lost a point, the "next" is now "current"
                ringPointIndexNext = bestEarIndex
            }
            
            let originalRingPoint1 = ringPoints[ringPointIndexPrevious]
            let originalRingPoint2 = ringPoints[ringPointIndexNext]
            
            triangleData.add(x1: originalRingPoint1.x, y1: originalRingPoint1.y,
                                      x2: ringPointEar.x, y2: ringPointEar.y,
                                      x3: originalRingPoint2.x, y3: originalRingPoint2.y)
            
            PolyMeshPartsFactory.shared.depositRingPoint(ringPointEar)
        } else if numberOfPointsForSplit == 1 {
            
            _ = earClipReplaceRingPointOneRingPoint(ringPointIndex: bestEarIndex)
            
            let originalRingPoint1 = ringPoints[ringPointIndexPrevious]
            let originalRingPoint2 = ringPoints[bestEarIndex]
            let originalRingPoint3 = ringPoints[ringPointIndexNext]
            
            triangleData.add(x1: originalRingPoint1.x, y1: originalRingPoint1.y,
                                      x2: ringPointEar.x, y2: ringPointEar.y,
                                      x3: originalRingPoint2.x, y3: originalRingPoint2.y)
            
            triangleData.add(x1: originalRingPoint2.x, y1: originalRingPoint2.y,
                                      x2: ringPointEar.x, y2: ringPointEar.y,
                                      x3: originalRingPoint3.x, y3: originalRingPoint3.y)
            
            PolyMeshPartsFactory.shared.depositRingPoint(ringPointEar)
        } else {
            
            // In this case, we are point 0
            _ = earClipReplaceRingPointTwoRingPoints(ringPointIndex: bestEarIndex)
            
            if ringPointIndexPrevious == (ringPointCount - 2) {
                // Point at the tail.
                ringPointIndexPrevious = ringPointCount - 1
            }
            
            var ringPointIndexNextNext = bestEarIndex + 2
            if ringPointIndexNextNext >= ringPointCount {
                ringPointIndexNextNext -= ringPointCount
            }
            
            let originalRingPoint1 = ringPoints[ringPointIndexPrevious]
            let originalRingPoint2 = ringPoints[bestEarIndex]
            let originalRingPoint3 = ringPoints[bestEarIndex + 1]
            let originalRingPoint4 = ringPoints[ringPointIndexNextNext]
            
            triangleData.add(x1: originalRingPoint1.x, y1: originalRingPoint1.y,
                                      x2: ringPointEar.x, y2: ringPointEar.y,
                                      x3: originalRingPoint2.x, y3: originalRingPoint2.y)
            
            triangleData.add(x1: originalRingPoint2.x, y1: originalRingPoint2.y,
                                      x2: ringPointEar.x, y2: ringPointEar.y,
                                      x3: originalRingPoint3.x, y3: originalRingPoint3.y)
            
            triangleData.add(x1: originalRingPoint3.x, y1: originalRingPoint3.y,
                                      x2: ringPointEar.x, y2: ringPointEar.y,
                                      x3: originalRingPoint4.x, y3: originalRingPoint4.y)
            
            PolyMeshPartsFactory.shared.depositRingPoint(ringPointEar)
        }
    }
}
