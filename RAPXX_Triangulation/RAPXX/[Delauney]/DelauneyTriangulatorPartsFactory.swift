//
//  DelauneyTriangulatorPartsFactory.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/21/23.
//

import Foundation

public class DelauneyTriangulatorPartsFactory {
    
    public func dispose() {
        triangulationPoints.removeAll(keepingCapacity: false)
            triangulationPointCount = 0



        triangulationVertices.removeAll(keepingCapacity: false)
            triangulationVertexCount = 0

        triangulationEdges.removeAll(keepingCapacity: false)
            triangulationEdgeCount = 0


        triangulationFaces.removeAll(keepingCapacity: false)
            triangulationFaceCount = 0


        triangulationTriangles.removeAll(keepingCapacity: false)
            triangulationTriangleCount = 0


        triangulationLineSegments.removeAll(keepingCapacity: false)
            triangulationLineSegmentCount = 0
    }
    
    
    ////////////////
    ///
    private var triangulationPoints = [DelauneyTriangulationPoint]()
    var triangulationPointCount = 0
    func depositDelauneyTriangulationPoint(_ triangulationPoint: DelauneyTriangulationPoint) {
        
        while triangulationPoints.count <= triangulationPointCount {
            triangulationPoints.append(triangulationPoint)
        }
        triangulationPoints[triangulationPointCount] = triangulationPoint
        triangulationPointCount += 1
    }
    func withdrawDelauneyTriangulationPoint(x: Float, y: Float) -> DelauneyTriangulationPoint {
        if triangulationPointCount > 0 {
            triangulationPointCount -= 1
            let result = triangulationPoints[triangulationPointCount]
            result.x = x
            result.y = y
            return result
        }
        return DelauneyTriangulationPoint(x: x, y: y)
    }
    ///
    ////////////////
    
    ////////////////
    ///
    private var triangulationVertices = [DelauneyTriangulationVertex]()
    var triangulationVertexCount = 0
    func depositDelauneyTriangulationVertex(_ triangulationVertex: DelauneyTriangulationVertex) {
        while triangulationVertices.count <= triangulationVertexCount {
            triangulationVertices.append(triangulationVertex)
        }
        triangulationVertices[triangulationVertexCount] = triangulationVertex
        triangulationVertexCount += 1
    }
    func withdrawDelauneyTriangulationVertex(point: DelauneyTriangulationPoint) -> DelauneyTriangulationVertex {
        if triangulationVertexCount > 0 {
            triangulationVertexCount -= 1
            let result = triangulationVertices[triangulationVertexCount]
            result.point = point
            point.vertex = result
            return result
        }
        return DelauneyTriangulationVertex(point: point)
    }
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var triangulationEdges = [DelauneyTriangulationEdge]()
    var triangulationEdgeCount = 0
    func depositDelauneyTriangulationEdge(_ triangulationEdge: DelauneyTriangulationEdge) {
        
        triangulationEdge.clear()
        
        while triangulationEdges.count <= triangulationEdgeCount {
            triangulationEdges.append(triangulationEdge)
        }
        triangulationEdges[triangulationEdgeCount] = triangulationEdge
        triangulationEdgeCount += 1
    }
    
    func withdrawDelauneyTriangulationEdge(vertex: DelauneyTriangulationVertex) -> DelauneyTriangulationEdge {
        if triangulationEdgeCount > 0 {
            triangulationEdgeCount -= 1
            let result = triangulationEdges[triangulationEdgeCount]
            result.vertex = vertex
            return result
        }
        return DelauneyTriangulationEdge(vertex: vertex)
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var triangulationFaces = [DelauneyTriangulationFace]()
    var triangulationFaceCount = 0
    func depositDelauneyTriangulationFace(_ triangulationFace: DelauneyTriangulationFace) {
        while triangulationFaces.count <= triangulationFaceCount {
            triangulationFaces.append(triangulationFace)
        }
        triangulationFaces[triangulationFaceCount] = triangulationFace
        triangulationFaceCount += 1
    }
    
    func withdrawDelauneyTriangulationFace(edge: DelauneyTriangulationEdge) -> DelauneyTriangulationFace {
        if triangulationFaceCount > 0 {
            triangulationFaceCount -= 1
            let result = triangulationFaces[triangulationFaceCount]
            result.edge = edge
            return result
        }
        return DelauneyTriangulationFace(edge: edge)
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var triangulationTriangles = [DelauneyTriangulationTriangle]()
    var triangulationTriangleCount = 0
    func depositDelauneyTriangulationTriangle(_ triangulationTriangle: DelauneyTriangulationTriangle) {
        while triangulationTriangles.count <= triangulationTriangleCount {
            triangulationTriangles.append(triangulationTriangle)
        }
        triangulationTriangles[triangulationTriangleCount] = triangulationTriangle
        triangulationTriangleCount += 1
    }
    
    func withdrawDelauneyTriangulationTriangle(point1: DelauneyTriangulationPoint, point2: DelauneyTriangulationPoint, point3: DelauneyTriangulationPoint) -> DelauneyTriangulationTriangle {
        if triangulationTriangleCount > 0 {
            triangulationTriangleCount -= 1
            let result = triangulationTriangles[triangulationTriangleCount]
            result.point1 = point1
            result.point2 = point2
            result.point3 = point3
            return result
        }
        return DelauneyTriangulationTriangle(point1: point1, point2: point2, point3: point3)
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var triangulationLineSegments = [DelauneyTriangulationLineSegment]()
    var triangulationLineSegmentCount = 0
    func depositDelauneyTriangulationLineSegment(_ triangulationLineSegment: DelauneyTriangulationLineSegment) {
        while triangulationLineSegments.count <= triangulationLineSegmentCount {
            triangulationLineSegments.append(triangulationLineSegment)
        }
        triangulationLineSegments[triangulationLineSegmentCount] = triangulationLineSegment
        triangulationLineSegmentCount += 1
    }
    
    func withdrawDelauneyTriangulationLineSegment(point1: DelauneyTriangulationPoint, point2: DelauneyTriangulationPoint) -> DelauneyTriangulationLineSegment {
        if triangulationLineSegmentCount > 0 {
            triangulationLineSegmentCount -= 1
            let result = triangulationLineSegments[triangulationLineSegmentCount]
            result.point1 = point1
            result.point2 = point2
            return result
        }
        return DelauneyTriangulationLineSegment(point1: point1, point2: point2)
    }
    ///
    ///
    ////////////////
    
}
