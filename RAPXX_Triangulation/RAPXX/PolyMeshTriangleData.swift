//
//  PolyMeshTriangleData.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/17/24.
//

import Foundation

public class PolyMeshTriangleData {
    
    public init() {
        
    }
    
    public struct Triangle {
        public let index1: UInt32
        public let index2: UInt32
        public let index3: UInt32
    }
    
    public struct MapNode: Hashable, Equatable {
        public let x: Float
        public let y: Float
        
        public static func == (lhs: MapNode, rhs: MapNode) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
    }
    
    public struct VertexNode {
        public let x: Float
        public let y: Float
        public var isEdge: Bool
    }
    
    public private(set) var vertices = [VertexNode]()
    public private(set) var vertexCount = 0
    
    public private(set) var triangles = [Triangle]()
    public private(set) var triangleCount = 0
    
    private var map = [MapNode: UInt32]()
    
    public private(set) var baseIndex = UInt32(0)
    
    public func markEdge(x: Float, y: Float) {
        let mapNode = MapNode(x: x, y: y)
        guard let index = map[mapNode] else {
            return
        }
        vertices[Int(index)].isEdge = true
    }
    
    public func add(x1: Float, y1: Float,
                    x2: Float, y2: Float,
                    x3: Float, y3: Float) {
        
        var index1 = UInt32(0)
        var index2 = UInt32(0)
        var index3 = UInt32(0)
        
        let mapNode1 = MapNode(x: x1, y: y1)
        let mapNode2 = MapNode(x: x2, y: y2)
        let mapNode3 = MapNode(x: x3, y: y3)
        
        if let index = map[mapNode1] {
            index1 = index
        } else {
            let vertex = VertexNode(x: x1, y: y1, isEdge: false)
            while vertices.count <= vertexCount {
                vertices.append(vertex)
            }
            vertices[vertexCount] = vertex
            vertexCount += 1
            
            map[mapNode1] = baseIndex
            index1 = baseIndex
            baseIndex += 1
        }
        
        if let index = map[mapNode2] {
            index2 = index
        } else {
            let vertex = VertexNode(x: x2, y: y2, isEdge: false)
            while vertices.count <= vertexCount {
                vertices.append(vertex)
            }
            vertices[vertexCount] = vertex
            vertexCount += 1
            
            map[mapNode2] = baseIndex
            index2 = baseIndex
            baseIndex += 1
        }
        
        if let index = map[mapNode3] {
            index3 = index
        } else {
            let vertex = VertexNode(x: x3, y: y3, isEdge: false)
            while vertices.count <= vertexCount {
                vertices.append(vertex)
            }
            vertices[vertexCount] = vertex
            vertexCount += 1
            
            map[mapNode3] = baseIndex
            index3 = baseIndex
            baseIndex += 1
        }
        
        let triangle = Triangle(index1: index1, index2: index2, index3: index3)
        while triangles.count <= triangleCount {
            triangles.append(triangle)
        }
        triangles[triangleCount] = triangle
        triangleCount += 1
    }
    
    public func reset() {
        map.removeAll(keepingCapacity: true)
        vertexCount = 0
        triangleCount = 0
        baseIndex = 0
    }
    
}
