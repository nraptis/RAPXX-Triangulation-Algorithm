//
//  Ring+ClosestProbePoint.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/11/24.
//

import Foundation

extension Ring {
    func getClosestProbePoint(x: Float, y: Float, distance: Float) -> RingProbePoint? {
        var result: RingProbePoint?
        var bestDistance = distance * distance
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            let distanceSquared = ringProbePoint.distanceSquared(x: x, y: y)
            if distanceSquared < bestDistance {
                bestDistance = distanceSquared
                result = ringProbePoint
            }
        }
        return result
    }
}
