//
//  Ring+MinMax.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/6/24.
//

import Foundation

extension Ring {
    
    func getMinX() -> Float {
        var result = Float(0.0)
        if ringPointCount > 0 {
            result = ringPoints[0].x
            var ringPointIndex = 1
            while ringPointIndex < ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                if ringPoint.x < result {
                    result = ringPoint.x
                }
                ringPointIndex += 1
            }
        }
        return result
    }
    
    func getMaxX() -> Float {
        var result = Float(0.0)
        if ringPointCount > 0 {
            result = ringPoints[0].x
            var ringPointIndex = 1
            while ringPointIndex < ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                if ringPoint.x > result {
                    result = ringPoint.x
                }
                ringPointIndex += 1
            }
        }
        return result
    }
    
    func getMinY() -> Float {
        var result = Float(0.0)
        if ringPointCount > 0 {
            result = ringPoints[0].y
            var ringPointIndex = 1
            while ringPointIndex < ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                if ringPoint.y < result {
                    result = ringPoint.y
                }
                ringPointIndex += 1
            }
        }
        return result
    }
    
    func getMaxY() -> Float {
        var result = Float(0.0)
        if ringPointCount > 0 {
            result = ringPoints[0].y
            var ringPointIndex = 1
            while ringPointIndex < ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                if ringPoint.y > result {
                    result = ringPoint.y
                }
                ringPointIndex += 1
            }
        }
        return result
    }
}
