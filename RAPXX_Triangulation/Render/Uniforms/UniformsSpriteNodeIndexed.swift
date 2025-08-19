//
//  UniformsSpriteNodeIndexed.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/21/23.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import simd

public typealias UniformsSpriteNodeIndexedVertex = UniformsShapeVertex
public typealias UniformsSpriteNodeIndexedFragment = UniformsShapeFragment

public struct UniformsDiffuseFragment: UniformsFragment {
    
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float
    public var lightRed: Float
    public var lightGreen: Float
    public var lightBlue: Float
    public var lightAmbientIntensity: Float
    public var lightDiffuseIntensity: Float
    public var lightDirX: Float
    public var lightDirY: Float
    public var lightDirZ: Float
    
    public init() {
        red = 1.0
        green = 1.0
        blue = 1.0
        alpha = 1.0
        lightRed = 1.0
        lightGreen = 1.0
        lightBlue = 1.0
        lightAmbientIntensity = 0.0
        lightDiffuseIntensity = 1.0
        lightDirX = 0.0
        lightDirY = 0.0
        lightDirZ = -1.0
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
        result += (MemoryLayout<Float>.size * 12)
        return result
    }
    
    public var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(red)
        result.append(green)
        result.append(blue)
        result.append(alpha)
        result.append(lightRed)
        result.append(lightGreen)
        result.append(lightBlue)
        result.append(lightAmbientIntensity)
        result.append(lightDiffuseIntensity)
        result.append(lightDirX)
        result.append(lightDirY)
        result.append(lightDirZ)
        return result
    }
}

public struct UniformsPhongFragment: UniformsFragment {
    
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float
    public var lightRed: Float
    public var lightGreen: Float
    public var lightBlue: Float
    public var lightAmbientIntensity: Float
    public var lightDiffuseIntensity: Float
    public var lightSpecularIntensity: Float
    public var lightDirX: Float
    public var lightDirY: Float
    public var lightDirZ: Float
    public var lightShininess: Float

    public init() {
        red = 1.0
        green = 1.0
        blue = 1.0
        alpha = 1.0
        lightRed = 1.0
        lightGreen = 1.0
        lightBlue = 1.0
        lightAmbientIntensity = 0.0
        lightDiffuseIntensity = 0.25
        lightSpecularIntensity = 0.75
        lightDirX = 0.0
        lightDirY = 0.0
        lightDirZ = -1.0
        lightShininess = 8.0
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
        result += (MemoryLayout<Float>.size * 14)
        return result
    }
    
    public var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(red)
        result.append(green)
        result.append(blue)
        result.append(alpha)
        result.append(lightRed)
        result.append(lightGreen)
        result.append(lightBlue)
        result.append(lightAmbientIntensity)
        result.append(lightDiffuseIntensity)
        result.append(lightSpecularIntensity)
        result.append(lightDirX)
        result.append(lightDirY)
        result.append(lightDirZ)
        result.append(lightShininess)
        
        return result
    }
}

public struct UniformsLightsVertex: UniformsVertex {
    
    public var projectionMatrix: matrix_float4x4
    public var modelViewMatrix: matrix_float4x4
    public var normalMatrix: matrix_float4x4
    public init() {
        projectionMatrix = matrix_identity_float4x4
        modelViewMatrix = matrix_identity_float4x4
        normalMatrix = matrix_identity_float4x4
    }
    
    public var size: Int {
        var result = 0
        result += (MemoryLayout<matrix_float4x4>.size)
        result += (MemoryLayout<matrix_float4x4>.size)
        result += (MemoryLayout<matrix_float4x4>.size)
        return result
    }
    
    public var data: [Float] {
        var result = [Float]()
        result.reserveCapacity(size)
        result.append(contentsOf: projectionMatrix.array())
        result.append(contentsOf: modelViewMatrix.array())
        result.append(contentsOf: normalMatrix.array())
        return result
    }
}
