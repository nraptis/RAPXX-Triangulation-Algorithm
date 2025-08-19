//
//  Sprite2D.swift
//  StereoScope
//
//  Created by Nick Raptis on 5/24/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import simd

public class SpriteInstance2D {
    
    public init() {
        
    }
    
    public enum BlendMode {
        case none
        case alpha
        case additive
        case premultiplied
    }
    
    public var blendMode = BlendMode.none
    
    public private(set) weak var texture: MTLTexture?
    public private(set) weak var graphics: Graphics?
    
    private var uniformsVertex = UniformsSpriteVertex()
    private var uniformsFragment = UniformsSpriteFragment()
    private var uniformsVertexBuffer: MTLBuffer?
    private var uniformsFragmentBuffer: MTLBuffer?
    
    private var vertexBuffer: MTLBuffer?
    private var indexBuffer: MTLBuffer?
    
    private var vertices = [Sprite2DVertex](repeating: Sprite2DVertex(x: 0.0,
                                                                      y: 0.0,
                                                                      u: 0.0,
                                                                      v: 0.0), count: 4)
    
    private var indices: [UInt32] = [0, 1, 2, 3]
    
    var samplerState = Graphics.SamplerState.linearClamp
    
    var isVertexBufferDirty = true
    var isIndexBufferDirty = true
    
    var isUniformsVertexBufferDirty = true
    var isUniformsFragmentBufferDirty = true
    
    public func set(x: Float, y: Float, width: Float, height: Float) {
        set(x1: x,
            x2: x + width,
            y1: y,
            y2: y + height)
    }
    
    public func set(x1: Float, x2: Float, y1: Float, y2: Float) {
        //
        setX1(x1)
        setY1(y1)
        //
        setX2(x2)
        setY2(y1)
        //
        setX3(x1)
        setY3(y2)
        //
        setX4(x2)
        setY4(y2)
        //
    }
    
    public func setX1(_ value: Float) {
        if vertices[0].x != value {
            vertices[0].x = value
            isVertexBufferDirty = true
        }
    }
    
    public func setY1(_ value: Float) {
        if vertices[0].y != value {
            vertices[0].y = value
            isVertexBufferDirty = true
        }
    }
    
    public func setU1(_ value: Float) {
        if vertices[0].u != value {
            vertices[0].u = value
            isVertexBufferDirty = true
        }
    }
    
    public func setV1(_ value: Float) {
        if vertices[0].v != value {
            vertices[0].v = value
            isVertexBufferDirty = true
        }
    }
    
    public func setX2(_ value: Float) {
        if vertices[1].x != value {
            vertices[1].x = value
            isVertexBufferDirty = true
        }
    }
    
    public func setY2(_ value: Float) {
        if vertices[1].y != value {
            vertices[1].y = value
            isVertexBufferDirty = true
        }
    }
    
    public func setU2(_ value: Float) {
        if vertices[1].u != value {
            vertices[1].u = value
            isVertexBufferDirty = true
        }
    }
    
    public func setV2(_ value: Float) {
        if vertices[1].v != value {
            vertices[1].v = value
            isVertexBufferDirty = true
        }
    }
    
    public func setX3(_ value: Float) {
        if vertices[2].x != value {
            vertices[2].x = value
            isVertexBufferDirty = true
        }
    }
    
    public func setY3(_ value: Float) {
        if vertices[2].y != value {
            vertices[2].y = value
            isVertexBufferDirty = true
        }
    }
    
    public func setU3(_ value: Float) {
        if vertices[2].u != value {
            vertices[2].u = value
            isVertexBufferDirty = true
        }
    }
    
    public func setV3(_ value: Float) {
        if vertices[2].v != value {
            vertices[2].v = value
            isVertexBufferDirty = true
        }
    }
    
    public func setX4(_ value: Float) {
        if vertices[3].x != value {
            vertices[3].x = value
            isVertexBufferDirty = true
        }
    }
    
    public func setY4(_ value: Float) {
        if vertices[3].y != value {
            vertices[3].y = value
            isVertexBufferDirty = true
        }
    }
    
    public func setU4(_ value: Float) {
        if vertices[3].u != value {
            vertices[3].u = value
            isVertexBufferDirty = true
        }
    }
    
    public func setV4(_ value: Float) {
        if vertices[3].v != value {
            vertices[3].v = value
            isVertexBufferDirty = true
        }
    }
    
