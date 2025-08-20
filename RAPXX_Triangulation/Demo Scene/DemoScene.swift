//
//  DemoScene.swift
//  RAPXX_Triangulation
//
//  Created by Nick on 8/19/25.
//

import Foundation
import Metal
import simd

class DemoScene: GraphicsDelegate {
    var graphics: Graphics?
    
    let lineBuffer = IndexedShapeBuffer2DColored()
    let triangleBuffer = IndexedShapeBuffer2DColored()
    let polypointBuffer = IndexedShapeBuffer2DColored()
    
    var projection = matrix_identity_float4x4
    var modelView = matrix_identity_float4x4
    
    var polypoints = [SIMD2<Float>]()
    var triangles = [Triangle]()
    var triangles_r = [Float]()
    var triangles_g = [Float]()
    var triangles_b = [Float]()
    
    
    func load() {
    
        let width: Float
        let height: Float
        if let graphics {
            lineBuffer.load(graphics: graphics)
            triangleBuffer.load(graphics: graphics)
            polypointBuffer.load(graphics: graphics)
            width = graphics.width
            height = graphics.height
        } else {
            width = 320.0
            height = 480.0
        }
        
        let raius = min(width, height) * 0.5 * (Device.isPad ? 0.75 : 0.85)
        let center = SIMD2<Float>(x: width / 2.0,
                                  y: height / 2.0)
        
        let pointCount = Device.isPad ? 40 : 24
        
        for tick in 0..<pointCount {
            let percent = Float(tick) / Float(pointCount)
            let angle = percent * Float.pi * 2.0
            let dirX = sinf(angle)
            let dirY = -cosf(angle)
            let x = center.x + raius * dirX
            let y = center.y + raius * dirY
            
            polypoints.append(.init(x: x, y: y))
        }
        
        triangulate()
    }
    
    func triangulate() {
        triangles = RAPXXTriangulator.shared.triangulate(points: polypoints)
        
        while triangles_r.count < triangles.count {
            triangles_r.append(Float.random(in: 0.25...0.75))
            triangles_g.append(Float.random(in: 0.25...0.75))
            triangles_b.append(Float.random(in: 0.25...0.75))
        }
        
    }
    
    func loadComplete() {
        
    }
    
    func initialize() {
        
    }
    
    func update(deltaTime: Float,
                stereoSpreadBase: Float,
                stereoSpreadMax: Float,
                isStereoscopicEnabled: Bool) {
        
    }
    
    func predraw(isStereoscopicEnabled: Bool) {
        
        if let graphics {
            projection.ortho(width: graphics.width, height: graphics.height)
        } else {
            projection.ortho(width: 320.0, height: 480.0)
        }
        modelView = matrix_identity_float4x4
        
        lineBuffer.reset()
        lineBuffer.modelViewMatrix = modelView
        lineBuffer.projectionMatrix = projection
        lineBuffer.cullMode = .none
        lineBuffer.primitiveType = .triangle
        
        triangleBuffer.reset()
        triangleBuffer.modelViewMatrix = modelView
        triangleBuffer.projectionMatrix = projection
        triangleBuffer.cullMode = .none
        triangleBuffer.primitiveType = .triangle
        
        
        polypointBuffer.reset()
        polypointBuffer.modelViewMatrix = modelView
        polypointBuffer.projectionMatrix = projection
        polypointBuffer.cullMode = .none
        polypointBuffer.primitiveType = .triangle
    }
    
    func draw3DPrebloom(renderEncoder: any MTLRenderCommandEncoder) {
        
    }
    
    func draw3DBloom(renderEncoder: any MTLRenderCommandEncoder) {
        
    }
    
    func draw3DStereoscopicBlue(renderEncoder: any MTLRenderCommandEncoder,
                                stereoSpreadBase: Float,
                                stereoSpreadMax: Float) {
        
    }
    
