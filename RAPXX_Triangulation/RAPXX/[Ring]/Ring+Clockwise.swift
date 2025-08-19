//
//  Ring+ClockWise.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/22/23.
//

import Foundation

extension Ring {
    
    public func isCounterClockwiseRingPoints() -> Bool {
        var area = Float(0.0)
        var index1 = ringPointCount - 1
        var index2 = 0
        while index2 < ringPointCount {
            area += Math.cross(x1: ringPoints[index1].x, y1: ringPoints[index1].y,
                               x2: ringPoints[index2].x, y2: ringPoints[index2].y)
            index1 = index2
            index2 += 1
        }
        return area < 0.0
    }
    
    public func isCounterClockwiseProbePoints() -> Bool {
        var area = Float(0.0)
        var index1 = ringProbePointCount - 1
        var index2 = 0
        while index2 < ringProbePointCount {
            area += Math.cross(x1: ringProbePoints[index1].x, y1: ringProbePoints[index1].y,
                               x2: ringProbePoints[index2].x, y2: ringProbePoints[index2].y)
            index1 = index2
            index2 += 1
        }
        return area < 0.0
    }
    
    public func resolveCounterClockwiseRingPoints() {
        var startIndex = 0
        var endIndex = ringPointCount - 1
        while startIndex < endIndex {
            
            let tempRingPoint = ringPoints[startIndex]
            ringPoints[startIndex] = ringPoints[endIndex]
            ringPoints[endIndex] = tempRingPoint
            
            startIndex += 1
            endIndex -= 1
        }
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            ringPoint.ringIndex = ringPointIndex
        }
    }
}
