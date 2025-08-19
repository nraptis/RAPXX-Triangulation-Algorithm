//
//  RingProbePointSpoke.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/14/24.
//

import Foundation

class RingProbeSpoke: PrecomputedLineSegment {
    
    var isIllegal = false
    //var isTagged: Bool = false
    
    var x1: Float = 0.0
    var y1: Float = 0.0
    
    var x2: Float = 0.0
    var y2: Float = 0.0
    
    var centerX: Float = 0.0
    var centerY: Float = 0.0
    
    var directionX = Float(0.0)
    var directionY = Float(-1.0)
    
    var normalX = Float(1.0)
    var normalY = Float(0.0)
    
    var lengthSquared = Float(1.0)
    var length = Float(1.0)
    
    var directionAngle = Float(0.0)
    var normalAngle = Float(0.0)
    
    unowned var connection: RingPoint!
    
    init() {
        
    }
    
    func precomputeStep1(connection: RingPoint) {
        self.connection = connection
        x2 = connection.x
        y2 = connection.y
    }
    
    func precomputeStep2(x: Float, y: Float) {
        x1 = x
        y1 = y
        precompute()
    }
    
    func shortestConnectingLineSegmentToLineSegment(_ ringLineSegment: RingLineSegment) -> (point1: Point, point2: Point) {
        Math.lineSegmentShortestConnectingLineSegmentToLineSegment(line1Point1: p1, line1Point2: p2, line2Point1: ringLineSegment.p1, line2Point2: ringLineSegment.p2)
    }
    
}
