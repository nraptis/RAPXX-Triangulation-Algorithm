//
//  Ring+EarLegalComplex.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/12/24.
//

import Foundation

extension Ring {
    
    func measureEarLegalComplexHelper(index: Int) -> Bool {
        
        //let ringPointCount1 = ringPointCount - 1
        
        let ringLineSegmentCount = ringLineSegmentCount
        
        var tourStartIndex = index - 2
        if tourStartIndex < 0 {
            tourStartIndex += ringLineSegmentCount
        }
        
        var tourEndIndex = index + 1
        if tourEndIndex >= ringLineSegmentCount {
            tourEndIndex -= ringLineSegmentCount
        }
        
        if tourStartIndex < tourEndIndex {
            for ringLineSegmentIndex in 0..<ringLineSegmentCount {
                if ringLineSegmentIndex >= tourStartIndex && ringLineSegmentIndex <= tourEndIndex {
                    continue
                }
                let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
                if preComputedLineSegment1.intersects(lineSegment: ringLineSegment) {
                    return false
                }
            }
        } else {
            for ringLineSegmentIndex in 0..<ringLineSegmentCount {
                if ringLineSegmentIndex >= tourStartIndex || ringLineSegmentIndex <= tourEndIndex {
                    continue
                }
                let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
                if preComputedLineSegment1.intersects(lineSegment: ringLineSegment) {
                    return false
                }
            }
        }
        return true
    }
}