    public func setColor(red: Float, green: Float, blue: Float, alpha: Float) {
        
        if uniformsFragment.red != red {
            uniformsFragment.red = red
            isUniformsFragmentBufferDirty = true
        }
        if uniformsFragment.green != green {
            uniformsFragment.green = green
            isUniformsFragmentBufferDirty = true
        }
        if uniformsFragment.blue != blue {
            uniformsFragment.blue = blue
            isUniformsFragmentBufferDirty = true
        }
        if uniformsFragment.alpha != alpha {
            uniformsFragment.alpha = alpha
            isUniformsFragmentBufferDirty = true
        }
    }
    
    public var projectionMatrix: matrix_float4x4 {
        get {
            uniformsVertex.projectionMatrix
        }
        set {
            if uniformsVertex.projectionMatrix != newValue {
                uniformsVertex.projectionMatrix = newValue
                isUniformsVertexBufferDirty = true
            }
        }
    }
    
    public var modelViewMatrix: matrix_float4x4 {
        get {
            uniformsVertex.modelViewMatrix
        }
        set {
            if uniformsVertex.modelViewMatrix != newValue {
                uniformsVertex.modelViewMatrix = newValue
                isUniformsVertexBufferDirty = true
            }
        }
    }
    
    public func load(graphics: Graphics) {
        self.graphics = graphics
        uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        vertexBuffer = graphics.buffer(array: vertices)
        indexBuffer = graphics.buffer(array: indices)
    }
    
    public func load(graphics: Graphics,
                     texture: MTLTexture?) {
        load(graphics: graphics)
        self.texture = texture
        if let texture = texture {
            setX1(0.0)
            setY1(0.0)
            setU1(0.0)
            setV1(0.0)
            setX2(Float(texture.width))
            setY2(0.0)
            setU2(1.0)
            setV2(0.0)
            setX3(0.0)
            setY3(Float(texture.height))
            setU3(0.0)
            setV3(1.0)
            setX4(Float(texture.width))
            setY4(Float(texture.height))
            setU4(1.0)
            setV4(1.0)
        }
    }
    
    public func render(renderEncoder: MTLRenderCommandEncoder) {
        guard let graphics = graphics else { return }
        guard let texture = texture else { return }
        guard let vertexBuffer = vertexBuffer else { return }
        guard let indexBuffer = indexBuffer else { return }
        guard let uniformsVertexBuffer = uniformsVertexBuffer else { return }
        guard let uniformsFragmentBuffer = uniformsFragmentBuffer else { return }
        
        switch blendMode {
        case .none:
            graphics.set(pipelineState: .spriteNodeIndexed2DNoBlending, renderEncoder: renderEncoder)
        case .alpha:
            graphics.set(pipelineState: .spriteNodeIndexed2DAlphaBlending, renderEncoder: renderEncoder)
        case .additive:
            graphics.set(pipelineState: .spriteNodeIndexed2DAdditiveBlending, renderEncoder: renderEncoder)
        case .premultiplied:
            graphics.set(pipelineState: .spriteNodeIndexed2DPremultipliedBlending, renderEncoder: renderEncoder)
        }
        
        if isVertexBufferDirty {
            graphics.write(buffer: vertexBuffer, array: vertices)
            isVertexBufferDirty = false
        }
        if isIndexBufferDirty {
            graphics.write(buffer: indexBuffer, array: indices)
            isIndexBufferDirty = false
        }
        if isUniformsVertexBufferDirty {
            graphics.write(buffer: uniformsVertexBuffer, uniform: uniformsVertex)
            isUniformsVertexBufferDirty = false
        }
        if isUniformsFragmentBufferDirty {
            graphics.write(buffer: uniformsFragmentBuffer, uniform: uniformsFragment)
            isUniformsFragmentBufferDirty = false
        }
        graphics.setFragmentTexture(texture, renderEncoder: renderEncoder)
        graphics.setVertexUniformsBuffer(uniformsVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(uniformsFragmentBuffer, renderEncoder: renderEncoder)
        graphics.setVertexDataBuffer(vertexBuffer, renderEncoder: renderEncoder)
        graphics.set(samplerState: samplerState, renderEncoder: renderEncoder)
        renderEncoder.setCullMode(MTLCullMode.back)
        renderEncoder.drawIndexedPrimitives(type: .triangleStrip,
                                            indexCount: 4,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer, indexBufferOffset: 0)
        
    }
    
}
