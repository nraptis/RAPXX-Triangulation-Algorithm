//
//  DelauneyTriangulationPoint.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/18/24.
//

import Foundation

public class DelauneyTriangulationPoint {
    public var x: Float
    public var y: Float
    unowned var vertex: DelauneyTriangulationVertex!
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

extension DelauneyTriangulationPoint: Equatable {
    public static func == (lhs: DelauneyTriangulationPoint, rhs: DelauneyTriangulationPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension DelauneyTriangulationPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
