//
//  Ring+ProbePointsTooFarApart.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/21/24.
//

import Foundation

extension Ring {
    
    func containsProbePointsThatAreTooFarApart() -> Bool {
        var index1 = ringProbePointCount - 1
        var index2 = 0
        while index2 < ringProbePointCount {
            let ringProbePoint1 = ringProbePoints[index1]
            let ringProbePoint2 = ringProbePoints[index2]
            let distanceSquared = ringProbePoint1.distanceSquared(x: ringProbePoint2.x, y: ringProbePoint2.y)
            if distanceSquared > PolyMeshConstants.pointTooFarSquared {
                return true
            }
            index1 = index2
            index2 += 1
        }
        return false
    }
    
    func resolveProbePointsThatAreTooFarApart() {
        
        temp_1_ringProbePointCount = 0
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            
            addTemp_1_RingProbePoint(ringProbePoint)
            
            var nextRingProbePointIndex = ringProbePointIndex + 1
            if nextRingProbePointIndex == ringProbePointCount {
                nextRingProbePointIndex = 0
            }
            
            let nextRingProbePoint = ringProbePoints[nextRingProbePointIndex]
            let distanceSquared = ringProbePoint.distanceSquared(x: nextRingProbePoint.x,
                                                                 y: nextRingProbePoint.y)
            if distanceSquared > PolyMeshConstants.pointTooFarSquared {
                
                let midPointX = (ringProbePoint.x + nextRingProbePoint.x) * 0.5
                let midPointY = (ringProbePoint.y + nextRingProbePoint.y) * 0.5
                
                let newProbePoint = PolyMeshPartsFactory.shared.withdrawRingProbePoint()
                newProbePoint.x = midPointX
                newProbePoint.y = midPointY
                
                if ringProbePoint.connectionCount > 0 {
                    newProbePoint.addConnection(ringProbePoint.connections[ringProbePoint.connectionCount - 1])
                }
                
                if nextRingProbePoint.connectionCount > 0 {
                    let connection = nextRingProbePoint.connections[0]
                    if !(newProbePoint.connectionCount > 0 && newProbePoint.connections[newProbePoint.connectionCount - 1] === connection) {
                        newProbePoint.addConnection(connection)
                    }
                }
                
                addTemp_1_RingProbePoint(newProbePoint)
            }
        }
        
        ringProbePointCount = 0
        for ringProbePointIndex in 0..<temp_1_ringProbePointCount {
            let ringProbePoint = temp_1_ringProbePoints[ringProbePointIndex]
            addRingProbePoint(ringProbePoint)
        }
        
        temp_1_ringProbePointCount = 0
    }
}
