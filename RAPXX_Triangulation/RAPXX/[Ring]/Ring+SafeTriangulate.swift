//
//  Ring+SafeTriangulate.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/3/23.
//

import Foundation

extension Ring {
    
    func meshifyWithSafeAlgorithm() {
        
        let minX = getMinX() - 2.0
        let maxX = getMaxX() + 2.0
        let minY = getMinY() - 2.0
        let maxY = getMaxY() + 2.0
        
        let rangeX = maxX - minX
        let rangeY = maxY - minY
        
        if rangeX > rangeY {
            var sweepLineCount = Int((rangeX / PolyMeshConstants.sweepLineDivison) + 0.5)
            if sweepLineCount < 3 {
                sweepLineCount = 3
            }
            
            calculateSweepLinesVertical(count: sweepLineCount, minX: minX, maxX: maxX, rangeX: rangeX)
            calculateSweepCollisionsVertical(minY: minY, maxY: maxY, rangeY: rangeY)
            calculateSweepSegmentsVertical(minY: minY, maxY: maxY, rangeY: rangeY)
            calculateSweepPointsVertical()
            
        } else {
            var sweepLineCount = Int((rangeY / PolyMeshConstants.sweepLineDivison) + 0.5)
            if sweepLineCount < 3 {
                sweepLineCount = 3
            }
            
            calculateSweepLinesHorizontal(count: sweepLineCount, minY: minY, maxY: maxY, rangeY: rangeY)
            calculateSweepCollisionsHorizontal(minX: minX, maxX: maxX, rangeX: rangeX)
            calculateSweepSegmentsHorizontal(minX: minX, maxX: maxX, rangeX: rangeX)
            calculateSweepPointsHorizontal()
        }
        
        let triangulator = DelauneyTriangulator.shared
        triangulator.triangulate(points: ringSweepPoints,
                                 pointCount: ringSweepPointCount,
                                 hull: ringPoints,
                                 hullCount: ringPointCount)
        
        if let triangleData {
            for triangleIndex in 0..<triangulator.triangleCount {
                let triangle = triangulator.triangles[triangleIndex]
                triangleData.add(x1: triangle.point1.x, y1: triangle.point1.y,
                                 x2: triangle.point3.x, y2: triangle.point3.y,
                                 x3: triangle.point2.x, y3: triangle.point2.y)
            }
        }
        PolyMeshPartsFactory.shared.depositRingContent(self)
    }
}