    func draw3DStereoscopicRed(renderEncoder: any MTLRenderCommandEncoder,
                               stereoSpreadBase: Float,
                               stereoSpreadMax: Float) {
        
    }
    
    func draw3D(renderEncoder: any MTLRenderCommandEncoder) {
        
    }
    
    func draw2D(renderEncoder: any MTLRenderCommandEncoder) {
        
        for point in polypoints {
            polypointBuffer.add(x: point.x - 3.0,
                                y: point.y - 3.0,
                                width: 7.0,
                                height: 7.0,
                                red: 0.15,
                                green: 0.15,
                                blue: 0.15,
                                alpha: 1.0)
        }
        for point in polypoints {
            polypointBuffer.add(x: point.x - 2.0,
                                y: point.y - 2.0,
                                width: 5.0,
                                height: 5.0,
                                red: 0.25,
                                green: 0.25,
                                blue: 0.75,
                                alpha: 1.0)
        }
        
        for index in triangles.indices {
        let triangle = triangles[index]
            let r = triangles_r[index]
            let g = triangles_g[index]
            let b = triangles_b[index]
            let a = Float(0.5)
         
            let x1 = Float(triangle.x1)
            let y1 = Float(triangle.y1)
            
            let x2 = Float(triangle.x2)
            let y2 = Float(triangle.y2)
            
            let x3 = Float(triangle.x3)
            let y3 = Float(triangle.y3)
            
            let v1 = Shape2DColoredVertex(x: x1, y: y1,
                                          r: r, g: g, b: b, a: a)
            let v2 = Shape2DColoredVertex(x: x2, y: y2,
                                          r: r, g: g, b: b, a: a)
            let v3 = Shape2DColoredVertex(x: x3, y: y3,
                                          r: r, g: g, b: b, a: a)
            
            triangleBuffer.add(vertex1: v1,
                               vertex2: v2,
                               vertex3: v3)
            
            triangleBuffer.add(index1: UInt32(index * 3),
                               index2: UInt32(index * 3 + 1),
                               index3: UInt32(index * 3 + 2))
            
        }
        
        
        for triangle in triangles {
            
            
            lineBuffer.add(lineX1: Float(triangle.x1),
                           lineY1: Float(triangle.y1),
                           lineX2: Float(triangle.x2),
                           lineY2: Float(triangle.y2),
                           lineThickness: 2,
                           translation: .zero,
                           scale: 1.0,
                           rotation: 0.0,
                           red: 1.0,
                           green: 0.25,
                           blue: 0.25,
                           alpha: 1.0)
            lineBuffer.add(lineX1: Float(triangle.x2),
                           lineY1: Float(triangle.y2),
                           lineX2: Float(triangle.x3),
                           lineY2: Float(triangle.y3),
                           lineThickness: 2,
                           translation: .zero,
                           scale: 1.0,
                           rotation: 0.0,
                           red: 1.0,
                           green: 0.25,
                           blue: 0.25,
                           alpha: 1.0)
            lineBuffer.add(lineX1: Float(triangle.x3),
                           lineY1: Float(triangle.y3),
                           lineX2: Float(triangle.x1),
                           lineY2: Float(triangle.y1),
                           lineThickness: 2,
                           translation: .zero,
                           scale: 1.0,
                           rotation: 0.0,
                           red: 1.0,
                           green: 0.25,
                           blue: 0.25,
                           alpha: 1.0)
        }
        
        triangleBuffer.render(renderEncoder: renderEncoder,
                              pipelineState: .shapeNodeColoredIndexed2DAlphaBlending)
        lineBuffer.render(renderEncoder: renderEncoder,
                          pipelineState: .shapeNodeColoredIndexed2DAlphaBlending)
        polypointBuffer.render(renderEncoder: renderEncoder,
                               pipelineState: .shapeNodeColoredIndexed2DAlphaBlending)
        
    }
    
    func postdraw() {
        
    }
    
    
    
}
