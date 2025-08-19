//
//  swift
//  MathKit
//
//  Created by Nicholas Raptis on 5/7/25.
//

import Foundation
import simd

public protocol PointProtocol {
    var x: Float { set get }
    var y: Float { set get }
}

public struct Math {
    
    public static func interpolate2(inputMin: Float, inputMax: Float, input: Float, outputMin: Float, outputMax: Float) -> Float {
        let inputRange = (inputMax - inputMin)
        if inputRange > Math.epsilon {
            let percent = (input - inputMin) / (inputRange)
            var result = outputMin + (outputMax - outputMin) * percent
            if result < outputMin { result = outputMin }
            if result > outputMax { result = outputMax }
            return result
        } else {
            return outputMin
        }
    }
    
    public static func interpolate3(inputMin: Float,
                             inputMid: Float,
                             inputMax: Float,
                             input: Float,
                             outputMin: Float,
                             outputMid: Float,
                             outputMax: Float) -> Float {
        if input <= inputMid {
            return interpolate2(inputMin: inputMin,
                                inputMax: inputMid,
                                input: input,
                                outputMin: outputMin,
                                outputMax: outputMid)
        } else {
            return interpolate2(inputMin: inputMid,
                                inputMax: inputMax,
                                input: input,
                                outputMin: outputMid,
                                outputMax: outputMax)
        }
    }
    
    public static func interpolate4(inputMin: Float,
                             inputMid1: Float,
                             inputMid2: Float,
                             inputMax: Float,
                             input: Float,
                             outputMin: Float,
                             outputMid1: Float,
                             outputMid2: Float,
                             outputMax: Float) -> Float {
        if input <= inputMid1 {
            return interpolate2(inputMin: inputMin,
                                inputMax: inputMid1,
                                input: input,
                                outputMin: outputMin,
                                outputMax: outputMid1)
        } else if input <= inputMid2 {
            return interpolate2(inputMin: inputMid1,
                                inputMax: inputMid2,
                                input: input,
                                outputMin: outputMid1,
                                outputMax: outputMid2)
        } else {
            return interpolate2(inputMin: inputMid2,
                                inputMax: inputMax,
                                input: input,
                                outputMin: outputMid2,
                                outputMax: outputMax)
        }
    }
    
    public static func interpolate5(inputMin: Float,
                             inputMid1: Float,
                             inputMid2: Float,
                             inputMid3: Float,
                             inputMax: Float,
                             input: Float,
                             outputMin: Float,
                             outputMid1: Float,
                             outputMid2: Float,
                             outputMid3: Float,
                             outputMax: Float) -> Float {
        if input <= inputMid1 {
            return interpolate2(inputMin: inputMin,
                                inputMax: inputMid1,
                                input: input,
                                outputMin: outputMin,
                                outputMax: outputMid1)
        } else if input <= inputMid2 {
            return interpolate2(inputMin: inputMid1,
                                inputMax: inputMid2,
                                input: input,
                                outputMin: outputMid1,
                                outputMax: outputMid2)
        } else if input <= inputMid3 {
            return interpolate2(inputMin: inputMid2,
                                inputMax: inputMid3,
                                input: input,
                                outputMin: outputMid2,
                                outputMax: outputMid3)
        } else {
            return interpolate2(inputMin: inputMid3,
                                inputMax: inputMax,
                                input: input,
                                outputMin: outputMid3,
                                outputMax: outputMax)
        }
    }
    
    
    //   linearFactors     0.0    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9    1.0
    //Percent = 0.00 ==> {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000}
    //Percent = 0.10 ==> {0.010, 0.019, 0.028, 0.037, 0.046, 0.055, 0.064, 0.073, 0.082, 0.091, 0.100}
    //Percent = 0.20 ==> {0.040, 0.056, 0.072, 0.088, 0.104, 0.120, 0.136, 0.152, 0.168, 0.184, 0.200}
    //Percent = 0.30 ==> {0.090, 0.111, 0.132, 0.153, 0.174, 0.195, 0.216, 0.237, 0.258, 0.279, 0.300}
    //Percent = 0.40 ==> {0.160, 0.184, 0.208, 0.232, 0.256, 0.280, 0.304, 0.328, 0.352, 0.376, 0.400}
    //Percent = 0.50 ==> {0.250, 0.275, 0.300, 0.325, 0.350, 0.375, 0.400, 0.425, 0.450, 0.475, 0.500}
    //Percent = 0.60 ==> {0.360, 0.384, 0.408, 0.432, 0.456, 0.480, 0.504, 0.528, 0.552, 0.576, 0.600}
    //Percent = 0.70 ==> {0.490, 0.511, 0.532, 0.553, 0.574, 0.595, 0.616, 0.637, 0.658, 0.679, 0.700}
    //Percent = 0.80 ==> {0.640, 0.656, 0.672, 0.688, 0.704, 0.720, 0.736, 0.752, 0.768, 0.784, 0.800}
    //Percent = 0.90 ==> {0.810, 0.819, 0.828, 0.837, 0.846, 0.855, 0.864, 0.873, 0.882, 0.891, 0.900}
    //Percent = 1.00 ==> {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000}
    public static func mixPercentQuadratic(percent: Float, linearFactor: Float) -> Float {
        var percent = percent
        if percent > 1.0 { percent = 1.0 }
        if percent < 0.0 { percent = 0.0 }
        let lhs = percent * linearFactor
        let rhs = percent * percent * (1.0 - linearFactor)
        var result = lhs + rhs
        if result > 1.0 { result = 1.0 }
        if result < 0.0 { result = 0.0 }
        return result
    }
    
    //   linearFactors     0.0    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9    1.0
    //Percent = 0.00 ==> {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000}
    //Percent = 0.10 ==> {0.190, 0.181, 0.172, 0.163, 0.154, 0.145, 0.136, 0.127, 0.118, 0.109, 0.100}
    //Percent = 0.20 ==> {0.360, 0.344, 0.328, 0.312, 0.296, 0.280, 0.264, 0.248, 0.232, 0.216, 0.200}
    //Percent = 0.30 ==> {0.510, 0.489, 0.468, 0.447, 0.426, 0.405, 0.384, 0.363, 0.342, 0.321, 0.300}
    //Percent = 0.40 ==> {0.640, 0.616, 0.592, 0.568, 0.544, 0.520, 0.496, 0.472, 0.448, 0.424, 0.400}
    //Percent = 0.50 ==> {0.750, 0.725, 0.700, 0.675, 0.650, 0.625, 0.600, 0.575, 0.550, 0.525, 0.500}
    //Percent = 0.60 ==> {0.840, 0.816, 0.792, 0.768, 0.744, 0.720, 0.696, 0.672, 0.648, 0.624, 0.600}
    //Percent = 0.70 ==> {0.910, 0.889, 0.868, 0.847, 0.826, 0.805, 0.784, 0.763, 0.742, 0.721, 0.700}
    //Percent = 0.80 ==> {0.960, 0.944, 0.928, 0.912, 0.896, 0.880, 0.864, 0.848, 0.832, 0.816, 0.800}
    //Percent = 0.90 ==> {0.990, 0.981, 0.972, 0.963, 0.954, 0.945, 0.936, 0.927, 0.918, 0.909, 0.900}
    //Percent = 1.00 ==> {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000}
    public static func mixPercentQuadraticOpposite(percent: Float, linearFactor: Float) -> Float {
        var percentInverse = (1.0 - percent)
        if percentInverse > 1.0 { percentInverse = 1.0 }
        if percentInverse < 0.0 { percentInverse = 0.0 }
        let lhs = percentInverse * linearFactor
        let rhs = percentInverse * percentInverse * (1.0 - linearFactor)
        let resultInverse = lhs + rhs
        var result = (1.0 - resultInverse)
        if result > 1.0 { result = 1.0 }
        if result < 0.0 { result = 0.0 }
        return result
    }
    
