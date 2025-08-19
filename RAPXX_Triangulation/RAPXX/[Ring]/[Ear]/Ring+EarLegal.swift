//
//  Ring+EarLegal.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/12/24.
//

import Foundation

extension Ring {
    
    func measureEarLegalRegular(index: Int) -> Bool {
        
        if index < 0 || index >= ringPointCount {
            return false
        }
        
        if ringPointCount < 4 {
            return false
        }
        
        let ringPointCount1 = ringPointCount - 1
        
        var index1 = index - 1
        if index1 == -1 {
            index1 = ringPointCount1
        }
        
        var index2 = index + 1
        if index2 == ringPointCount {
            index2 = 0
        }
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        
        preComputedLineSegment1.x1 = splitRingPoint1.x
        preComputedLineSegment1.y1 = splitRingPoint1.y
        preComputedLineSegment1.x2 = splitRingPoint2.x
        preComputedLineSegment1.y2 = splitRingPoint2.y
        
        if !measureEarLegalClockwiseHelper(index: index) { return false }
        
        if !measureEarLegalComplexHelper(index: index) { return false }
        
        preComputedLineSegment1.precompute()
        
        let minIndex = min(index1, index2)
        let maxIndex = max(index1, index2)
        
        if !measureEarLegalPointClosenessNeighborHelper(index1: minIndex, index2: maxIndex) { return false }
        if !measureEarLegalPointClosenessDistantHelper(index1: minIndex, index2: maxIndex) { return false }
        
        return true
    }
    
    func measureEarLegalForCapOff(index: Int) -> Bool {
        
        if index < 0 || index >= ringPointCount {
            return false
        }
        
        if ringPointCount < 4 {
            return false
        }
        
        let ringPointCount1 = ringPointCount - 1
        
        var index1 = index - 1
        if index1 == -1 {
            index1 = ringPointCount1
        }
        
        var index2 = index + 1
        if index2 == ringPointCount {
            index2 = 0
        }
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        
        preComputedLineSegment1.x1 = splitRingPoint1.x
        preComputedLineSegment1.y1 = splitRingPoint1.y
        preComputedLineSegment1.x2 = splitRingPoint2.x
        preComputedLineSegment1.y2 = splitRingPoint2.y
        
        if !measureEarLegalClockwiseHelper(index: index) {
            return false
        }
        
        if !measureEarLegalComplexHelper(index: index) {
            return false
        }
        
        return true
    }
    
}
