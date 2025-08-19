//
//  IndexedInstanceable.swift
//  Yomama Ben Callen
//
//  Created by Nick Raptis on 6/2/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal
import simd

//
// Note: This is only for a single-quad triangle strip.
//
public protocol IndexedInstanceable<NodeType>: IndexedDrawable {
    
    func linkRender(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState)
    
    var vertices: [NodeType] { get set }
    
    var cullMode: MTLCullMode { get set }
}

public extension IndexedInstanceable {
    
    func load(graphics: Graphics?) {
        
        self.graphics = graphics
        
        guard let graphics = graphics else {
            return
        }
        
        guard let metalDevice = graphics.metalDevice else {
            return
        }
        
        uniformsVertexBuffer = graphics.buffer(uniform: uniformsVertex)
        uniformsFragmentBuffer = graphics.buffer(uniform: uniformsFragment)
        
        indexBuffer = nil
        let indices: [UInt32] = [0, 1, 2, 3]
        indices.withUnsafeBytes { bytes in
            if let baseAddress = bytes.baseAddress {
                indexBuffer = metalDevice.makeBuffer(bytes: baseAddress,
                                                     length: MemoryLayout<UInt32>.stride * indices.count)
            }
        }
        
        vertexBuffer = nil
        vertices.withUnsafeBytes { bytes in
            if let baseAddress = bytes.baseAddress {
                vertexBuffer = metalDevice.makeBuffer(bytes: baseAddress, length: MemoryLayout<NodeType>.stride * vertices.count)
            }
        }
        
        isVertexBufferDirty = false
        isUniformsVertexBufferDirty = true
        isUniformsFragmentBufferDirty = true
    }
    
    func render(renderEncoder: MTLRenderCommandEncoder, pipelineState: Graphics.PipelineState) {
        
        guard let graphics = graphics else {
            return
        }
        
        guard let uniformsVertexBuffer = uniformsVertexBuffer else {
            return
        }
        
        guard let uniformsFragmentBuffer = uniformsFragmentBuffer else {
            return
        }
        
        guard let vertexBuffer = vertexBuffer else {
            return
        }
        
        if isVertexBufferDirty {
            vertices.withUnsafeBytes { bytes in
                if let baseAddress = bytes.baseAddress {
                    let length = MemoryLayout<NodeType>.size * 4
                    vertexBuffer.contents().copyMemory(from: baseAddress, byteCount: length)
                }
            }
            isVertexBufferDirty = false
        }
        
        guard let indexBuffer = indexBuffer else {
            return
        }
        
        if isUniformsVertexBufferDirty {
            graphics.write(buffer: uniformsVertexBuffer, uniform: uniformsVertex)
            isUniformsVertexBufferDirty = false
        }
        if isUniformsFragmentBufferDirty {
            graphics.write(buffer: uniformsFragmentBuffer, uniform: uniformsFragment)
            isUniformsFragmentBufferDirty = false
        }
        
        graphics.set(pipelineState: pipelineState, renderEncoder: renderEncoder)
        graphics.setVertexDataBuffer(vertexBuffer, renderEncoder: renderEncoder)
        graphics.setVertexUniformsBuffer(uniformsVertexBuffer, renderEncoder: renderEncoder)
        graphics.setFragmentUniformsBuffer(uniformsFragmentBuffer, renderEncoder: renderEncoder)
        renderEncoder.setCullMode(cullMode)
        linkRender(renderEncoder: renderEncoder, pipelineState: pipelineState)
        renderEncoder.drawIndexedPrimitives(type: .triangleStrip,
                                            indexCount: 4,
                                            indexType: .uint32,
                                            indexBuffer: indexBuffer,
                                            indexBufferOffset: 0)
    }
}

public extension IndexedInstanceable {
    
    var projectionMatrix: matrix_float4x4 {
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
    
    var modelViewMatrix: matrix_float4x4 {
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
    
    var rgba: RGBA {
        get {
            RGBA(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        set {
            if uniformsFragment.red != newValue.red {
                uniformsFragment.red = newValue.red
                isUniformsFragmentBufferDirty = true
            }
            if uniformsFragment.green != newValue.green {
                uniformsFragment.green = newValue.green
                isUniformsFragmentBufferDirty = true
            }
            if uniformsFragment.blue != newValue.blue {
                uniformsFragment.blue = newValue.blue
                isUniformsFragmentBufferDirty = true
            }
            if uniformsFragment.alpha != newValue.alpha {
                uniformsFragment.alpha = newValue.alpha
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var red: Float {
        get {
            uniformsFragment.red
        }
        set {
            if uniformsFragment.red != newValue {
                uniformsFragment.red = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var green: Float {
        get {
            uniformsFragment.green
        }
        set {
            if uniformsFragment.green != newValue {
                uniformsFragment.green = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var blue: Float {
        get {
            uniformsFragment.blue
        }
        set {
            if uniformsFragment.blue != newValue {
                uniformsFragment.blue = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
    
    var alpha: Float {
        get {
            uniformsFragment.alpha
        }
        set {
            if uniformsFragment.alpha != newValue {
                uniformsFragment.alpha = newValue
                isUniformsFragmentBufferDirty = true
            }
        }
    }
}
