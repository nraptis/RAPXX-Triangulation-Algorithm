//
//  Ring+EarLegalClockwise.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/12/24.
//

import Foundation

extension Ring {
    
    func measureEarLegalClockwiseHelper(index: Int) -> Bool {
        
        var area = Math.cross(x1: preComputedLineSegment1.x1,
                              y1: preComputedLineSegment1.y1,
                              x2: preComputedLineSegment1.x2,
                              y2: preComputedLineSegment1.y2)
        
        var index1 = index + 1
        if index1 == ringPointCount {
            index1 = 0
        }
        
        var index2 = index1 + 1
        if index2 == ringPointCount {
            index2 = 0
        }
        
        while index2 != index {
            let ringPoint1 = ringPoints[index1]
            let ringPoint2 = ringPoints[index2]
            area += Math.cross(x1: ringPoint1.x, y1: ringPoint1.y,
                               x2: ringPoint2.x, y2: ringPoint2.y)
            index1 = index2
            index2 += 1
            if index2 == ringPointCount {
                index2 = 0
            }
        }
        
        return area > 0.0
    }
    
}
