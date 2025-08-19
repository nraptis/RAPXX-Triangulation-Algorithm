//
//  RingProbeSegment.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/16/23.
//

import Foundation

class RingProbeSegment: PrecomputedLineSegment {
    
    // The line segment we are spawn'd from...!!!
    //unowned var lineSegment: RingLineSegment!
    
    unowned var ring: Ring!
    
    //unowned var neighborLeft: RingProbeSegment!
    //unowned var neighborRight: RingProbeSegment!
    
    var x1: Float = 0.0
    var y1: Float = 0.0
    
    var x2: Float = 0.0
    var y2: Float = 0.0
    
    var centerX: Float = 0.0
    var centerY: Float = 0.0
    
    var isIllegal = false
    
    //var isTagged = false
    
    var isBucketed = false
    
    var directionX = Float(0.0)
    var directionY = Float(-1.0)
    
    var normalX = Float(1.0)
    var normalY = Float(0.0)
    
    var lengthSquared = Float(1.0)
    var length = Float(1.0)
    
    var directionAngle = Float(0.0)
    var normalAngle = Float(0.0)
    
    var colliderPointX = Float(0.0)
    var colliderPointY = Float(0.0)
    
    var ringIndex: Int = 0
    
    unowned var neighborLeft: RingProbeSegment!
    unowned var neighborRight: RingProbeSegment!
    
    unowned var ringProbePointLeft: RingProbePoint!
    unowned var ringProbePointRight: RingProbePoint!
    
    unowned var ringPointLeft: RingPoint!
    unowned var ringPointRight: RingPoint!
    
    //var IS_DEBUG = false
    
    //var rightSegmentDoesIntersect = false
    //var rightSegmentIsInvalidNormal = false
    //var rightSegmentIsInvalidCoplanar = false
    //var rightSegmentIsInvalidTooFar = false
    //var rightSegmentIntersectionPoint = Point(x: 0.0, y: 0.0)
    
    //var leftSegmentDoesIntersect = false
    //var leftSegmentIsInvalidNormal = false
    //var leftSegmentIsInvalidCoplanar = false
    //var leftSegmentIsInvalidTooFar = false
    //var leftSegmentIntersectionPoint = Point(x: 0.0, y: 0.0)
    
    
    func setup(lineSegment: RingLineSegment) {
        
        let pointLeft = lineSegment.ringPointLeft!
        let threatLeft = pointLeft.threatLevel //max(lineSegment.threatLevel, lineSegment.neighborLeft.threatLevel)
        let ringInsetAmountLeft: Float
        switch threatLeft {
        case .none:
            ringInsetAmountLeft = PolyMeshConstants.ringInsetAmountThreatNone
        case .low:
            ringInsetAmountLeft = PolyMeshConstants.ringInsetAmountThreatLow
        case .medium:
            ringInsetAmountLeft = PolyMeshConstants.ringInsetAmountThreatMedium
        case .high:
            ringInsetAmountLeft = PolyMeshConstants.ringInsetAmountThreatHigh
        }
        
        let pointRight = lineSegment.ringPointRight!
        let threatRight = pointRight.threatLevel//max(lineSegment.threatLevel, lineSegment.neighborRight.threatLevel)
        let ringInsetAmountRight: Float
        switch threatRight {
        case .none:
            ringInsetAmountRight = PolyMeshConstants.ringInsetAmountThreatNone
        case .low:
            ringInsetAmountRight = PolyMeshConstants.ringInsetAmountThreatLow
        case .medium:
            ringInsetAmountRight = PolyMeshConstants.ringInsetAmountThreatMedium
        case .high:
            ringInsetAmountRight = PolyMeshConstants.ringInsetAmountThreatHigh
        }
        
        x1 = lineSegment.x1 + lineSegment.normalX * ringInsetAmountLeft
        y1 = lineSegment.y1 + lineSegment.normalY * ringInsetAmountLeft
        x2 = lineSegment.x2 + lineSegment.normalX * ringInsetAmountRight
        y2 = lineSegment.y2 + lineSegment.normalY * ringInsetAmountRight
        
        lineSegment.ringPointLeft.baseProbeLength = ringInsetAmountLeft
        lineSegment.ringPointRight.baseProbeLength = ringInsetAmountRight
        
        if threatRight == threatLeft {
            
            directionX = lineSegment.directionX
            directionY = lineSegment.directionY
            
            directionAngle = lineSegment.directionAngle
            
            normalX = lineSegment.normalX
            normalY = lineSegment.normalY
            
            normalAngle = lineSegment.normalAngle
            
            lengthSquared = lineSegment.lengthSquared
            length = lineSegment.length
            
            centerX = (x1 + x2) * 0.5
            centerY = (y1 + y2) * 0.5
        } else {
            precompute()
        }
    }
}
