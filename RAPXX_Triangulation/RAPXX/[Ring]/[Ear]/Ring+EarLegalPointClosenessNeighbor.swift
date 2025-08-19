//
//  Ring+EarLegalPointClosenessNeighbor.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/12/24.
//

import Foundation

extension Ring {
    
    func measureEarLegalPointClosenessNeighborHelper(index1: Int, index2: Int) -> Bool {
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        let ringPointCount1 = ringPointCount - 1
        
        let highQualityDistance = (RingSplitQuality.splitQualityPointClosenessNeighborThresholdGreat + Math.epsilon)
        
        var neighborRingPointIndex2 = index1 - 1
        if neighborRingPointIndex2 == -1 {
            neighborRingPointIndex2 = ringPointCount1
        }
        let neighborRingPoint2 = ringPoints[neighborRingPointIndex2]
        let neighborDistanceSquared2 = preComputedLineSegment1.distanceSquaredToClosestPoint(neighborRingPoint2.x, neighborRingPoint2.y)
        if neighborDistanceSquared2 < Math.epsilon { return false }
        let neighborDistance2 = sqrtf(neighborDistanceSquared2)
        let baselineDistance2 = splitRingPoint1.ringLineSegmentLeft.length
        let difference2 = baselineDistance2 - neighborDistance2
        
        var percent2 = difference2 / PolyMeshConstants.splitPointNeighborGraduationSpan
        if percent2 < 0.0 { percent2 = 0.0 }
        if percent2 > 1.0 { percent2 = 1.0 }
        
        let theoreticalDistance2 = (highQualityDistance * (1.0 - percent2)) + ((neighborDistance2) * percent2)
        if theoreticalDistance2 < PolyMeshConstants.splitPointNeighborTooCloseToLineSegment { return false }
        
        var neighborRingPointIndex3 = index2 + 1
        if neighborRingPointIndex3 == ringPointCount {
            neighborRingPointIndex3 = 0
        }
        let neighborRingPoint3 = ringPoints[neighborRingPointIndex3]
        let neighborDistanceSquared3 = preComputedLineSegment1.distanceSquaredToClosestPoint(neighborRingPoint3.x, neighborRingPoint3.y)
        if neighborDistanceSquared3 < Math.epsilon { return false }
        let neighborDistance3 = sqrtf(neighborDistanceSquared3)
        let baselineDistance3 = splitRingPoint2.ringLineSegmentRight.length
        let difference3 = baselineDistance3 - neighborDistance3
        
        var percent3 = difference3 / PolyMeshConstants.splitPointNeighborGraduationSpan
        if percent3 < 0.0 { percent3 = 0.0 }
        if percent3 > 1.0 { percent3 = 1.0 }
        
        let theoreticalDistance3 = (highQualityDistance * (1.0 - percent3)) + ((neighborDistance3) * percent3)
        if theoreticalDistance3 < PolyMeshConstants.splitPointNeighborTooCloseToLineSegment { return false }
        
        return true
    }
}
