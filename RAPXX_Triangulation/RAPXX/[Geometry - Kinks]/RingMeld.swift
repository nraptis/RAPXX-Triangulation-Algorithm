//
//  RingMeld.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/13/24.
//

import Foundation

class RingMeld: PointProtocol {
    
    typealias Point = Math.Point
    
    var meldQuality = RingMeldQuality()
    
    // This is the exact x and y that the resultant probe point
    // would be at if we performed this meld.
    var x: Float = 0.0
    var y: Float = 0.0
    
    // This is the exact points we are going to meld...
    var ringProbePoints = [RingProbePoint]()
    var ringProbePointCount = 0
    
    var point: Point {
        Point(x: x,
              y: y)
    }
    
    func add(ringProbePoint: RingProbePoint) {
        while ringProbePoints.count <= ringProbePointCount {
            ringProbePoints.append(ringProbePoint)
        }
        ringProbePoints[ringProbePointCount] = ringProbePoint
        ringProbePointCount += 1
    }
}
