//
//  RAPXXTriangulator.swift
//  RAPXX_Triangulation
//
//  Created by Nick on 8/19/25.
//

import Foundation
import simd

final class RAPXXTriangulator {
    
    let triangulationData = PolyMeshTriangleData()
    
    nonisolated(unsafe) static let shared = RAPXXTriangulator()
    
    func triangulate(points: [SIMD2<Float>],
                     ignoreDuplicates: Bool = true) -> [Triangle] {
        
        let ring = PolyMeshPartsFactory.shared.withdrawRing(triangleData: triangulationData)
        
        var result = [Triangle]()
        
        triangulationData.reset()
        
        ring.addPointsBegin(depth: 0)
        
        for pointIndex in points.indices {
            let point = points[pointIndex]
            ring.addPoint(x: point.x,
                          y: point.y,
                          controlIndex: pointIndex)
        }
        
        ring.isBroken = false
        
        var fixOuterRing = true
        while fixOuterRing {
            fixOuterRing = false
            if ring.ringPointCount >= 3 {
                if ring.containsDuplicatePointsOuter() {
                    ring.resolveOneDuplicatePointOuter()
                    fixOuterRing = true
                }
            }
        }
        
        if ring.isCounterClockwiseRingPoints() {
            ring.resolveCounterClockwiseRingPoints()
        }
        
        if !ring.attemptToBeginBuildAndCheckIfBroken(needsPointInsidePolygonBucket: true,
                                                     needsLineSegmentBucket: true,
                                                     ignoreDuplicates: ignoreDuplicates) {
            return result
        }
        
        ring.meshifyRecursively(needsSafetyCheckA: false, needsSafetyCheckB: false)
        
        for triangleIndex in 0..<triangulationData.triangleCount {
            let triangle = triangulationData.triangles[triangleIndex]
            let index1 = triangle.index1
            let index2 = triangle.index2
            let index3 = triangle.index3
            
            let vertex1 = triangulationData.vertices[Int(index1)]
            let vertex2 = triangulationData.vertices[Int(index2)]
            let vertex3 = triangulationData.vertices[Int(index3)]
            
            result.append(Triangle(x1: CGFloat(vertex1.x), y1: CGFloat(vertex1.y),
                                   x2: CGFloat(vertex2.x), y2: CGFloat(vertex2.y),
                                   x3: CGFloat(vertex3.x), y3: CGFloat(vertex3.y)))
        }
        
        PolyMeshPartsFactory.shared.depositRing(ring)
        return result
    }
    
    
}
