//
//  PrecomputedLineSegment.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/18/23.
//

import Foundation

public protocol PrecomputedLineSegment: LineSegment {
    
    var centerX: Float { get set }
    var centerY: Float { get set }
    
    var directionX: Float { set get }
    var directionY: Float { set get }
    
    var normalX: Float { set get }
    var normalY: Float { set get }
    
    var lengthSquared: Float { set get }
    var length: Float { set get }
    
    var directionAngle: Float { set get }
    var normalAngle: Float { set get }
    
    var isIllegal: Bool { get set }
    
    func precompute()
}

public extension PrecomputedLineSegment {
    var p1: Point {
        get {
            Point(x: x1, y: y1)
        }
        set {
            x1 = newValue.x
            y1 = newValue.y
        }
    }
    
    var p2: Point {
        get {
            Point(x: x2, y: y2)
        }
        set {
            x2 = newValue.x
            y2 = newValue.y
        }
    }
    
    var center: Point {
        get {
            Point(x: centerX, y: centerY)
        }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }
    
    func closestPoint(_ point: Point) -> Point {
        var result = Point(x: x1, y: y1)
        let factor1X = point.x - x1
        let factor1Y = point.y - y1
        if lengthSquared > Math.epsilon {
            let scalar = directionX * factor1X + directionY * factor1Y
            if scalar <= 0.0 {
                // stay at p1
            } else if scalar >= length {
                result.x = x2
                result.y = y2
            } else {
                result.x = x1 + directionX * scalar
                result.y = y1 + directionY * scalar
            }
        }
        return result
    }
    
    func closestPoint(_ x: Float, _ y: Float) -> Point {
        var result = Point(x: x1, y: y1)
        let factor1X = x - x1
        let factor1Y = y - y1
        if lengthSquared > Math.epsilon {
            let scalar = directionX * factor1X + directionY * factor1Y
            if scalar <= 0.0 {
                // stay at p1
            } else if scalar >= length {
                result.x = x2
                result.y = y2
            } else {
                result.x = x1 + directionX * scalar
                result.y = y1 + directionY * scalar
            }
        }
        return result
    }
    
    func closestPoint(_ point: Point, _ targetX: inout Float, _ targetY: inout Float) {
        targetX = x1
        targetY = y1
        let factor1X = point.x - x1
        let factor1Y = point.y - y1
        if lengthSquared > Math.epsilon {
            let scalar = directionX * factor1X + directionY * factor1Y
            if scalar <= 0.0 {
                // stay at p1
            } else if scalar >= length {
                targetX = x2
                targetY = y2
            } else {
                targetX = x1 + directionX * scalar
                targetY = y1 + directionY * scalar
            }
        }
    }
    
    func closestPoint(_ x: Float, _ y: Float, _ targetX: inout Float, _ targetY: inout Float) {
        targetX = x1
        targetY = y1
        let factor1X = x - x1
        let factor1Y = y - y1
        if lengthSquared > Math.epsilon {
            let scalar = directionX * factor1X + directionY * factor1Y
            if scalar <= 0.0 {
                // stay at p1
            } else if scalar >= length {
                targetX = x2
                targetY = y2
            } else {
                targetX = x1 + directionX * scalar
                targetY = y1 + directionY * scalar
            }
        }
    }
    
    @inline(__always) func distanceSquaredToClosestPoint(_ x: Float, _ y: Float) -> Float {
        
        let factor1X = x - x1
        let factor1Y = y - y1
        if lengthSquared > Math.epsilon {
            let scalar = directionX * factor1X + directionY * factor1Y
            if scalar <= 0.0 {
                let diffX = x1 - x
                let diffY = y1 - y
                let result = diffX * diffX + diffY * diffY
                return result
            } else if scalar >= length {
                let diffX = x2 - x
                let diffY = y2 - y
                let result = diffX * diffX + diffY * diffY
                return result
            } else {
                let closestX = x1 + directionX * scalar
                let closestY = y1 + directionY * scalar
                let diffX = closestX - x
                let diffY = closestY - y
                let result = diffX * diffX + diffY * diffY
                return result
            }
        }
        return 0.0
    }
    
    func distanceSquaredToPoint(_ point: Point) -> Float {
        let closestPoint = closestPoint(point)
        return closestPoint.distanceSquaredTo(point)
    }
    
