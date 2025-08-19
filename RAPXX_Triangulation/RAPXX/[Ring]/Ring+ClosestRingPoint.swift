//
//  Ring+ClosestRingPoint.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/11/24.
//

import Foundation

extension Ring {
    func getClosestRingPoint(x: Float, y: Float, distance: Float) -> RingPoint? {
        var result: RingPoint?
        var bestDistance = distance * distance
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            let distanceSquared = ringPoint.distanceSquared(x: x, y: y)
            if distanceSquared < bestDistance {
                bestDistance = distanceSquared
                result = ringPoint
            }
        }
        return result
    }
}
