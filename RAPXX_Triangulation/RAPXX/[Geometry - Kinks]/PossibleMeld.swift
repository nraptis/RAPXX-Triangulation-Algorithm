//
//  PossibleMeld.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/13/24.
//

import Foundation

class PossibleMeld: PointProtocol {
    typealias Point = Math.Point
    var x: Float = 0.0
    var y: Float = 0.0
    var point: Point {
        Point(x: x,
              y: y)
    }
}
