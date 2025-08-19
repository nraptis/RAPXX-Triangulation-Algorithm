//
//  Ring+Split.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/2/23.
//

import Foundation

extension Ring {
    
    //
    // At the end of this, if it returns false, the split cannot be used.
    // If it returns true, safety check A and B will be done on splitRing1 and splitRing2;
    // Note: This is still not "bullet proof" as further ear clipping may occur.
    //
    func split(splitRing1: Ring, splitRing2: Ring, index1: Int, index2: Int, count: Int) -> Bool {
        
        if ringPointCount < 4 {
            return false
        }
        
        if index1 < 0 || index1 >= ringPointCount {
            return false
        }
        
        if index2 < 0 || index2 >= ringPointCount {
            return false
        }
        
        if Math.polygonIndexDistance(index1: index1, index2: index2, count: ringPointCount) < 2 {
            return false
        }
        
        if count < 0 || count > 2 {
            return false
        }
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        
        if count == 0 {
            splitRing1.addPoint(x: splitRingPoint1.x,
                                y: splitRingPoint1.y,
                                controlIndex: -1)
            splitRing1.addPoint(x: splitRingPoint2.x, y: splitRingPoint2.y, controlIndex: -1)
            splitRing2.addPoint(x: splitRingPoint2.x, y: splitRingPoint2.y, controlIndex: -1)
            splitRing2.addPoint(x: splitRingPoint1.x, y: splitRingPoint1.y, controlIndex: -1)
        } else if count == 1 {
            let centerX = (splitRingPoint1.x + splitRingPoint2.x) * 0.5
            let centerY = (splitRingPoint1.y + splitRingPoint2.y) * 0.5

            splitRing1.addPoint(x: splitRingPoint1.x, y: splitRingPoint1.y, controlIndex: -1)
            splitRing1.addPoint(x: centerX, y: centerY, controlIndex: -1)
            splitRing1.addPoint(x: splitRingPoint2.x, y: splitRingPoint2.y, controlIndex: -1)
            splitRing2.addPoint(x: splitRingPoint2.x, y: splitRingPoint2.y, controlIndex: -1)
            splitRing2.addPoint(x: centerX, y: centerY, controlIndex: -1)
            splitRing2.addPoint(x: splitRingPoint1.x, y: splitRingPoint1.y, controlIndex: -1)
        } else {
            let deltaX = splitRingPoint2.x - splitRingPoint1.x
            let deltaY = splitRingPoint2.y - splitRingPoint1.y
            let centerX1 = splitRingPoint1.x + deltaX * 0.35
            let centerY1 = splitRingPoint1.y + deltaY * 0.35
            let centerX2 = splitRingPoint1.x + deltaX * 0.65
            let centerY2 = splitRingPoint1.y + deltaY * 0.65

            splitRing1.addPoint(x: splitRingPoint1.x, y: splitRingPoint1.y, controlIndex: -1)
            splitRing1.addPoint(x: centerX1, y: centerY1, controlIndex: -1)
            splitRing1.addPoint(x: centerX2, y: centerY2, controlIndex: -1)
            splitRing1.addPoint(x: splitRingPoint2.x, y: splitRingPoint2.y, controlIndex: -1)
            
            splitRing2.addPoint(x: splitRingPoint2.x, y: splitRingPoint2.y, controlIndex: -1)
            splitRing2.addPoint(x: centerX2, y: centerY2, controlIndex: -1)
            splitRing2.addPoint(x: centerX1, y: centerY1, controlIndex: -1)
            splitRing2.addPoint(x: splitRingPoint1.x, y: splitRingPoint1.y, controlIndex: -1)
        }
        
        var ringPointIndex = index2 + 1
        if ringPointIndex == ringPointCount {
            ringPointIndex = 0
        }
        while ringPointIndex != index1 {
            let ringPoint = ringPoints[ringPointIndex]
            splitRing1.addPoint(x: ringPoint.x, y: ringPoint.y, controlIndex: -1)
            ringPointIndex += 1
            if ringPointIndex == ringPointCount {
                ringPointIndex = 0
            }
        }
        
        ringPointIndex = index1 + 1
        if ringPointIndex == ringPointCount {
            ringPointIndex = 0
        }
        while ringPointIndex != index2 {
            let ringPoint = ringPoints[ringPointIndex]
            splitRing2.addPoint(x: ringPoint.x, y: ringPoint.y, controlIndex: -1)
            ringPointIndex += 1
            if ringPointIndex == ringPointCount {
                ringPointIndex = 0
            }
        }
        
        if !splitRing1.attemptCalculateBasicsAndDetermineSafetyPartA(test: false) {
            return false
        }
        
        if !splitRing2.attemptCalculateBasicsAndDetermineSafetyPartA(test: false) {
            return false
        }
        
        if !splitRing1.attemptCalculateBasicsAndDetermineSafetyPartB(needsPointInsidePolygonBucket: true, needsLineSegmentBucket: true, test: false) {
            return false
        }
        
        if !splitRing2.attemptCalculateBasicsAndDetermineSafetyPartB(needsPointInsidePolygonBucket: true, needsLineSegmentBucket: true, test: false) {
            return false
        }
        
        splitRing1.depth = depth + 1
        splitRing2.depth = depth + 1
        
        return true
    }
    
}
