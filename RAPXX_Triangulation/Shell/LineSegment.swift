//
//  LineSegment.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/18/23.
//

import Foundation

public protocol LineSegment: AnyObject {
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    var x1: Float { set get }
    var y1: Float { set get }
    var x2: Float { set get }
    var y2: Float { set get }
}

public extension LineSegment {
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
    
    func intersects(lineSegment: LineSegment) -> Bool {
        Math.lineSegmentIntersectsLineSegment(line1Point1X: x1,
                                              line1Point1Y: y1,
                                              line1Point2X: x2,
                                              line1Point2Y: y2,
                                              line2Point1X: lineSegment.x1,
                                              line2Point1Y: lineSegment.y1,
                                              line2Point2X: lineSegment.x2,
                                              line2Point2Y: lineSegment.y2)
    }
    
}

