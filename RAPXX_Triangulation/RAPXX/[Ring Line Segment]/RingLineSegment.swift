//
//  PolyMeshLineSegment.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/15/23.
//

import Foundation

public class RingLineSegment: PrecomputedLineSegment {
    
    enum ThreatLevel: UInt8, Comparable {
        case none = 0
        case low = 1
        case medium = 2
        case high = 3
        
        static func < (lhs: RingLineSegment.ThreatLevel, rhs: RingLineSegment.ThreatLevel) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    public var isIllegal = false
    
    var isBucketed = false
    
    public var x1: Float = 0.0
    public var y1: Float = 0.0
    
    public var x2: Float = 0.0
    public var y2: Float = 0.0
    
    public var centerX: Float = 0.0
    public var centerY: Float = 0.0
    
    var ringIndex: Int = 0
    
    unowned var neighborLeft: RingLineSegment!
    unowned var neighborRight: RingLineSegment!
    
    unowned var ringPointLeft: RingPoint!
    unowned var ringPointRight: RingPoint!
    
    public var directionX = Float(0.0)
    public var directionY = Float(-1.0)
    
    public var normalX = Float(1.0)
    public var normalY = Float(0.0)
    
    public var lengthSquared = Float(1.0)
    public var length = Float(1.0)
    
    public var directionAngle = Float(0.0)
    public var normalAngle = Float(0.0)
    
    func shortestConnectingLineSegmentToLineSegment(_ ringLineSegment: RingLineSegment) -> (point1: Point, point2: Point) {
        Math.lineSegmentShortestConnectingLineSegmentToLineSegment(line1Point1: p1, line1Point2: p2, line2Point1: ringLineSegment.p1, line2Point2: ringLineSegment.p2)
    }
}
