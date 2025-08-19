//
//  Ring+FastTriangulate.swift
//  RAPXX
//
//  Created by Nick Raptis on 3/12/24.
//

import Foundation

extension Ring {
    
    public func meshifyWithFastAlgorithm() {
        
        let minX = getMinX() - 2.0
        let maxX = getMaxX() + 2.0
        let minY = getMinY() - 2.0
        let maxY = getMaxY() + 2.0
        
        let rangeX = maxX - minX
        let rangeY = maxY - minY
        
        var sweepLineCountH = Int((rangeX / PolyMeshConstants.sweepLineDivison) + 0.5)
        if sweepLineCountH < 3 {
            sweepLineCountH = 3
        }
        
        var sweepLineCountV = Int((rangeY / PolyMeshConstants.sweepLineDivison) + 0.5)
        if sweepLineCountV < 3 {
            sweepLineCountV = 3
        }
        
        if let triangleData {
            FastTriangulator.shared.triangulate(polyMeshTriangleData: triangleData,
                                                ringLineSegmentBucket: ringLineSegmentBucket,
                                                ringPointInsidePolygonBucket: ringPointInsidePolygonBucket,
                                                minX: minX,
                                                minY: minY,
                                                maxX: maxX,
                                                maxY: maxY,
                                                sweepLineCountH: sweepLineCountH,
                                                sweepLineCountV: sweepLineCountV)
        }
    }
    
}
