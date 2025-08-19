//
//  Ring+SplitMeasureQuality.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/11/24.
//

import Foundation

extension Ring {
    
    func attemptMeasureSplitQuality(index1: Int, index2: Int, quality: inout RingSplitQuality) -> Bool {
        
        if index1 < 0 || index1 >= ringPointCount {
            return false
        }
        
        if index2 < 0 || index2 >= ringPointCount {
            return false
        }
        
        if Math.polygonIndexDistance(index1: index1, index2: index2, count: ringPointCount) < 1 {
            return false
        }
        
        if index1 >= index2 {
            return false
        }
        
        //1 / 6
        if !attemptMeasureSplitQualityEarAngles(index1: index1, index2: index2, quality: &quality) {
            return false
        }
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        preComputedLineSegment1.x1 = splitRingPoint1.x
        preComputedLineSegment1.y1 = splitRingPoint1.y
        preComputedLineSegment1.x2 = splitRingPoint2.x
        preComputedLineSegment1.y2 = splitRingPoint2.y
        preComputedLineSegment1.precompute()
        
        //2 / 6
        if !attemptMeasureSplitQualityPointClosenessNeighbor(index1: index1, index2: index2, quality: &quality) {
            return false
        }
        
        //3 / 6
        if !attemptMeasureSplitQualityPointClosenessDistant(index1: index1, index2: index2, quality: &quality) {
            return false
        }
        
        let count1 = index2 - index1
        let count2 = (ringPointCount - index2) + index1
        if count1 < count2 {
            //4 / 6
            quality.numberOfPoints = RingSplitQuality.classifyNumberOfPoints(count1 + 1)
        } else {
            //4 / 6
            quality.numberOfPoints = RingSplitQuality.classifyNumberOfPoints(count2 + 1)
        }
        
        //5 / 6
        quality.splitLengthMax = RingSplitQuality.classifySplitLengthMax(preComputedLineSegment1.length)
        
        //6 / 6
        quality.splitLengthMin = RingSplitQuality.classifySplitLengthMin(preComputedLineSegment1.length)
        
        quality.calculateWeight()
        
        return true
    }
}
