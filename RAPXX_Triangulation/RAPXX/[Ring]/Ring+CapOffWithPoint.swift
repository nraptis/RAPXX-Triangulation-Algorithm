//
//  Ring+CapOffWithPoint.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/15/24.
//

import Foundation

extension Ring {
    
    func attemptCapOffWithPoint(_ x: Float, _ y: Float) -> Bool {
        if ringPointCount < 3 {
            return false
        }
        
        if let triangleData {
            var previousIndex = ringPointCount - 1
            var currentIndex = 0
            while currentIndex < ringPointCount {
                let ringPoint1 = ringPoints[previousIndex]
                let ringPoint2 = ringPoints[currentIndex]
                triangleData.add(x1: ringPoint1.x, y1: ringPoint1.y,
                                 x2: ringPoint2.x, y2: ringPoint2.y,
                                 x3: x, y3: y)
                previousIndex = currentIndex
                currentIndex += 1
            }
        }
        
        
        PolyMeshPartsFactory.shared.depositRingContent(self)

        return true
    }
}
