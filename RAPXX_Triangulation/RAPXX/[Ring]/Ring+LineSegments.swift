//
//  Ring+LineSegments.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/6/24.
//

import Foundation

extension Ring {
    func attemptCalculateLineSegments() -> Bool {
        if attemptCalculateLineSegmentsUnsafe() {
            calculateLineSegmentIndices()
            calculateLineSegmentPointNeighbors()
            calculateLineSegmentNeighbors()
            calculateRingPointLineSegmentNeighbors()
            return true
        }
        return false
    }
    
    func attemptCalculateLineSegmentsUnsafe() -> Bool {
        purgeRingLineSegments()
        var ringPointIndex1 = 0
        var ringPointIndex2 = 1
        while ringPointIndex1 < ringPointCount {
            let ringPoint1 = ringPoints[ringPointIndex1]
            let ringPoint2 = ringPoints[ringPointIndex2]
            let ringLineSegment = PolyMeshPartsFactory.shared.withdrawRingLineSegment()
            ringLineSegment.x1 = ringPoint1.x
            ringLineSegment.y1 = ringPoint1.y
            ringLineSegment.x2 = ringPoint2.x
            ringLineSegment.y2 = ringPoint2.y
            ringLineSegment.precompute()
            
            //ringLineSegment.boundingCircleRadius = (ringLineSegment.length * 0.5) + polyMeshConstants.lineSegmentBoundingCirclePaddingAmount
            //ringLineSegments.append(ringLineSegment)
            addRingLineSegment(ringLineSegment)
            if ringLineSegment.isIllegal {
                return false
            }
            
            ringPointIndex1 += 1
            ringPointIndex2 += 1
            if ringPointIndex2 == ringPointCount {
                ringPointIndex2 = 0
            }
        }
        return true
    }
}
