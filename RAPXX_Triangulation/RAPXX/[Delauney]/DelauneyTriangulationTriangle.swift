//
//  DelauneyTriangulationTriangle.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/18/24.
//

import Foundation

public class DelauneyTriangulationTriangle {
    public var point1: DelauneyTriangulationPoint
    public var point2: DelauneyTriangulationPoint
    public var point3: DelauneyTriangulationPoint
    init(point1: DelauneyTriangulationPoint,
         point2: DelauneyTriangulationPoint,
         point3: DelauneyTriangulationPoint) {
        self.point1 = point1
        self.point2 = point2
        self.point3 = point3
    }
}