    //   linearFactors     0.0    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9    1.0
    //Percent = 0.00 ==> {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000}
    //Percent = 0.10 ==> {0.001, 0.011, 0.021, 0.031, 0.041, 0.051, 0.060, 0.070, 0.080, 0.090, 0.100}
    //Percent = 0.20 ==> {0.008, 0.027, 0.046, 0.066, 0.085, 0.104, 0.123, 0.142, 0.162, 0.181, 0.200}
    //Percent = 0.30 ==> {0.027, 0.054, 0.082, 0.109, 0.136, 0.164, 0.191, 0.218, 0.245, 0.273, 0.300}
    //Percent = 0.40 ==> {0.064, 0.098, 0.131, 0.165, 0.198, 0.232, 0.266, 0.299, 0.333, 0.366, 0.400}
    //Percent = 0.50 ==> {0.125, 0.162, 0.200, 0.238, 0.275, 0.312, 0.350, 0.387, 0.425, 0.462, 0.500}
    //Percent = 0.60 ==> {0.216, 0.254, 0.293, 0.331, 0.370, 0.408, 0.446, 0.485, 0.523, 0.562, 0.600}
    //Percent = 0.70 ==> {0.343, 0.379, 0.414, 0.450, 0.486, 0.521, 0.557, 0.593, 0.629, 0.664, 0.700}
    //Percent = 0.80 ==> {0.512, 0.541, 0.570, 0.598, 0.627, 0.656, 0.685, 0.714, 0.742, 0.771, 0.800}
    //Percent = 0.90 ==> {0.729, 0.746, 0.763, 0.780, 0.797, 0.814, 0.832, 0.849, 0.866, 0.883, 0.900}
    //Percent = 1.00 ==> {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000}
    public static func mixPercentCubic(percent: Float, linearFactor: Float) -> Float {
        var percent = percent
        if percent > 1.0 { percent = 1.0 }
        if percent < 0.0 { percent = 0.0 }
        let lhs = percent * linearFactor
        let rhs = percent * percent * percent * (1.0 - linearFactor)
        var result = lhs + rhs
        if result > 1.0 { result = 1.0 }
        if result < 0.0 { result = 0.0 }
        return result
    }
    
    
    //   linearFactors     0.0    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9    1.0
    //Percent = 0.00 ==> {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000}
    //Percent = 0.10 ==> {0.271, 0.254, 0.237, 0.220, 0.203, 0.186, 0.168, 0.151, 0.134, 0.117, 0.100}
    //Percent = 0.20 ==> {0.488, 0.459, 0.430, 0.402, 0.373, 0.344, 0.315, 0.286, 0.258, 0.229, 0.200}
    //Percent = 0.30 ==> {0.657, 0.621, 0.586, 0.550, 0.514, 0.479, 0.443, 0.407, 0.371, 0.336, 0.300}
    //Percent = 0.40 ==> {0.784, 0.746, 0.707, 0.669, 0.630, 0.592, 0.554, 0.515, 0.477, 0.438, 0.400}
    //Percent = 0.50 ==> {0.875, 0.837, 0.800, 0.762, 0.725, 0.688, 0.650, 0.613, 0.575, 0.538, 0.500}
    //Percent = 0.60 ==> {0.936, 0.902, 0.869, 0.835, 0.802, 0.768, 0.734, 0.701, 0.667, 0.634, 0.600}
    //Percent = 0.70 ==> {0.973, 0.946, 0.918, 0.891, 0.864, 0.836, 0.809, 0.782, 0.755, 0.727, 0.700}
    //Percent = 0.80 ==> {0.992, 0.973, 0.954, 0.934, 0.915, 0.896, 0.877, 0.858, 0.838, 0.819, 0.800}
    //Percent = 0.90 ==> {0.999, 0.989, 0.979, 0.969, 0.959, 0.949, 0.940, 0.930, 0.920, 0.910, 0.900}
    //Percent = 1.00 ==> {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000}
    public static func mixPercentCubicOpposite(percent: Float, linearFactor: Float) -> Float {
        var percentInverse = (1.0 - percent)
        if percentInverse > 1.0 { percentInverse = 1.0 }
        if percentInverse < 0.0 { percentInverse = 0.0 }
        let lhs = percentInverse * linearFactor
        let rhs = percentInverse * percentInverse * percentInverse * (1.0 - linearFactor)
        let resultInverse = lhs + rhs
        var result = (1.0 - resultInverse)
        if result > 1.0 { result = 1.0 }
        if result < 0.0 { result = 0.0 }
        return result
    }
    
    //   linearFactors     0.0    0.1    0.2    0.3    0.4    0.5    0.6    0.7    0.8    0.9    1.0
    //Percent = 0.00 ==> {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000}
    //Percent = 0.10 ==> {0.156, 0.151, 0.145, 0.140, 0.134, 0.128, 0.123, 0.117, 0.111, 0.106, 0.100}
    //Percent = 0.20 ==> {0.309, 0.298, 0.287, 0.276, 0.265, 0.255, 0.244, 0.233, 0.222, 0.211, 0.200}
    //Percent = 0.30 ==> {0.454, 0.439, 0.423, 0.408, 0.392, 0.377, 0.362, 0.346, 0.331, 0.315, 0.300}
    //Percent = 0.40 ==> {0.588, 0.569, 0.550, 0.531, 0.513, 0.494, 0.475, 0.456, 0.438, 0.419, 0.400}
    //Percent = 0.50 ==> {0.707, 0.686, 0.666, 0.645, 0.624, 0.604, 0.583, 0.562, 0.541, 0.521, 0.500}
    //Percent = 0.60 ==> {0.809, 0.788, 0.767, 0.746, 0.725, 0.705, 0.684, 0.663, 0.642, 0.621, 0.600}
    //Percent = 0.70 ==> {0.891, 0.872, 0.853, 0.834, 0.815, 0.796, 0.776, 0.757, 0.738, 0.719, 0.700}
    //Percent = 0.80 ==> {0.951, 0.936, 0.921, 0.906, 0.891, 0.876, 0.860, 0.845, 0.830, 0.815, 0.800}
    //Percent = 0.90 ==> {0.988, 0.979, 0.970, 0.961, 0.953, 0.944, 0.935, 0.926, 0.918, 0.909, 0.900}
    //Percent = 1.00 ==> {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000}
    public static func mixPercentSin(percent: Float, linearFactor: Float) -> Float {
        var percent = percent
        if percent > 1.0 { percent = 1.0 }
        if percent < 0.0 { percent = 0.0 }
        var sinePortion = sinf(percent * (Math.pi_2))
        if sinePortion > 1.0 { sinePortion = 1.0 }
        if sinePortion < 0.0 { sinePortion = 0.0 }
        let lhs = percent * linearFactor
        let rhs = sinePortion * (1.0 - linearFactor)
        var result = lhs + rhs
        if result > 1.0 { result = 1.0 }
        if result < 0.0 { result = 0.0 }
        return result
    }

    
    public struct Point: CustomStringConvertible, PointProtocol {
        public var x: Float
        public var y: Float
        
        public init(x: Float, y: Float) {
            self.x = x
            self.y = y
        }
        
        public var description: String {
            let stringX = String(format: "%.2f", x)
            let stringY = String(format: "%.2f", y)
            return "Point(\(stringX), \(stringY))"
        }
        
        public static func + (left: Point, right: Point) -> Point {
            Point(x: left.x + right.x, y: left.y + right.y)
        }
        
        public static func + (left: Point, right: Vector) -> Point {
            Point(x: left.x + right.x, y: left.y + right.y)
        }
        
        public static func - (left: Point, right: Point) -> Point {
            Point(x: left.x - right.x, y: left.y - right.y)
        }
        
        public static func - (left: Point, right: Vector) -> Point {
            Point(x: left.x - right.x, y: left.y - right.y)
        }
        
        nonisolated(unsafe) public static let zero = Point(x: 0.0, y: 0.0)
        
        var float2: SIMD2<Float> {
            SIMD2<Float>(x, y)
        }
        
        public var cgPoint: CGPoint {
            CGPoint(x: CGFloat(x),
                    y: CGFloat(y))
        }
        
        public var vector: Vector {
            Vector(x: x,
                   y: y)
        }
        
        public func offset(x: Float, y: Float) -> Point {
            Point(x: self.x + x,
                  y: self.y + y)
        }
        
        public func distanceSquaredTo(_ point: Point) -> Float {
            distanceSquaredTo(point.x, point.y)
        }
        
        public func distanceSquaredTo(_ x: Float, _ y: Float) -> Float {
            let diffX = self.x - x
            let diffY = self.y - y
            return diffX * diffX + diffY * diffY
        }
        
        public func distanceTo(_ point: Point) -> Float {
            distanceTo(point.x, point.y)
        }
        
        public func distanceTo(_ x: Float, _ y: Float) -> Float {
            var distance = distanceSquaredTo(x, y)
            if distance > Math.epsilon {
                distance = sqrtf(distance)
            }
            return distance
        }
        
        public var lengthSquared: Float {
            (x * x) + (y * y)
        }
        
        public var length: Float {
            var _result = lengthSquared
            if _result > Math.epsilon {
                _result = sqrtf(_result)
            } else {
                _result = 0.0
            }
            return _result
        }
        
        public mutating func normalize() {
            var length = lengthSquared
            if length > Math.epsilon {
                length = sqrtf(length)
                x /= length
                y /= length
            } else {
                y = -1.0
                x = 0.0
            }
        }
    }
    
    public struct Vector: CustomStringConvertible, PointProtocol {
        public var x: Float
        public var y: Float
        
        public init(x: Float, y: Float) {
            self.x = x
            self.y = y
        }
        
        public var description: String {
            let stringX = String(format: "%.2f", x)
            let stringy = String(format: "%.2f", x)
            return "Vector(\(stringX), \(stringy))"
        }
        
        nonisolated(unsafe) public static let zero = Vector(x: 0.0, y: 0.0)
        
        public var float2: SIMD2<Float> {
            SIMD2<Float>(x, y)
        }
        
        public var cgPoint: CGPoint {
            CGPoint(x: CGFloat(x),
                    y: CGFloat(y))
        }
        
        public var point: Point {
            Point(x: x, y: y)
        }
        