    func closestPointIsOnSegment(_ point: Point) -> Bool {
        let factor1X = point.x - x1
        let factor1Y = point.y - y1
        if lengthSquared > Math.epsilon {
            let scalar = directionX * factor1X + directionY * factor1Y
            if scalar < 0.0 || scalar > length {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func distanceSquaredToLineSegment(_ lineSegment: PrecomputedLineSegment) -> Float {
        
        if Math.lineSegmentIntersectsLineSegment(line1Point1X: x1, line1Point1Y: y1,
                                                 line1Point2X: x2, line1Point2Y: y2,
                                                 line2Point1X: lineSegment.x1, line2Point1Y: lineSegment.y1,
                                                 line2Point2X: lineSegment.x2, line2Point2Y: lineSegment.y2) {
            return 0.0
        }
        
        let cp1_1 = closestPoint(lineSegment.p1)
        let cp1_2 = closestPoint(lineSegment.p2)
        let cp2_1 = lineSegment.closestPoint(p1)
        let cp2_2 = lineSegment.closestPoint(p2)
        
        let distance0 = cp1_1.distanceSquaredTo(cp2_1)
        let distance1 = cp1_1.distanceSquaredTo(cp2_2)
        let distance2 = cp1_2.distanceSquaredTo(cp2_1)
        let distance3 = cp1_2.distanceSquaredTo(cp2_2)
        
        var chosenDistance = distance0
        if distance1 < chosenDistance { chosenDistance = distance1 }
        if distance2 < chosenDistance { chosenDistance = distance2 }
        if distance3 < chosenDistance { chosenDistance = distance3 }
        return chosenDistance
    }
    
    func precompute() {
        center.x = (x1 + x2) * 0.5
        center.y = (y1 + y2) * 0.5
        directionX = x2 - x1
        directionY = y2 - y1
        lengthSquared = directionX * directionX + directionY * directionY
        if lengthSquared > Math.epsilon {
            length = sqrtf(lengthSquared)
            directionX /= length
            directionY /= length
            isIllegal = false
        } else {
            directionX = Float(0.0)
            directionY = Float(-1.0)
            length = 0.0
            isIllegal = true
        }
        
        normalX = -directionY
        normalY = directionX
        
        directionAngle = -atan2f(-directionX, -directionY)
        
        normalAngle = directionAngle + Math.pi_2
        if normalAngle >= Math.pi2 { normalAngle -= Math.pi2 }
        if normalAngle < 0.0 { normalAngle += Math.pi2 }
    }
    
    func writeTo(_ precomputedLineSegment: PrecomputedLineSegment) {
        precomputedLineSegment.isIllegal = isIllegal
        precomputedLineSegment.x1 = x1
        precomputedLineSegment.y1 = y1
        precomputedLineSegment.x2 = x2
        precomputedLineSegment.y2 = y2
        precomputedLineSegment.centerX = centerX
        precomputedLineSegment.centerY = centerY
        precomputedLineSegment.directionX = directionX
        precomputedLineSegment.directionY = directionY
        precomputedLineSegment.normalX = normalX
        precomputedLineSegment.normalY = normalY
        precomputedLineSegment.lengthSquared = lengthSquared
        precomputedLineSegment.length = length
        precomputedLineSegment.directionAngle = directionAngle
        precomputedLineSegment.normalAngle = normalAngle
    }
    
    func readFrom(_ precomputedLineSegment: PrecomputedLineSegment) {
        isIllegal = precomputedLineSegment.isIllegal
        x1 = precomputedLineSegment.x1
        y1 = precomputedLineSegment.y1
        x2 = precomputedLineSegment.x2
        y2 = precomputedLineSegment.y2
        centerX = precomputedLineSegment.centerX
        centerY = precomputedLineSegment.centerY
        directionX = precomputedLineSegment.directionX
        directionY = precomputedLineSegment.directionY
        normalX = precomputedLineSegment.normalX
        normalY = precomputedLineSegment.normalY
        lengthSquared = precomputedLineSegment.lengthSquared
        length = precomputedLineSegment.length
        directionAngle = precomputedLineSegment.directionAngle
        normalAngle = precomputedLineSegment.normalAngle
    }
}

public class AnyPrecomputedLineSegment: PrecomputedLineSegment {
    
    public init() {
        
    }
    
    public var x1: Float = 0.0
    public var y1: Float = 0.0
    
    public var x2: Float = 0.0
    public var y2: Float = 0.0
    
    public var isIllegal: Bool = false
    public var isTagged: Bool = false
    
    public var centerX: Float = 0.0
    public var centerY: Float = 0.0
    
    public var directionX = Float(0.0)
    public var directionY = Float(-1.0)
    
    public var normalX = Float(1.0)
    public var normalY = Float(0.0)
    
    public var lengthSquared = Float(1.0)
    public var length = Float(1.0)
    
    public var directionAngle = Float(0.0)
    public var normalAngle = Float(0.0)
    
    public func copyFrom(_ anyPrecomputedLineSegment: AnyPrecomputedLineSegment) {
        x1 = anyPrecomputedLineSegment.x1
        y1 = anyPrecomputedLineSegment.y1
        x2 = anyPrecomputedLineSegment.x2
        y2 = anyPrecomputedLineSegment.y2
        
        isIllegal = anyPrecomputedLineSegment.isIllegal
        isTagged = anyPrecomputedLineSegment.isTagged
        
        centerX = anyPrecomputedLineSegment.centerX
        centerY = anyPrecomputedLineSegment.centerY
        
        directionX = anyPrecomputedLineSegment.directionX
        directionY = anyPrecomputedLineSegment.directionY
        
        normalX = anyPrecomputedLineSegment.normalX
        normalY = anyPrecomputedLineSegment.normalY
        
        lengthSquared = anyPrecomputedLineSegment.lengthSquared
        length = anyPrecomputedLineSegment.length
        
        directionAngle = anyPrecomputedLineSegment.directionAngle
        normalAngle = anyPrecomputedLineSegment.normalAngle
    }
    
    public func copyTo(_ anyPrecomputedLineSegment: AnyPrecomputedLineSegment) {
        anyPrecomputedLineSegment.x1 = x1
        anyPrecomputedLineSegment.y1 = y1
        anyPrecomputedLineSegment.x2 = x2
        anyPrecomputedLineSegment.y2 = y2
        
        anyPrecomputedLineSegment.isIllegal = isIllegal
        anyPrecomputedLineSegment.isTagged = isTagged
        
        anyPrecomputedLineSegment.centerX = centerX
        anyPrecomputedLineSegment.centerY = centerY
        
        anyPrecomputedLineSegment.directionX = directionX
        anyPrecomputedLineSegment.directionY = directionY
        
        anyPrecomputedLineSegment.normalX = normalX
        anyPrecomputedLineSegment.normalY = normalY
        
        anyPrecomputedLineSegment.lengthSquared = lengthSquared
        anyPrecomputedLineSegment.length = length
        
        anyPrecomputedLineSegment.directionAngle = directionAngle
        anyPrecomputedLineSegment.normalAngle = normalAngle
    }
}
