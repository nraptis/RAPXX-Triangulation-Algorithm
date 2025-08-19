//
//  Ring+PointAngularSpans.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/6/24.
//

import Foundation

extension Ring {
    
    func attemptCalculateRingPointAngularSpans() -> Bool {
        for ringPointIndex in 0..<ringPointCount {
            if !calculateRingPointAngularSpan(ringPointIndex: ringPointIndex) {
                return false
            }
        }
        return true
    }
    
    func calculateRingPointAngularSpan(ringPointIndex: Int) -> Bool {
        
        guard ringPointIndex >= 0 else { return false }
        guard ringPointIndex < ringPointCount else { return false }
        
        let ringPoint = ringPoints[ringPointIndex]
        return calculateRingPointAngularSpan(ringPoint: ringPoint)
    }
    
    func calculateRingPointAngularSpan(ringPoint: RingPoint) -> Bool {
        
        let ringLineSegmentRight = ringPoint.ringLineSegmentRight!
        
        let angleDiffHalf = Math.distanceBetweenAnglesAbsoluteUnsafe(ringLineSegmentRight.directionAngle,
                                                                             ringPoint.normalAngle)
        ringPoint.angularSpan = angleDiffHalf + angleDiffHalf
        if ringPoint.angularSpan < PolyMeshConstants.illegalTriangleAngleThreshold {
            ringPoint.isIllegal = true
            return false
        }
        if ringPoint.angularSpan > PolyMeshConstants.illegalTriangleAngleThresholdOpposite {
            ringPoint.isIllegal = true
            return false
        }
        
        return true
        
        
        // ALternative for testing; we shouldn't really use this here since we already have the angles
        /*
         ringPoint.angularSpan = Math.triangleAngle(x1: ringPoint.neighborLeft!.x,
         y1: ringPoint.neighborLeft!.y,
         x2: ringPoint.x,
         y2: ringPoint.y,
         x3: ringPoint.neighborRight!.x,
         y3: ringPoint.neighborRight!.y)
         if ringPoint.isIllegal {
         return false
         } else {
         return true
         }
         */
        
        /*
         illegal = false
         
         let dotProduct = deltaX1 * deltaX2 + deltaY1 * deltaY2
         
         let cosAngle = dotProduct / (magnitude1 * magnitude2)
         return acosf(cosAngle)
         
         return true
         */
    }
    
    
}