        public var angle: Float {
            let result = -atan2f(-x, -y)
            return result
        }
        
        public var normal: Vector {
            Vector(x: -y, y: x)
        }
        
        public var lengthSquared: Float {
            (x * x) + (y * y)
        }
        
        public var length: Float {
            var _result = lengthSquared
            if _result > Math.epsilon {
                _result = sqrtf(_result)
            } else {
                _result = 0.0
            }
            return _result
        }
        
        public mutating func normalize() {
            var length = lengthSquared
            if length > Math.epsilon {
                length = sqrtf(length)
                x /= length
                y /= length
            } else {
                y = -1.0
                x = 0.0
            }
        }
        
        public static func * (left: Vector, right: Float) -> Vector {
            return Vector(x: left.x * right, y: left.y * right)
        }
        
        public static func / (left: Vector, right: Float) -> Vector {
            return Vector(x: left.x / right, y: left.y / right)
        }
        
        public static func * (left: Vector, right: Vector) -> Vector {
            return Vector(x: left.x * right.x, y: left.y * right.y)
        }
        
        public static func + (left: Vector, right: Vector) -> Vector {
            return Vector(x: left.x + right.x, y: left.y + right.y)
        }
        
        public static func - (left: Vector, right: Vector) -> Vector {
            return Vector(x: left.x - right.x, y: left.y - right.y)
        }
        
        public static func + (left: Vector, right: Vector) -> Point {
            Point(x: left.x + right.x, y: left.y + right.y)
        }
        
        public func dot(_ vector: Vector) -> Float {
            x * vector.x + y * vector.y
        }
        
        public func cross(_ vector: Vector) -> Float {
            x * vector.y - vector.x * y
        }
    }
    
    public static let pi = Float.pi
    public static let pi2 = Float.pi * 2.0
    public static let pi3 = Float.pi * 3.0
    public static let pi4 = Float.pi * 4.0
    
    public static let _pi = -Float.pi
    public static let _pi2 = -Float.pi * 2.0
    public static let _pi3 = -Float.pi * 3.0
    public static let _pi4 = -Float.pi * 4.0
    
    public static let pi3_2 = (Float.pi * 3.0) / 2.0
    public static let pi2_3 = (Float.pi * 2.0) / 3.0
    public static let pi3_4 = (Float.pi * 3.0) / 4.0
    public static let pi4_3 = (Float.pi * 4.0) / 3.0
    
    public static let pi3_5 = (Float.pi * 3.0) / 5.0
    public static let pi5_3 = (Float.pi * 5.0) / 3.0
    public static let pi4_5 = (Float.pi * 4.0) / 5.0
    public static let pi5_4 = (Float.pi * 5.0) / 4.0
    public static let pi5_6 = (Float.pi * 5.0) / 6.0
    public static let pi6_5 = (Float.pi * 6.0) / 5.0
    
    public static let _pi3_2 = (-Float.pi * 3.0) / 2.0
    public static let _pi2_3 = (-Float.pi * 2.0) / 3.0
    public static let _pi3_4 = (-Float.pi * 3.0) / 4.0
    public static let _pi4_3 = (-Float.pi * 4.0) / 3.0
    
    public static let pi_2 = Float.pi / 2.0
    public static let pi_3 = Float.pi / 3.0
    public static let pi_4 = Float.pi / 4.0
    public static let pi_4_5 = Float.pi / 4.5
    public static let pi_5 = Float.pi / 5.0
    public static let pi_5_5 = Float.pi / 5.5
    public static let pi_6 = Float.pi / 6.0
    public static let pi_7 = Float.pi / 7.0
    public static let pi_7_5 = Float.pi / 7.5
    
    public static let pi_8 = Float.pi / 8.0
    public static let pi_9 = Float.pi / 9.0
    public static let pi_10 = Float.pi / 10.0
    public static let pi_11 = Float.pi / 11.0
    public static let pi_12 = Float.pi / 12.0
    public static let pi_13 = Float.pi / 13.0
    public static let pi_14 = Float.pi / 14.0
    public static let pi_15 = Float.pi / 15.0
    public static let pi_16 = Float.pi / 16.0
    public static let pi_17 = Float.pi / 17.0
    public static let pi_18 = Float.pi / 18.0
    public static let pi_19 = Float.pi / 19.0
    public static let pi_20 = Float.pi / 20.0
    
    public static let _pi_2 = -Float.pi / 2.0
    public static let _pi_3 = -Float.pi / 3.0
    public static let _pi_4 = -Float.pi / 4.0
    public static let _pi_5 = -Float.pi / 5.0
    public static let _pi_6 = -Float.pi / 6.0
    public static let _pi_7 = -Float.pi / 7.0
    public static let _pi_8 = -Float.pi / 8.0
    public static let _pi_10 = -Float.pi / 10.0
    public static let _pi_12 = -Float.pi / 12.0
    public static let _pi_14 = -Float.pi / 14.0
    public static let _pi_16 = -Float.pi / 16.0
    
    public static let epsilon: Float = 0.00001
    //static let epsilon: Float = 0.01
    public static let _epsilon = -epsilon
    
    public static func radians(degrees: Float) -> Float {
        return degrees * Float.pi / 180.0
    }

    public static func degrees(radians: Float) -> Float {
        return radians * 180.0 / Float.pi
    }
    
    public static func vector2D(radians: Float) -> Point {
        let x = sinf(radians)
        let y = -cosf(radians)
        return Point(x: x, y: y)
    }

    public static func vector2D(degrees: Float) -> Point {
        vector2D(radians: radians(degrees: degrees))
    }
    
    public static func distanceBetweenAngles(_ angle1: Float, _ angle2: Float) -> Float {
        var difference = fmodf(angle1 - angle2, Math.pi2)
        if difference < 0 { difference += Math.pi2 }
        if difference > Float.pi {
            return Math.pi2 - difference
        } else {
            return -difference
        }
    }
    
    public static func distanceBetweenAnglesUnsafe(_ angle1: Float, _ angle2: Float) -> Float {
        var difference = angle1 - angle2
        if difference < Math._pi2 { difference += Math.pi2 }
        if difference > Math.pi2 { difference -= Math.pi2 }
        if difference < 0 { difference += Math.pi2 }
        if difference > Float.pi {
            return Math.pi2 - difference
        } else {
            return -difference
        }
    }
    
    public static func distanceBetweenAnglesAbsolute(_ angle1: Float, _ angle2: Float) -> Float {
        var difference = angle1 - angle2
        if difference > Math.pi4 {
            difference = fmodf(angle1 - angle2, Math.pi2)
        } else if difference < Math._pi4 {
            difference = fmodf(angle1 - angle2, Math.pi2)
        } else if difference > Math.pi2 {
            difference -= Math.pi2
        } else if difference < Math._pi2 {
            difference += Math.pi2
        }
        if difference < 0 { difference += Math.pi2 }
        if difference > Float.pi {
            return Math.pi2 - difference
        } else {
            return difference
        }
    }
    
    public static func distanceBetweenAnglesAbsoluteUnsafe(_ angle1: Float, _ angle2: Float) -> Float {
        var difference = angle1 - angle2
        if difference > Math.pi2 {
            difference -= Math.pi2
        } else if difference < Math._pi2 {
            difference += Math.pi2
        }
        if difference < 0.0 {
            difference += Math.pi2
        }
        if difference > Float.pi {
            return Math.pi2 - difference
        } else {
            return difference
        }
    }
    
    public static func percentThroughRange(value: Float, minimum: Float, maximum: Float) -> Float {
        let range = maximum - minimum
        if range > epsilon {
            let percent = (value - minimum) / range
            if percent < 0.0 {
                return 0.0
            } else if percent > 1.0 {
                return 1.0
            } else {
                return percent
            }
        } else {
            if value < minimum {
                return 0.0
            } else {
                return 1.0
            }
        }
    }
    
