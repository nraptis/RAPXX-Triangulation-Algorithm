//
//  Primitives.swift
//  StereoScope
//
//  Created by Nick Raptis on 5/24/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation

public protocol StereoscopicConforming {
    var shift: Float { set get }
}

public protocol ColorConforming {
    var r: Float { set get }
    var g: Float { set get }
    var b: Float { set get }
    var a: Float { set get }
}

public protocol PositionConforming2D {
    var x: Float { set get }
    var y: Float { set get }
}

public protocol PositionConforming3D: PositionConforming2D {
    var z: Float { set get }
}

public protocol NormalConforming {
    var normalX: Float { set get }
    var normalY: Float { set get }
    var normalZ: Float { set get }
}

public protocol TextureCoordinateConforming {
    var u: Float { set get }
    var v: Float { set get }
}

public struct Shape2DVertex: PositionConforming2D {
    public var x: Float
    public var y: Float
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
    }
}

public struct Shape2DColoredVertex: PositionConforming2D, ColorConforming {
    public var x: Float
    public var y: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public init(x: Float, y: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init() {
        self.x = 0.0
        self.y = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

public struct Sprite2DVertex: PositionConforming2D, TextureCoordinateConforming {
    public var x: Float
    public var y: Float
    public var u: Float
    public var v: Float
    public init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.u = u
        self.v = v
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.u = u
        self.v = v
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.u = 0.0
        self.v = 0.0
    }
}

public struct Sprite2DColoredVertex: PositionConforming2D, TextureCoordinateConforming, ColorConforming {
    public var x: Float
    public var y: Float
    public var u: Float
    public var v: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public init(x: Float, y: Float, u: Float, v: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.u = u
        self.v = v
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    public init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.u = 0.0
        self.v = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

public struct Sprite3DVertex: PositionConforming3D, TextureCoordinateConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
    }
    public init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
    }
}

public struct Sprite3DVertexStereoscopic: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var shift: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.shift = shift
    }
    public init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
        self.shift = 1.0
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.shift = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.shift = 1.0
    }
}

public struct Sprite3DVertexColoredStereoscopic: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming, ColorConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public var shift: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, r: Float, g: Float, b: Float, a: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.shift = shift
    }
    public init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
}

public struct Sprite3DColoredVertex: PositionConforming3D, TextureCoordinateConforming, ColorConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    public init(x: Float, y: Float, u: Float, v: Float) {
        self.x = x
        self.y = y
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

public struct Shape3DVertex: PositionConforming3D {
    public var x: Float
    public var y: Float
    public var z: Float
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
    }
}

public struct Shape3DLightedVertex: PositionConforming3D, NormalConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var normalX: Float
    public var normalY: Float
    public var normalZ: Float
    public init(x: Float, y: Float, z: Float, normalX: Float, normalY: Float, normalZ: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
    }
}

public struct Sprite3DLightedStereoscopicVertex: PositionConforming3D, TextureCoordinateConforming, StereoscopicConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var normalX: Float
    public var normalY: Float
    public var normalZ: Float
    public var shift: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.shift = shift
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.shift = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.shift = 1.0
    }
}

public struct Shape3DLightedColoredVertex: PositionConforming3D, NormalConforming, ColorConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var normalX: Float
    public var normalY: Float
    public var normalZ: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public init(x: Float, y: Float, z: Float, normalX: Float, normalY: Float, normalZ: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

public struct Shape3DColoredVertex: PositionConforming3D, ColorConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public init(x: Float, y: Float, z: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

public struct Sprite3DLightedVertex: PositionConforming3D, NormalConforming, TextureCoordinateConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var normalX: Float
    public var normalY: Float
    public var normalZ: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
    }
}

public struct Sprite3DLightedColoredVertex: PositionConforming3D, TextureCoordinateConforming, NormalConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var normalX: Float
    public var normalY: Float
    public var normalZ: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float, r: Float, g: Float, b: Float, a: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
    }
}

public struct Sprite3DLightedColoredStereoscopicVertex: PositionConforming3D, TextureCoordinateConforming, NormalConforming, StereoscopicConforming {
    public var x: Float
    public var y: Float
    public var z: Float
    public var u: Float
    public var v: Float
    public var normalX: Float
    public var normalY: Float
    public var normalZ: Float
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    public var shift: Float
    public init(x: Float, y: Float, z: Float, u: Float, v: Float, normalX: Float, normalY: Float, normalZ: Float, r: Float, g: Float, b: Float, a: Float, shift: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.u = u
        self.v = v
        self.normalX = normalX
        self.normalY = normalY
        self.normalZ = normalZ
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.shift = shift
    }
    public init(u: Float, v: Float) {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = u
        self.v = v
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
    public init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
        self.u = 0.0
        self.v = 0.0
        self.normalX = 0.0
        self.normalY = -1.0
        self.normalZ = 0.0
        self.r = 1.0
        self.g = 1.0
        self.b = 1.0
        self.a = 1.0
        self.shift = 1.0
    }
}
