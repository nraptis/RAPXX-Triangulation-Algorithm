//
//  Ring+SplitCheckEarAngles.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/11/24.
//

import Foundation

extension Ring {
    
    func attemptMeasureSplitQualityEarAngles(index1: Int, index2: Int, quality: inout RingSplitQuality) -> Bool {
        let ringPointCount1 = ringPointCount - 1
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        
        var elbowIndex1 = index1 + 1
        if elbowIndex1 == ringPointCount {
            elbowIndex1 = 0
        }
        let elbowRingPoint1 = ringPoints[elbowIndex1]
        let angle1 = Math.triangleAngle(x1: splitRingPoint2.x, y1: splitRingPoint2.y,
                                        x2: splitRingPoint1.x, y2: splitRingPoint1.y,
                                        x3: elbowRingPoint1.x, y3: elbowRingPoint1.y)
        if angle1 < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        }
        
        var elbowIndex2 = index1 - 1
        if elbowIndex2 == -1 {
            elbowIndex2 = ringPointCount1
        }
        let elbowRingPoint2 = ringPoints[elbowIndex2]
        let angle2 = Math.triangleAngle(x1: elbowRingPoint2.x, y1: elbowRingPoint2.y,
                                        x2: splitRingPoint1.x, y2: splitRingPoint1.y,
                                        x3: splitRingPoint2.x, y3: splitRingPoint2.y)
        if angle2 < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        }
        
        var elbowIndex3 = index2 + 1
        if elbowIndex3 == ringPointCount {
            elbowIndex3 = 0
        }
        let elbowRingPoint3 = ringPoints[elbowIndex3]
        let angle3 = Math.triangleAngle(x1: splitRingPoint1.x, y1: splitRingPoint1.y,
                                        x2: splitRingPoint2.x, y2: splitRingPoint2.y,
                                        x3: elbowRingPoint3.x, y3: elbowRingPoint3.y)
        if angle3 < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        }
        
        var elbowIndex4 = index2 - 1
        if elbowIndex4 == -1 {
            elbowIndex4 = ringPointCount1
        }
        let elbowRingPoint4 = ringPoints[elbowIndex4]
        let angle4 = Math.triangleAngle(x1: elbowRingPoint4.x, y1: elbowRingPoint4.y,
                                        x2: splitRingPoint2.x, y2: splitRingPoint2.y,
                                        x3: splitRingPoint1.x, y3: splitRingPoint1.y)
        if angle4 < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        }
        
        var minAngle = angle1
        if angle2 < minAngle { minAngle = angle2 }
        if angle3 < minAngle { minAngle = angle3 }
        if angle4 < minAngle { minAngle = angle4 }
        
        quality.earAngle = RingSplitQuality.classifyMinEarAngle(minAngle)
        
        return true
    }
    
}
