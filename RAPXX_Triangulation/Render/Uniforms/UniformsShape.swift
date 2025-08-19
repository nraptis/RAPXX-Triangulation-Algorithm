//
//  UniformsShape.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/10/23.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import simd

public struct UniformsShapeFragment: UniformsFragment {
    
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float
    
    public init() {
        red = 1.0
        green = 1.0
        blue = 1.0
        alpha = 1.0
    }
    
    public mutating func set(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = 1.0
    }
    
    public mutating func set(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public var size: Int {
        var result = 0
        result += (MemoryLayout<Float>.size << 2)
        return result
    }
    
    public var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(red)
        result.append(green)
        result.append(blue)
        result.append(alpha)
        return result
    }
}

public struct UniformsShapeVertex: UniformsVertex {
    
    public var projectionMatrix: matrix_float4x4
    public var modelViewMatrix: matrix_float4x4
    
    public init() {
        projectionMatrix = matrix_identity_float4x4
        modelViewMatrix = matrix_identity_float4x4
    }
    
    public var size: Int {
        var result = 0
        result += (MemoryLayout<matrix_float4x4>.size)
        result += (MemoryLayout<matrix_float4x4>.size)
        return result
    }
    
    public var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(contentsOf: projectionMatrix.array())
        result.append(contentsOf: modelViewMatrix.array())
        return result
    }
}