    public static func rotate(float3: simd_float3, radians: Float, axisX: Float, axisY: Float, axisZ: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotation(radians: radians, axisX: axisX, axisY: axisY, axisZ: axisZ)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    public static func rotate(float3: simd_float3, degrees: Float, axisX: Float, axisY: Float, axisZ: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotation(degrees: degrees, axisX: axisX, axisY: axisY, axisZ: axisZ)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    public static func rotateNormalized(float3: simd_float3, radians: Float, axisX: Float, axisY: Float, axisZ: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationNormalized(radians: radians, axisX: axisX, axisY: axisY, axisZ: axisZ)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    public static func rotateNormalized(float3: simd_float3, degrees: Float, axisX: Float, axisY: Float, axisZ: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationNormalized(degrees: degrees, axisX: axisX, axisY: axisY, axisZ: axisZ)
        return rotationMatrix.processRotationOnly(point3: float3)
    }
    
    public static func rotateX(float3: simd_float3, radians: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationX(radians: radians)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    public static func rotateX(float3: simd_float3, degrees: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationX(degrees: degrees)
        return rotationMatrix.processRotationOnly(point3: float3)
    }
    
    public static func rotateY(float3: simd_float3, radians: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationY(radians: radians)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    public static func rotateY(float3: simd_float3, degrees: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationY(degrees: degrees)
        return rotationMatrix.processRotationOnly(point3: float3)
    }
    
    public static func rotateZ(float3: simd_float3, radians: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationZ(radians: radians)
        return rotationMatrix.processRotationOnly(point3: float3)
    }

    public static func rotateZ(float3: simd_float3, degrees: Float) -> simd_float3 {
        var rotationMatrix = matrix_float4x4()
        rotationMatrix.rotationZ(degrees: degrees)
        return rotationMatrix.processRotationOnly(point3: float3)
    }
    
    public static func distance(point1: Point, point2: Point) -> Float {
        let diffX = point2.x - point1.x
        let diffY = point2.y - point1.y
        let distanceSquared = diffX * diffX + diffY * diffY
        if distanceSquared > Self.epsilon {
            return sqrtf(distanceSquared)
        } else {
            return 0.0
        }
    }
    
    public static func distance(x1: Float, y1: Float, x2: Float, y2: Float) -> Float {
        let diffX = x2 - x1
        let diffY = y2 - y1
        let distanceSquared = diffX * diffX + diffY * diffY
        if distanceSquared > Self.epsilon {
            return sqrtf(distanceSquared)
        } else {
            return 0.0
        }
    }

    public static func distanceSquared(point1: Point, point2: Point) -> Float {
        let diffX = point2.x - point1.x
        let diffY = point2.y - point1.y
        return diffX * diffX + diffY * diffY
    }
    
    public static func distanceSquared(x1: Float, y1: Float, x2: Float, y2: Float) -> Float {
        let diffX = x2 - x1
        let diffY = y2 - y1
        return diffX * diffX + diffY * diffY
    }
    
    public static func rangeContainsValue(start: Float, end: Float, value: Float) -> Bool {
        if value >= start && value <= end {
            return true
        }
        if value >= end && value <= start {
            return true
        }
        return false
    }
    
    public static func rangesOverlap(start1: Float, end1: Float, start2: Float, end2: Float) -> Bool {
        if start1 < end1 {
            if start2 >= start1 && start2 <= end1 {
                return true
            }
            if end2 >= start1 && end2 <= end1 {
                return true
            }
            if start2 < end2 {
                if start1 >= start2 && start1 <= end2 {
                    return true
                }
                if end1 >= start2 && end1 <= end2 {
                    return true
                }
            } else {
                if start1 >= end2 && start1 <= start2 {
                    return true
                }
                if end1 >= end2 && end1 <= start2 {
                    return true
                }
            }
        } else {
            if start2 >= end1 && start2 <= start1 {
                return true
            }
            if end2 >= end1 && end2 <= start1 {
                return true
            }
            if start2 < end2 {
                if end1 >= start2 && end1 <= end2 {
                    return true
                }
                if start1 >= start2 && start1 <= end2 {
                    return true
                }
            } else {
                if end1 >= end2 && end1 <= start2 {
                    return true
                }
                if start1 >= end2 && start1 <= start2 {
                    return true
                }
            }
        }
        return false
    }
    
    public static func perpendicularNormal(float3: simd_float3) -> simd_float3 {
        
        let factorX = fabsf(float3.x)
        let factorY = fabsf(float3.y)
        let factorZ = fabsf(float3.z)

        var result = simd_float3(0.0, 0.0, 0.0)
        if factorX < Math.epsilon {
            if factorY < Math.epsilon {
                result.y = 1.0
            } else {
                result.y = -float3.z
                result.z = float3.y
            }
        } else if factorY < Math.epsilon {
            if factorZ < Math.epsilon {
                result.y = -1
            } else {
                result.x = -float3.z
                result.z = float3.x
            }
        } else if factorZ < Math.epsilon {
            result.x = -float3.y
            result.y = float3.x
        } else {
            result.x = 1.0
            result.y = 1.0
            result.z = -((float3.x + float3.y) / float3.z)
        }
        
        return simd_normalize(result)
    }
    
    public static func equalsApproximately(number1: Float, number2: Float) -> Bool {
        let diff = abs(number1 - number2)
        return diff <= epsilon
    }
    
    public static func clamp(number: Float, lower: Float, upper: Float) -> Float {
        var result = number
        if result < lower { result = lower }
        if result > upper { result = upper }
        return result
    }
    
    public static func angleDistance(radians1: Float, radians2: Float) -> Float {
        var distance = radians1 - radians2
        distance = fmodf(distance, (Float.pi * 2.0))
        if distance < 0.0 { distance += (Float.pi * 2.0) }
        if distance > Float.pi {
            return (Float.pi * 2.0) - distance
        } else {
            return -distance
        }
    }
    
    public static func angleDistance(degrees1: Float, degrees2: Float) -> Float {
        let radians1 = radians(degrees: degrees1)
        let radians2 = radians(degrees: degrees2)
        return angleDistance(radians1: radians1, radians2: radians2)
    }
    
    public static func easeInOutSine(percent: Float) -> Float {
        return -0.5 * (cosf(pi * percent) - 1.0)
    }
    
    public static func fallOffOvershoot(input: Float, falloffStart: Float, resultMax: Float, inputMax: Float) -> Float {
        var result = input
        if result > falloffStart {
            result = resultMax
            if input < inputMax {
                //We are constrained between [falloffStart ... inputMax]
                let span = (inputMax - falloffStart)
                if span > Math.epsilon {
                    var percent = (input - falloffStart) / span
                    if percent < 0.0 { percent = 0.0 }
                    if percent > 1.0 { percent = 1.0 }
                    //sin [0..1] => [0..pi/2]
                    let factor = sinf(Float(percent * (Math.pi_2)))
                    result = falloffStart + factor * (resultMax - falloffStart)
                }
            }
        }
        return result
    }
    
    public static func fallOffOvershootInverse(input: Float, falloffStart: Float, resultMax: Float, inputMax: Float) -> Float {
        var result = input
        if input > falloffStart {
            result = inputMax
            if input < resultMax {
                //We are constrained between [falloffStart .. resultMax]
                let span = (resultMax - falloffStart)
                if span > Math.epsilon {
                    var percentLinear = (input - falloffStart) / span
                    if percentLinear < 0.0 { percentLinear = 0.0 }
                    if percentLinear > 1.0 { percentLinear = 1.0 }
                    //asin [0..1] => [0..pi/2]
                    let factor = asinf(Float(percentLinear)) / Math.pi_2
                    result = falloffStart + factor * (inputMax - falloffStart)
                }
            }
        }
        return result
    }
    
    public static func fallOffUndershoot(input: Float, falloffStart: Float, resultMin: Float, inputMin: Float) -> Float {
        var result = input
        if result < falloffStart {
            result = resultMin
            if input > inputMin {
                //We are constrained between [inputMin ... falloffStart]
                let span = (falloffStart - inputMin)
                if span > Math.epsilon {
                    var percent = (falloffStart - input) / span
                    if percent < 0.0 { percent = 0.0 }
                    if percent > 1.0 { percent = 1.0 }
                    //sin [0..1] => [0..pi/2]
                    let factor = sinf(Float(percent * (Self.pi_2)))
                    result = falloffStart - factor * (falloffStart - resultMin)
                }
            }
        }
        return result
    }
    
    public static func angleToVector(radians: Float) -> Point {
        .init(x: sinf(radians), y: -cosf(radians))
    }
    
    public static func face(target: Point) -> Float {
        -atan2f(Float(-target.x), Float(-target.y))
    }
    
    public static func rotatePoint(point: Point, radians: Float) -> Point {
        var dist = point.x * point.x + point.y * point.y
        if dist > epsilon {
            dist = sqrtf(dist)
            let pivot = -atan2f(Float(-point.x), Float(-point.y))
            let newDir = angleToVector(radians: pivot + radians)
            return Point(x: newDir.x * dist, y: newDir.y * dist)
        }
        return point
    }
    
    public static func transformPoint(point: Point, scale: Float, rotation: Float) -> Point {
        var x = point.x
        var y = point.y
        if scale != 1.0 {
            x *= scale
            y *= scale
        }
        if rotation != 0 {
            var dist = x * x + y * y
            if dist > epsilon {
                dist = sqrtf(Float(dist))
                x /= dist
                y /= dist
            }
            let pivotRotation = rotation - atan2f(-x, -y)
            x = sinf(Float(pivotRotation)) * dist
            y = -cosf(Float(pivotRotation)) * dist
        }
        return Point(x: x, y: y)
    }
    
    public static func transformPoint(point: Point, translation: Point, scale: Float, rotation: Float) -> Point {
        var result = transformPoint(point: point, scale: scale, rotation: rotation)
        result = Point(x: result.x + translation.x, y: result.y + translation.y)
        return result
    }
    
    public static func untransformPoint(point: Point, scale: Float, rotation: Float) -> Point {
        if fabsf(scale) > Self.epsilon {
            return transformPoint(point: point, scale: 1.0 / scale, rotation: -rotation)
        } else {
            return transformPoint(point: point, scale: 1.0, rotation: -rotation)
        }
    }
    
    public static func untransformPoint(point: Point, translation: Point, scale: Float, rotation: Float) -> Point {
        var result = Point(x: point.x - translation.x, y: point.y - translation.y)
        result = untransformPoint(point: result, scale: scale, rotation: rotation)
        return result
    }
    
    public static func rotateVector(vector: Vector, radians: Float) -> Vector {
            var dist = vector.x * vector.x + vector.y * vector.y
            if dist > epsilon {
                dist = sqrtf(dist)
                let pivot = -atan2f(Float(-vector.x), Float(-vector.y))
                let newDir = angleToVector(radians: pivot + radians)
                return Vector(x: newDir.x * dist, y: newDir.y * dist)
            }
            return vector
        }
        
        public static func transformVector(vector: Vector, scale: Float, rotation: Float) -> Vector {
            var x = vector.x
            var y = vector.y
            if scale != 1.0 {
                x *= scale
                y *= scale
            }
            if rotation != 0 {
                var dist = x * x + y * y
                if dist > epsilon {
                    dist = sqrtf(Float(dist))
                    x /= dist
                    y /= dist
                }
                let pivotRotation = rotation - atan2f(-x, -y)
                x = sinf(Float(pivotRotation)) * dist
                y = -cosf(Float(pivotRotation)) * dist
            }
            return Vector(x: x, y: y)
        }
        
        public static func transformVector(vector: Vector, translation: Point, scale: Float, rotation: Float) -> Vector {
            var result = transformVector(vector: vector, scale: scale, rotation: rotation)
            result = Vector(x: result.x + translation.x, y: result.y + translation.y)
            return result
        }
        
        public static func untransformVector(vector: Vector, scale: Float, rotation: Float) -> Vector {
            if fabsf(scale) > Self.epsilon {
                return transformVector(vector: vector, scale: 1.0 / scale, rotation: -rotation)
            } else {
                return transformVector(vector: vector, scale: 1.0, rotation: -rotation)
            }
        }
        
        public static func untransformVector(vector: Vector, translation: Point, scale: Float, rotation: Float) -> Vector {
            var result = Vector(x: vector.x - translation.x, y: vector.y - translation.y)
            result = untransformVector(vector: result, scale: scale, rotation: rotation)
            return result
        }
    
    public static func clockwise(point1: Point, point2: Point, point3: Point) -> Bool {
        (point2.x - point1.x) * (point3.y - point2.y) - (point3.x - point2.x) * (point2.y - point1.y) > 0.0
    }
    
    @frozen public enum RayRayIntersectionResult {
        case invalidCoplanar
        case valid(pointX: Float, pointY: Float, distance: Float)
    }
    // Precondition: rayNormal1 is normalized
    // Precondition: rayDirection2 is normalized
    public static func rayIntersectionRay(rayOrigin1X: Float,
                                   rayOrigin1Y: Float,
                                   rayNormal1X: Float,
                                   rayNormal1Y: Float,
                                   rayOrigin2X: Float,
                                   rayOrigin2Y: Float,
                                   rayDirection2X: Float,
                                   rayDirection2Y: Float) -> RayRayIntersectionResult {
            let numerator = rayNormal1X * rayOrigin2X +
                            rayNormal1Y * rayOrigin2Y -
                            dot(x1: rayOrigin1X, y1: rayOrigin1Y,
                                x2: rayNormal1X, y2: rayNormal1Y)
            let denominator = rayDirection2X * rayNormal1X + rayDirection2Y * rayNormal1Y
            if denominator < _epsilon || denominator > epsilon {
                let distance = -(numerator / denominator)
                return .valid(pointX: rayOrigin2X + rayDirection2X * distance,
                              pointY: rayOrigin2Y + rayDirection2Y * distance,
                              distance: distance)
            } else {
                return .invalidCoplanar
            }
        }
    
    public static func segmentClosestPoint(point: Point,
                                    linePoint1: Point,
                                    linePoint2: Point) -> Point {
        var result = Point(x: linePoint1.x, y: linePoint1.y)
        let factor1X = point.x - linePoint1.x
        let factor1Y = point.y - linePoint1.y
        let lineDiffX = linePoint2.x - linePoint1.x
        let lineDiffY = linePoint2.y - linePoint1.y
        var factor2X = lineDiffX
        var factor2Y = lineDiffY
        var lineLength = lineDiffX * lineDiffX + lineDiffY * lineDiffY
        if lineLength > Math.epsilon {
            lineLength = sqrtf(lineLength)
            factor2X /= lineLength
            factor2Y /= lineLength
            let scalar = factor2X * factor1X + factor2Y * factor1Y
            if scalar < 0.0 {
                result.x = linePoint1.x
                result.y = linePoint1.y
            } else if scalar > lineLength {
                result.x = linePoint2.x
                result.y = linePoint2.y
            } else {
                result.x = linePoint1.x + factor2X * scalar
                result.y = linePoint1.y + factor2Y * scalar
            }
        }
        return result
    }
    
    public static func segmentClosestPoint(x: Float, y: Float,
                                    linePoint1X: Float, linePoint1Y: Float,
                                    linePoint2X: Float, linePoint2Y: Float) -> Point {
        var result = Point(x: linePoint1X, y: linePoint1Y)
        let factor1X = x - linePoint1X
        let factor1Y = y - linePoint1Y
        let lineDiffX = linePoint2X - linePoint1X
        let lineDiffY = linePoint2Y - linePoint1Y
        var factor2X = lineDiffX
        var factor2Y = lineDiffY
        var lineLength = lineDiffX * lineDiffX + lineDiffY * lineDiffY
        if lineLength > Math.epsilon {
            lineLength = sqrtf(lineLength)
            factor2X /= lineLength
            factor2Y /= lineLength
            let scalar = factor2X * factor1X + factor2Y * factor1Y
            if scalar < 0.0 {
                result.x = linePoint1X
                result.y = linePoint1Y
            } else if scalar > lineLength {
                result.x = linePoint2X
                result.y = linePoint2Y
            } else {
                result.x = linePoint1X + factor2X * scalar
                result.y = linePoint1Y + factor2Y * scalar
            }
        }
        return result
    }
    
    public static func segmentClosestPointDistanceSquared(x: Float, y: Float,
                                                   linePoint1X: Float, linePoint1Y: Float,
                                                   linePoint2X: Float, linePoint2Y: Float) -> Float {
        let factor1X = x - linePoint1X
        let factor1Y = y - linePoint1Y
        let lineDiffX = linePoint2X - linePoint1X
        let lineDiffY = linePoint2Y - linePoint1Y
        var factor2X = lineDiffX
        var factor2Y = lineDiffY
        var lineLength = lineDiffX * lineDiffX + lineDiffY * lineDiffY
        if lineLength > Math.epsilon {
            lineLength = sqrtf(lineLength)
            factor2X /= lineLength
            factor2Y /= lineLength
            let scalar = factor2X * factor1X + factor2Y * factor1Y
            if scalar < 0.0 {
                let diffX = x - linePoint1X
                let diffY = y - linePoint1Y
                return diffX * diffX + diffY * diffY
            } else if scalar > lineLength {
                let diffX = x - linePoint2X
                let diffY = y - linePoint2Y
                return diffX * diffX + diffY * diffY
            } else {
                let closestX = linePoint1X + factor2X * scalar
                let closestY = linePoint1Y + factor2Y * scalar
                let diffX = x - closestX
                let diffY = y - closestY
                return diffX * diffX + diffY * diffY
            }
        } else {
            let centerX = (linePoint1X + linePoint2X) * 0.5
            let centerY = (linePoint1Y + linePoint2Y) * 0.5
            let diffX = x - centerX
            let diffY = y - centerY
            return diffX * diffX + diffY * diffY
        }
    }
    
    public static func segmentClosestPointIsOnSegment(point: Point,
                                               linePoint1: Point,
                                               linePoint2: Point) -> Bool {
        let factor1X = point.x - linePoint1.x
        let factor1Y = point.y - linePoint1.y
        let lineDiffX = linePoint2.x - linePoint1.x
        let lineDiffY = linePoint2.y - linePoint1.y
        var factor2X = lineDiffX
        var factor2Y = lineDiffY
        var lineLength = lineDiffX * lineDiffX + lineDiffY * lineDiffY
        if lineLength > Math.epsilon {
            lineLength = sqrtf(lineLength)
            factor2X /= lineLength
            factor2Y /= lineLength
            let scalar = factor2X * factor1X + factor2Y * factor1Y
            if scalar < 0.0 || scalar > 1.0 {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    public static func pointEmbeddedInLineSegmentPlane(point: Point, linePoint1: Point, linePoint2: Point) -> Bool {
        cross(x1: linePoint2.x - linePoint1.x,
              y1: linePoint2.y - linePoint1.y,
              x2: point.x - linePoint1.x,
              y2: point.y - linePoint1.y) < 0.0
    }
    
    public static func pointEmbeddedInPlane(point: Point, planeOrigin: Point, planeDirection: Vector) -> Bool {
        cross(x1: planeDirection.x,
              y1: planeDirection.y,
              x2: point.x - planeOrigin.x,
              y2: point.y - planeOrigin.y) < 0.0
    }
    
    public static func pointEmbeddedInPlaneFlipped(point: Point, planeOrigin: Point, planeDirection: Vector) -> Bool {
        cross(x1: -planeDirection.x,
              y1: -planeDirection.y,
              x2: point.x - planeOrigin.x,
              y2: point.y - planeOrigin.y) < 0.0
    }
    
    
    public static func lineSegmentFacesLineSegment(line1Point1: Point, line1Point2: Point, line2Point1: Point, line2Point2: Point) -> Bool {
        // If both of line 1 are embedded in line 2, then no.
        if
            pointEmbeddedInLineSegmentPlane(point: line1Point1,
                                           linePoint1: line2Point1,
                                           linePoint2: line2Point2)  &&
            pointEmbeddedInLineSegmentPlane(point: line1Point2,
                                               linePoint1: line2Point1,
                                               linePoint2: line2Point2){
            return false
        }
        
        // If both of line 2 are embedded in line 1, then no.
        if
            pointEmbeddedInLineSegmentPlane(point: line2Point1,
                                           linePoint1: line1Point1,
                                           linePoint2: line1Point2)  &&
            pointEmbeddedInLineSegmentPlane(point: line2Point2,
                                               linePoint1: line1Point1,
                                               linePoint2: line1Point2){
            return false
        }
        return true
    }
    
    public struct TriangleAnglesResult {
        let angle1: Float
        let angle2: Float
        let angle3: Float
    }
    public static func triangleAngles(point1: Point, point2: Point, point3: Point) -> TriangleAnglesResult {
        
        let lineDirX1 = point1.x - point2.x
        let lineDirY1 = point1.y - point2.y
        guard (lineDirX1 * lineDirX1 + lineDirY1 * lineDirY1) > Math.epsilon else {
            return TriangleAnglesResult(angle1: Math.pi, angle2: 0.0, angle3: 0.0)
        }
        
        let lineDirX2 = point2.x - point3.x
        let lineDirY2 = point2.y - point3.y
        guard (lineDirX2 * lineDirX2 + lineDirY2 * lineDirY2) > Math.epsilon else {
            return TriangleAnglesResult(angle1: 0.0, angle2: Math.pi, angle3: 0.0)
        }
        
        let lineDirX3 = point3.x - point1.x
        let lineDirY3 = point3.y - point1.y
        guard (lineDirX3 * lineDirX3 + lineDirY3 * lineDirY3) > Math.epsilon else {
            return TriangleAnglesResult(angle1: 0.0, angle2: 0.0, angle3: Math.pi)
        }
        
        let lineDirAngle1 = atan2f(lineDirX1, lineDirY1)
        let lineDirAngle2 = atan2f(lineDirX2, lineDirY2)
        let lineDirAngle3 = atan2f(lineDirX3, lineDirY3)
        
        let antiAngle1 = distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle3, lineDirAngle1)
        let antiAngle2 = distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle2, lineDirAngle1)
        let antiAngle3 = distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle2, lineDirAngle3)
        
        return TriangleAnglesResult(angle1: Math.pi - antiAngle1,
                                    angle2: Math.pi - antiAngle2,
                                    angle3: Math.pi - antiAngle3)
    }
    
    public static func triangleMinimumAngle(point1: Point, point2: Point, point3: Point) -> Float {
        
        let lineDirX1 = point1.x - point2.x
        let lineDirY1 = point1.y - point2.y
        guard (lineDirX1 * lineDirX1 + lineDirY1 * lineDirY1) > Math.epsilon else {
            return 0.0
        }
        
        let lineDirX2 = point2.x - point3.x
        let lineDirY2 = point2.y - point3.y
        guard (lineDirX2 * lineDirX2 + lineDirY2 * lineDirY2) > Math.epsilon else {
            return 0.0
        }
        
        let lineDirX3 = point3.x - point1.x
        let lineDirY3 = point3.y - point1.y
        guard (lineDirX3 * lineDirX3 + lineDirY3 * lineDirY3) > Math.epsilon else {
            return 0.0
        }
        
        let lineDirAngle1 = atan2f(lineDirX1, lineDirY1)
        let lineDirAngle2 = atan2f(lineDirX2, lineDirY2)
        let lineDirAngle3 = atan2f(lineDirX3, lineDirY3)
        
        let antiAngle1 = distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle3, lineDirAngle1)
        let antiAngle2 = distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle2, lineDirAngle1)
        let antiAngle3 = distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle2, lineDirAngle3)
        
        let triangleAngle1 = Math.pi - antiAngle1
        let triangleAngle2 = Math.pi - antiAngle2
        let triangleAngle3 = Math.pi - antiAngle3
        
        var result = triangleAngle1
        if triangleAngle2 < result { result = triangleAngle2 }
        if triangleAngle3 < result { result = triangleAngle3 }
        
        return result
    }
    
    //
    // This is specifically the angle with p2 as the center point
    //
    //  P1
    //  |
    //  |
    //  P2-----P3
    //
    //  would return pi / 2
    //
    public static func triangleAngle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) -> Float {
        
        // the angle of line (p1, p2)
        let angle1 = -atan2f(-(x1 - x2), -(y1 - y2))
        
        // the angle of line (p3, p2)
        let angle2 = -atan2f(-(x3 - x2), -(y3 - y2))
        
        // add the 2 directions together, this is the "p2 normal"
        let normalX = sinf(angle1) + sinf(angle2)
        let normalY = -cosf(angle1) - cosf(angle2)
        
        // maybe we are exceedingly close to 180 degrees, e.g. the normal is tiny
        guard (normalX * normalX + normalY * normalY > Math.epsilon) else {
            
            // make small adjustment to the angles, this will still
            // be the exact same answer (within floating point percision).
            let normalX = sinf(angle1 - 0.25) + sinf(angle2 + 0.25)
            let normalY = -cosf(angle1 - 0.25) - cosf(angle2 + 0.25)
            
            // angle of the point's normal
            let angle3 = -atan2f(-normalX, -normalY)
            
            // the point normal bend to one of the line segments
            var difference = angle3 - angle1
            
            if difference < 0.0 {
                // all our angles are positive
                difference += Math.pi2
            }
            
            // the opposite part of the circle, which is half of
            // the full "point 2 angle"
            let half = Math.pi2 - difference
            
            // half + half = whole
            return half + half
        }
        
        // angle of the point's normal
        let angle3 = -atan2f(-normalX, -normalY)
        
        // the point normal bend to one of the line segments
        var difference = angle3 - angle1
        if difference < 0.0 {
            // all our angles are positive
            difference += Math.pi2
        }
        
        //
        // if the triangle is clockwise, we are less than 180 degrees,
        // otherwise, we are more than 180 degrees, so the math is different.
        //
        if (x1 * y2 + x3 * y1 + x2 * y3 - x1 * y3 - x3 * y2 - x2 * y1) > 0.0 {
            // the opposite part of the circle, which is half of
            // the full "point 2 angle"
            let half = Math.pi2 - difference
            
            // half + half = whole
            return half + half
        } else {
            
            // the opposite part of the circle, which is half of
            // the full "point 2 angle", so we take twice
            return Math.pi2 - (difference + difference)
        }
    }
    
    public static func triangleMinimumAngle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) -> Float {
        
        let lineDirX1 = x1 - x2
        let lineDirY1 = y1 - y2
        guard (lineDirX1 * lineDirX1 + lineDirY1 * lineDirY1) > Math.epsilon else {
            return 0.0
        }
        
        let lineDirX2 = x2 - x3
        let lineDirY2 = y2 - y3
        guard (lineDirX2 * lineDirX2 + lineDirY2 * lineDirY2) > Math.epsilon else {
            return 0.0
        }
        
        let lineDirX3 = x3 - x1
        let lineDirY3 = y3 - y1
        guard (lineDirX3 * lineDirX3 + lineDirY3 * lineDirY3) > Math.epsilon else {
            return 0.0
        }
        
        let lineDirAngle1 = atan2f(lineDirX1, lineDirY1)
        let lineDirAngle2 = atan2f(lineDirX2, lineDirY2)
        let lineDirAngle3 = atan2f(lineDirX3, lineDirY3)
        
        let triangleAngle1 = Math.pi - distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle3, lineDirAngle1)
        let triangleAngle2 = Math.pi - distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle2, lineDirAngle1)
        let triangleAngle3 = Math.pi - distanceBetweenAnglesAbsoluteUnsafe(lineDirAngle2, lineDirAngle3)
        
        var result = triangleAngle1
        if triangleAngle2 < result { result = triangleAngle2 }
        if triangleAngle3 < result { result = triangleAngle3 }
        
        return result
    }
    
    public static func triangleArea(point1: Point, point2: Point, point3: Point) -> Float {
        (point2.x - point1.x) * (point3.y - point1.y) - (point3.x - point1.x) * (point2.y - point1.y)
    }
    
    public static func triangleArea(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) -> Float {
        (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)
    }
    
    public static func triangleAreaAbsolute(point1: Point, point2: Point, point3: Point) -> Float {
        let area = (point2.x - point1.x) * (point3.y - point1.y) - (point3.x - point1.x) * (point2.y - point1.y)
        if area < 0.0 {
            return -area
        } else {
            return area
        }
    }
    
    
    public static func triangleAreaAbsolute(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) -> Float {
        let area = (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)
        if area < 0.0 {
            return -area
        } else {
            return area
        }
    }
    
    /*
    private static func between(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) -> Bool {
        if fabsf(x1 - x2) > Math.epsilon {
            return (((x1 <= x3) && (x3 <= x2)) || ((x1 >= x3) && (x3 >= x2)))
        } else {
            return ((y1 <= y3) && (y3 <= y2)) || ((y1 >= y3) && (y3 >= y2))
        }
    }
    */
    
    public static func lineSegmentIntersectsLineSegment(line1Point1X: Float,
                                                 line1Point1Y: Float,
                                                 line1Point2X: Float,
                                                 line1Point2Y: Float,
                                                 line2Point1X: Float,
                                                 line2Point1Y: Float,
                                                 line2Point2X: Float,
                                                 line2Point2Y: Float) -> Bool {
        
        let area1 = (line1Point2X - line1Point1X) * (line2Point1Y - line1Point1Y) - (line2Point1X - line1Point1X) * (line1Point2Y - line1Point1Y)
        if fabsf(area1) < Math.epsilon {
            if fabsf(line1Point1X - line1Point2X) > Math.epsilon {
                if (line1Point1X <= line2Point1X) && (line2Point1X <= line1Point2X) {
                    return true
                } else if (line1Point1X >= line2Point1X) && (line2Point1X >= line1Point2X) {
                    return true
                }
            } else {
                if (line1Point1Y <= line2Point1Y) && (line2Point1Y <= line1Point2Y) {
                    return true
                } else if (line1Point1Y >= line2Point1Y) && (line2Point1Y >= line1Point2Y) {
                    return true
                }
            }
            if fabsf((line1Point2X - line1Point1X) * (line2Point2Y - line1Point1Y) -
                     (line2Point2X - line1Point1X) * (line1Point2Y - line1Point1Y)) < Math.epsilon {
                if fabsf(line2Point1X - line2Point2X) > Math.epsilon {
                    if (line2Point1X <= line1Point1X) && (line1Point1X <= line2Point2X) {
                        return true
                    } else if (line2Point1X >= line1Point1X) && (line1Point1X >= line2Point2X) {
                        return true
                    } else if (line2Point1X <= line1Point2X) && (line1Point2X <= line2Point2X) {
                        return true
                    } else if (line2Point1X >= line1Point2X) && (line1Point2X >= line2Point2X) {
                        return true
                    }
                } else {
                    if (line2Point1Y <= line1Point1Y) && (line1Point1Y <= line2Point2Y) {
                        return true
                    } else if (line2Point1Y >= line1Point1Y) && (line1Point1Y >= line2Point2Y) {
                        return true
                    } else if (line2Point1Y <= line1Point2Y) && (line1Point2Y <= line2Point2Y) {
                        return true
                    } else if (line2Point1Y >= line1Point2Y) && (line1Point2Y >= line2Point2Y) {
                        return true
                    }
                }
            }
            return false
        }
        
        let area2 = (line1Point2X - line1Point1X) * (line2Point2Y - line1Point1Y) - (line2Point2X - line1Point1X) * (line1Point2Y - line1Point1Y)
        if fabsf(area2) < Math.epsilon {
            if fabsf(line1Point1X - line1Point2X) > Math.epsilon {
                if (line1Point1X <= line2Point2X) && (line2Point2X <= line1Point2X) {
                    return true
                } else if (line1Point1X >= line2Point2X) && (line2Point2X >= line1Point2X) {
                    return true
                } else {
                    return false
                }
            } else {
                if (line1Point1Y <= line2Point2Y) && (line2Point2Y <= line1Point2Y) {
                    return true
                } else if (line1Point1Y >= line2Point2Y) && (line2Point2Y >= line1Point2Y) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        let area3 = (line2Point2X - line2Point1X) * (line1Point1Y - line2Point1Y) - (line1Point1X - line2Point1X) * (line2Point2Y - line2Point1Y)
        if fabsf(area3) < Math.epsilon {
            if fabsf(line2Point1X - line2Point2X) > Math.epsilon {
                if (line2Point1X <= line1Point1X) && (line1Point1X <= line2Point2X) {
                    return true
                } else if (line2Point1X >= line1Point1X) && (line1Point1X >= line2Point2X) {
                    return true
                }
            } else {
                if (line2Point1Y <= line1Point1Y) && (line1Point1Y <= line2Point2Y) {
                    return true
                } else if (line2Point1Y >= line1Point1Y) && (line1Point1Y >= line2Point2Y) {
                    return true
                }
            }
            if fabsf((line2Point2X - line2Point1X) * (line1Point2Y - line2Point1Y) -
                     (line1Point2X - line2Point1X) * (line2Point2Y - line2Point1Y)) < Math.epsilon {
                if fabsf(line1Point1X - line1Point2X) > Math.epsilon {
                    if (line1Point1X <= line2Point1X) && (line2Point1X <= line1Point2X) {
                        return true
                    } else if (line1Point1X >= line2Point1X) && (line2Point1X >= line1Point2X) {
                        return true
                    } else if (line1Point1X <= line2Point2X) && (line2Point2X <= line1Point2X) {
                        return true
                    } else if (line1Point1X >= line2Point2X) && (line2Point2X >= line1Point2X) {
                        return true
                    }
                } else {
                    if (line1Point1Y <= line2Point1Y) && (line2Point1Y <= line1Point2Y) {
                        return true
                    } else if (line1Point1Y >= line2Point1Y) && (line2Point1Y >= line1Point2Y) {
                        return true
                    } else if (line1Point1Y <= line2Point2Y) && (line2Point2Y <= line1Point2Y) {
                        return true
                    } else if (line1Point1Y >= line2Point2Y) && (line2Point2Y >= line1Point2Y) {
                        return true
                    }
                }
            }
            return false
        }
        let area4 = (line2Point2X - line2Point1X) * (line1Point2Y - line2Point1Y) - (line1Point2X - line2Point1X) * (line2Point2Y - line2Point1Y)
        if fabsf(area4) < Math.epsilon {
            if fabsf(line2Point1X - line2Point2X) > Math.epsilon {
                if (line2Point1X <= line1Point2X) && (line1Point2X <= line2Point2X) {
                    return true
                } else if (line2Point1X >= line1Point2X) && (line1Point2X >= line2Point2X) {
                    return true
                } else {
                    return false
                }
            } else {
                if (line2Point1Y <= line1Point2Y) && (line1Point2Y <= line2Point2Y) {
                    return true
                } else if (line2Point1Y >= line1Point2Y) && (line1Point2Y >= line2Point2Y) {
                    return true
                } else {
                    return false
                }
            }
        }
        return ((area1 > 0.0) != (area2 > 0.0)) && ((area3 > 0.0) != (area4 > 0.0))
    }
    
    public static func lineSegmentIntersectsLineSegment(line1Point1: Point,
                                                 line1Point2: Point,
                                                 line2Point1: Point,
                                                 line2Point2: Point) -> Bool {

        lineSegmentIntersectsLineSegment(line1Point1X: line1Point1.x, line1Point1Y: line1Point1.y,
                                         line1Point2X: line1Point2.x, line1Point2Y: line1Point2.y,
                                         line2Point1X: line2Point1.x, line2Point1Y: line2Point1.y,
                                         line2Point2X: line2Point2.x, line2Point2Y: line2Point2.y)
    }
    
    public static func lineSegmentShortestConnectingLineSegmentToLineSegment(line1Point1: Point, line1Point2: Point, line2Point1: Point, line2Point2: Point) -> (point1: Point, point2: Point) {
        let cp1_1 = Math.segmentClosestPoint(point: line1Point1, linePoint1: line2Point1, linePoint2: line2Point2)
        let cp1_2 = Math.segmentClosestPoint(point: line1Point2, linePoint1: line2Point1, linePoint2: line2Point2)
        let cp2_1 = Math.segmentClosestPoint(point: line2Point1, linePoint1: line1Point1, linePoint2: line1Point2)
        let cp2_2 = Math.segmentClosestPoint(point: line2Point2, linePoint1: line1Point1, linePoint2: line1Point2)
        
        let distance0 = cp1_1.distanceSquaredTo(cp2_1)
        let distance1 = cp1_1.distanceSquaredTo(cp2_2)
        let distance2 = cp1_2.distanceSquaredTo(cp2_1)
        let distance3 = cp1_2.distanceSquaredTo(cp2_2)
        
        var chosenDistance = distance0
        var chosenIndex = 0
        if distance1 < chosenDistance {
            chosenIndex = 1
            chosenDistance = distance1
        }
        if distance2 < chosenDistance {
            chosenIndex = 2
            chosenDistance = distance2
        }
        if distance3 < chosenDistance {
            chosenIndex = 3
        }
        
        if chosenIndex == 0 {
            return (cp2_1, cp1_1)
        } else if chosenIndex == 1 {
            return (cp2_2, cp1_1)
        } else if chosenIndex == 2 {
            return (cp2_1, cp1_2)
        } else {
            return (cp2_2, cp1_2)
        }
    }
    
    public static func lineSegmentDistanceSquaredToLineSegment(line1Point1: Point, line1Point2: Point, line2Point1: Point, line2Point2: Point) -> Float {
        
        if lineSegmentIntersectsLineSegment(line1Point1: line1Point1,
                                            line1Point2: line1Point2,
                                            line2Point1: line2Point1,
                                            line2Point2: line2Point2) {
            return 0.0
        }
        
        let cp1_1 = Math.segmentClosestPoint(point: line1Point1, linePoint1: line2Point1, linePoint2: line2Point2)
        let cp1_2 = Math.segmentClosestPoint(point: line1Point2, linePoint1: line2Point1, linePoint2: line2Point2)
        let cp2_1 = Math.segmentClosestPoint(point: line2Point1, linePoint1: line1Point1, linePoint2: line1Point2)
        let cp2_2 = Math.segmentClosestPoint(point: line2Point2, linePoint1: line1Point1, linePoint2: line1Point2)
        
        let distance0 = cp1_1.distanceSquaredTo(cp2_1)
        let distance1 = cp1_1.distanceSquaredTo(cp2_2)
        let distance2 = cp1_2.distanceSquaredTo(cp2_1)
        let distance3 = cp1_2.distanceSquaredTo(cp2_2)
        
        var chosenDistance = distance0
        if distance1 < chosenDistance { chosenDistance = distance1 }
        if distance2 < chosenDistance { chosenDistance = distance2 }
        if distance3 < chosenDistance { chosenDistance = distance3 }
        return chosenDistance
    }
    
    public static func dot(x1: Float, y1: Float, x2: Float, y2: Float) -> Float {
        x1 * x2 + y1 * y2
    }
    
    public static func cross(x1: Float, y1: Float, x2: Float, y2: Float) -> Float {
        x1 * y2 - x2 * y1
    }
    
    public static func triangleIsClockwise(x1: Float, y1: Float,
                                    x2: Float, y2: Float,
                                    x3: Float, y3: Float) -> Bool {
        if (x1 * y2 + x3 * y1 + x2 * y3 - x1 * y3 - x3 * y2 - x2 * y1) > 0.0 {
            return false
        } else {
            return true
        }
    }
    
    public static func polygonIsClockwise(_ polygon: [Point]) -> Bool {
        var area = Float(0.0)
        var index1 = polygon.count - 1
        var index2 = 0
        while index2 < polygon.count {
            let point1 = polygon[index1]
            let point2 = polygon[index2]
            area += Math.cross(x1: point1.x, y1: point1.y,
                               x2: point2.x, y2: point2.y)
            index1 = index2
            index2 += 1
        }
        return area > 0.0
    }
    
    public static func polygonIsCounterClockwise(_ points: [Point]) -> Bool {
        return !polygonIsClockwise(points)
    }
    
    public static func polygonIndexDistance(index1: Int, index2: Int, count: Int) -> Int {
        let larger = max(index1, index2)
        let smaller = min(index1, index2)
        let choice1 = larger - smaller
        let choice2 = ((count) - larger) + (smaller)
        return min(choice1, choice2)
    }
    
    public static func polygonTourCrosses(index: Int, startIndex: Int, endIndex: Int) -> Bool {
        if startIndex == endIndex {
            if index == startIndex {
                return true
            }
        } else {
            if startIndex < endIndex {
                if index >= startIndex && index <= endIndex {
                    return true
                }
            } else {
                if index >= startIndex {
                    return true
                }
                if index <= endIndex {
                    return true
                }
            }
        }
        return false
    }
    
    public static func polygonTourLength(startIndex: Int, endIndex: Int, count: Int) -> Int {
        if startIndex == endIndex {
            return 1
        } else {
            if startIndex < endIndex {
                return (endIndex - startIndex) + 1
            } else {
                return (count - startIndex) + (endIndex) + 1
            }
        }
    }
    
    public static func polygonTourLength(index: Int, startIndex: Int, endIndex: Int, count: Int) -> Int? {
        if startIndex == endIndex {
            if index == startIndex {
                return 1
            }
        } else {
            if startIndex < endIndex {
                if index >= startIndex && index <= endIndex {
                    return (index - startIndex) + 1
                }
            } else {
                if index >= startIndex {
                    return (index - startIndex) + 1
                }
                if index <= endIndex {
                    return (count - startIndex) + (index) + 1
                }
            }
        }
        return nil
    }
    
    /*
    public static func polygonIsComplex(_ polygon: [Point]) -> Bool {
        let count = polygon.count
        if count > 3 {
            let count_2 = (count - 2)
            let count_1 = (count - 1)
            var outerMinusOne = 0
            var outer = 1
            while outer < count_2 {
                var innerMinusOne = outer + 1
                var inner = innerMinusOne + 1
                while inner < count {
                    if Math.lineSegmentIntersectsLineSegment(line1Point1: polygon[outerMinusOne], line1Point2: polygon[outer],
                                                             line2Point1: polygon[innerMinusOne], line2Point2: polygon[inner]) {
                        return true
                    }
                    innerMinusOne = inner
                    inner += 1
                }
                outerMinusOne = outer
                outer += 1
            }
            outerMinusOne = 1
            outer = 2
            while outer < count_1 {
                if Math.lineSegmentIntersectsLineSegment(line1Point1: polygon[count_1], line1Point2: polygon[0],
                                                         line2Point1: polygon[outerMinusOne], line2Point2: polygon[outer]) {
                    return true
                }
                outerMinusOne = outer
                outer += 1
            }
        }
        return false
    }
    
    public static func polygonIsSimple(_ polygon: [Point]) -> Bool {
        return !polygonIsComplex(polygon)
    }
    
    public static func polygonContainsPoint(_ polygon: [Point], _ point: Point) -> Bool {
        var end = polygon.count - 1
        var start = 0
        var result = false
        while start < polygon.count {
            
            let point1 = polygon[start]
            let point2 = polygon[end]
            
            let x1: Float
            let y1: Float
            let x2: Float
            let y2: Float
            if point1.x < point2.x {
                x1 = point1.x
                y1 = point1.y
                x2 = point2.x
                y2 = point2.y
            } else {
                x1 = point2.x
                y1 = point2.y
                x2 = point1.x
                y2 = point1.y
            }
            if point.x > x1 && point.x <= x2 {
                if (point.x - x1) * (y2 - y1) - (point.y - y1) * (x2 - x1) < 0.0 {
                    result = !result
                }
            }
            end = start
            start += 1
        }
        return result
    }
    
    
    public static func triangleCentroid(point1: Point, point2: Point, point3: Point) -> Point {
        var result = Point(x: 0.0, y: 0.0)
        var area = Float(0.0)
        
        let cross1 = Math.cross(x1: point1.x, y1: point1.y,
                               x2: point2.x, y2: point2.y)
        area += cross1
        result.x += (point1.x + point2.x) * cross1
        result.y += (point1.y + point2.y) * cross1
        
        let cross2 = Math.cross(x1: point2.x, y1: point3.y,
                               x2: point2.x, y2: point3.y)
        area += cross2
        result.x += (point2.x + point3.x) * cross2
        result.y += (point2.y + point3.y) * cross2
        
        
        let cross3 = Math.cross(x1: point3.x, y1: point1.y,
                               x2: point3.x, y2: point1.y)
        area += cross3
        result.x += (point3.x + point1.x) * cross3
        result.y += (point3.y + point1.y) * cross3
        
        if area > Math.epsilon || area < Math._epsilon {
            area *= 3.0
            result.x /= area
            result.y /= area
        }
        return result
    }
     */
    
    /*
    public static func polygonCentroid(_ polygon: [Point]) -> Point {
        var result = Point(x: 0.0, y: 0.0)
        var area = Float(0.0)
        
        var index1 = polygon.count - 1
        var index2 = 0
        while index2 < polygon.count {
            let point1 = polygon[index1]
            let point2 = polygon[index2]
            let cross = Math.cross(x1: point1.x, y1: point1.y,
                                   x2: point2.x, y2: point2.y)
            area += cross
            
            result.x += (point1.x + point2.x) * cross
            result.y += (point1.y + point2.y) * cross
            
            index1 = index2
            index2 += 1
        }
        
        if area > Math.epsilon || area < Math._epsilon {
            area *= 3.0
            result.x /= area
            result.y /= area
        }
        return result
    }
    */

    public static func circleIntersectsCircle(circle1Center: Point, circle1Radius: Float, circle2Center: Point, circle2Radius: Float) -> Bool {
        let radiusSum = circle1Radius + circle2Radius
        return circle1Center.distanceSquaredTo(circle2Center) <= (radiusSum * radiusSum)
    }
}
