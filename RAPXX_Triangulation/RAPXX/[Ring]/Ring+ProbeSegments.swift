//
//  Ring+ProbeSegments.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/21/23.
//

import Foundation

extension Ring {
    
    func calculateProbeSegmentsForInitialInset() {
        
        ringProbeSegmentCount = 0
        
        for lineSegmentIndex in 0..<ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[lineSegmentIndex]
            let ringProbeSegment = PolyMeshPartsFactory.shared.withdrawProbeSegment()
            ringProbeSegment.ring = self
            ringProbeSegment.setup(lineSegment: ringLineSegment)
            addRingProbeSegment(ringProbeSegment)
        }
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            ringPoint.probeSegmentForCollider = ringProbeSegments[ringPoint.ringLineSegmentLeft.ringIndex]
        }
        calculateProbeSegmentNeighborIntersections()
    }
    
    func calculateProbeSegmentNeighborIntersections() {
        
        let tooSharpLength = (PolyMeshConstants.ringInsetAmountThreatNone * 1.5)
        let tooSharpThreshold = (tooSharpLength * tooSharpLength)
        
        var previousIndex = ringProbeSegmentCount - 1
        var currentIndex = 0
        while currentIndex < ringProbeSegmentCount {
            let previousRingProbeSegment = ringProbeSegments[previousIndex]
            let currentRingProbeSegment = ringProbeSegments[currentIndex]
            
            //previousRingProbeSegment.colliderSpecialMeld = false
            
            
            let angularDifferenceAbsolute = Math.distanceBetweenAnglesAbsolute(previousRingProbeSegment.normalAngle, currentRingProbeSegment.normalAngle)

            if angularDifferenceAbsolute < Math.pi_8 {
                
                previousRingProbeSegment.colliderPointX = (previousRingProbeSegment.x2 + currentRingProbeSegment.x1) * 0.5
                previousRingProbeSegment.colliderPointY = (previousRingProbeSegment.y2 + currentRingProbeSegment.y1) * 0.5
                
            } else {
                
                let intersectionResult = Math.rayIntersectionRay(rayOrigin1X: previousRingProbeSegment.centerX, 
                                                                 rayOrigin1Y: previousRingProbeSegment.centerY,
                                                                 rayNormal1X: previousRingProbeSegment.normalX,
                                                                 rayNormal1Y: previousRingProbeSegment.normalY,
                                                                 rayOrigin2X: currentRingProbeSegment.centerX,
                                                                 rayOrigin2Y: currentRingProbeSegment.centerY,
                                                                 rayDirection2X: currentRingProbeSegment.directionX,
                                                                 rayDirection2Y: currentRingProbeSegment.directionY)

                switch intersectionResult {
                case .invalidCoplanar:
                    previousRingProbeSegment.colliderPointX = (previousRingProbeSegment.x2 + currentRingProbeSegment.x1) * 0.5
                    previousRingProbeSegment.colliderPointY = (previousRingProbeSegment.y2 + currentRingProbeSegment.y1) * 0.5
                case .valid(let pointX, let pointY, _):
                    
                    let ringPoint = ringPoints[currentIndex]
                    let distanceSquared = ringPoint.distanceSquared(x: pointX, y: pointY)
                    
                    if distanceSquared > tooSharpThreshold {
                        var diffX = pointX - ringPoint.x
                        var diffY = pointY - ringPoint.y
                        let length = sqrtf(diffX * diffX + diffY * diffY)
                        diffX /= length
                        diffY /= length
                        previousRingProbeSegment.colliderPointX = ringPoint.x + diffX * tooSharpLength
                        previousRingProbeSegment.colliderPointY = ringPoint.y + diffY * tooSharpLength
                    } else {
                        previousRingProbeSegment.colliderPointX = pointX
                        previousRingProbeSegment.colliderPointY = pointY
                    }
                }
            }
            previousIndex = currentIndex
            currentIndex += 1
        }
    }
}
