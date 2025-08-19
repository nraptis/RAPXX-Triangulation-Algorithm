//
//  Ring+PointNormals.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/6/24.
//

import Foundation

extension Ring {
    
    func attemptCalculateRingPointNormals() -> Bool {
        var ringPointIndex = 0
        while ringPointIndex < ringPointCount {
            if !calculateRingPointNormal(ringPointIndex: ringPointIndex) {
                return false
            }
            ringPointIndex += 1
        }
        return true
    }
    
    func calculateRingPointNormal(ringPointIndex: Int) -> Bool {
        
        guard ringPointIndex >= 0 else { return false }
        guard ringPointIndex < ringPointCount else { return false }
        
        let ringPoint = ringPoints[ringPointIndex]
        
        return calculateRingPointNormal(ringPoint: ringPoint)
    }
    
    func calculateRingPointNormal(ringPoint: RingPoint) -> Bool {
        
        let ringLineSegmentLeft = ringPoint.ringLineSegmentLeft!
        let ringLineSegmentRight = ringPoint.ringLineSegmentRight!
        
        var normalX = ringLineSegmentLeft.normalX + ringLineSegmentRight.normalX
        var normalY = ringLineSegmentLeft.normalY + ringLineSegmentRight.normalY
        
        var normalLengthSquared = normalX * normalX + normalY * normalY
        if normalLengthSquared < Math.epsilon {
            
            // In this case, we have probably a 180 degree angle,
            // so, we will need to make a small adjustment to both angles...
            
            let angle1 = ringLineSegmentLeft.normalAngle + Math.pi_8
            let angle2 = ringLineSegmentRight.normalAngle - Math.pi_8
            
            let diffX = sinf(angle1) + sinf(angle2)
            let diffY = -(cosf(angle1) + cosf(angle2))
            
            normalLengthSquared = diffX * diffX + diffY * diffY
            
            if normalLengthSquared > Math.epsilon {
                let normalLength = sqrtf(normalLengthSquared)
                normalX = diffX / normalLength
                normalY = diffY / normalLength
                ringPoint.normalX = normalX
                ringPoint.normalY = normalY
                ringPoint.normalAngle = -atan2f(-normalX, -normalY)
                ringPoint.directionX = normalY
                ringPoint.directionY = -normalX
                return true
            } else {
                ringPoint.isIllegal = true
                return false
            }
        } else {
            let normalLength = sqrtf(normalLengthSquared)
            normalX /= normalLength
            normalY /= normalLength
            ringPoint.normalX = normalX
            ringPoint.normalY = normalY
            ringPoint.normalAngle = -atan2f(-normalX, -normalY)
            ringPoint.directionX = normalY
            ringPoint.directionY = -normalX
            return true
        }
    }
}
