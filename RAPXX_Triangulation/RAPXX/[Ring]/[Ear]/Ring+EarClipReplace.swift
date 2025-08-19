//
//  Ring+EarClipReplace.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/5/24.
//

import Foundation

extension Ring {
    
    //
    // As a note, this will NOT update the line segment button currently.
    // Something could go awry during this, such as an illegal line segment or ring point angle.
    //
    func earClipReplaceRingPointZeroRingPoints(ringPointIndex: Int) -> Bool {
        
        let previousRingPoint = ringPoints[ringPointIndex]
        let neighborLeft = previousRingPoint.neighborLeft!
        let neighborRight = previousRingPoint.neighborRight!
        let previousLineSegmentLeft = previousRingPoint.ringLineSegmentLeft!
        let previousLineSegmentRight = previousRingPoint.ringLineSegmentRight!
        let previousLineSegmentRightRight = previousLineSegmentRight.neighborRight!
        
        previousLineSegmentLeft.x2 = neighborRight.x
        previousLineSegmentLeft.y2 = neighborRight.y
        
        neighborLeft.neighborRight = neighborRight
        neighborRight.neighborLeft = neighborLeft
        
        neighborRight.ringLineSegmentLeft = previousLineSegmentLeft
        neighborLeft.ringLineSegmentRight = previousLineSegmentLeft
        
        previousLineSegmentLeft.neighborRight = previousLineSegmentRightRight
        previousLineSegmentRightRight.neighborLeft = previousLineSegmentLeft
        
        previousLineSegmentLeft.ringPointRight = neighborRight
        previousLineSegmentRightRight.ringPointLeft = neighborRight
        
        ringPointCount -= 1
        ringLineSegmentCount -= 1
        var shiftIndex = 0
        
        shiftIndex = ringPointIndex
        while shiftIndex < ringPointCount {
            ringPoints[shiftIndex] = ringPoints[shiftIndex + 1]
            ringPoints[shiftIndex].ringIndex = shiftIndex
            shiftIndex += 1
        }
        
        shiftIndex = ringPointIndex
        while shiftIndex < ringPointCount {
            ringLineSegments[shiftIndex] = ringLineSegments[shiftIndex + 1]
            ringLineSegments[shiftIndex].ringIndex = shiftIndex
            shiftIndex += 1
        }
        
        //We don't need this anymore...!!!
        PolyMeshPartsFactory.shared.depositRingLineSegment(previousLineSegmentRight)
        
        previousLineSegmentLeft.precompute()
        if previousLineSegmentLeft.isIllegal { return false }
        
        if !calculateRingPointNormal(ringPoint: neighborLeft) { return false }
        if !calculateRingPointNormal(ringPoint: neighborRight) { return false }
        if !calculateRingPointAngularSpan(ringPoint: neighborLeft) { return false }
        if !calculateRingPointAngularSpan(ringPoint: neighborRight) { return false }
        
        return true
    }
    
    //
    // As a note, this will NOT update the line segment button currently.
    // Something could go awry during this, such as an illegal line segment or ring point angle.
    //
    func earClipReplaceRingPointOneRingPoint(ringPointIndex: Int) -> Bool {
        
        let previousRingPoint = ringPoints[ringPointIndex]
        let previousLineSegmentLeft = previousRingPoint.ringLineSegmentLeft!
        let previousLineSegmentRight = previousRingPoint.ringLineSegmentRight!
        
        let neighborLeft = previousLineSegmentLeft.ringPointLeft!
        let neighborRight = previousLineSegmentRight.ringPointRight!
        
        let ringPoint = PolyMeshPartsFactory.shared.withdrawRingPoint()
        ringPoint.x = (neighborLeft.x + neighborRight.x) * 0.5
        ringPoint.y = (neighborLeft.y + neighborRight.y) * 0.5
        ringPoints[ringPointIndex] = ringPoint
        
        ringPoint.ringIndex = ringPointIndex
        ringPoint.ringLineSegmentLeft = previousLineSegmentLeft
        ringPoint.ringLineSegmentRight = previousLineSegmentRight
        ringPoint.neighborLeft = neighborLeft
        ringPoint.neighborRight = neighborRight
        
        previousLineSegmentLeft.ringPointRight = ringPoint
        previousLineSegmentRight.ringPointLeft = ringPoint
        
        neighborLeft.neighborRight = ringPoint
        neighborRight.neighborLeft = ringPoint
        
        previousLineSegmentLeft.x2 = ringPoint.x
        previousLineSegmentLeft.y2 = ringPoint.y
        previousLineSegmentRight.x1 = ringPoint.x
        previousLineSegmentRight.y1 = ringPoint.y
        
        previousLineSegmentLeft.precompute()
        previousLineSegmentRight.precompute()
        
        if previousLineSegmentLeft.isIllegal { return false }
        if previousLineSegmentRight.isIllegal { return false }
        
        if !calculateRingPointNormal(ringPoint: neighborLeft) { return false }
        if !calculateRingPointNormal(ringPoint: ringPoint) { return false }
        if !calculateRingPointNormal(ringPoint: neighborRight) { return false }
        if !calculateRingPointAngularSpan(ringPoint: neighborLeft) { return false }
        if !calculateRingPointAngularSpan(ringPoint: ringPoint) { return false }
        if !calculateRingPointAngularSpan(ringPoint: neighborRight) { return false }
        
        return true
    }
    
    // As a note, this will NOT update the line segment button currently.
    // Something could go awry during this, such as an illegal line segment or ring point angle.
    //
    func earClipReplaceRingPointTwoRingPoints(ringPointIndex: Int) -> Bool {
        
        let previousRingPoint = ringPoints[ringPointIndex]
        
        let previousLineSegmentLeft = previousRingPoint.ringLineSegmentLeft!
        let previousLineSegmentRight = previousRingPoint.ringLineSegmentRight!
        
        let neighborLeft = previousLineSegmentLeft.ringPointLeft!
        let neighborRight = previousLineSegmentRight.ringPointRight!
        
        let deltaX = neighborRight.x - neighborLeft.x
        let deltaY = neighborRight.y - neighborLeft.y
         
        let ringPoint1 = PolyMeshPartsFactory.shared.withdrawRingPoint()
        let ringPoint2 = PolyMeshPartsFactory.shared.withdrawRingPoint()
        
        let ringLineSegment = PolyMeshPartsFactory.shared.withdrawRingLineSegment()
        
        ringPoint1.x = neighborLeft.x + deltaX * 0.35
        ringPoint1.y = neighborLeft.y + deltaY * 0.35
        
        ringPoint2.x = neighborLeft.x + deltaX * 0.65
        ringPoint2.y = neighborLeft.y + deltaY * 0.65
        
        addRingPoint(ringPoint1)
        addRingLineSegment(ringLineSegment)
        
        var shiftIndex = 0
        
        shiftIndex = ringPointCount - 1
        while shiftIndex > ringPointIndex {
            ringPoints[shiftIndex] = ringPoints[shiftIndex - 1]
            ringPoints[shiftIndex].ringIndex = shiftIndex
            shiftIndex -= 1
        }
        
        shiftIndex = ringPointCount - 1
        while shiftIndex > ringPointIndex {
            ringLineSegments[shiftIndex] = ringLineSegments[shiftIndex - 1]
            ringLineSegments[shiftIndex].ringIndex = shiftIndex
            shiftIndex -= 1
        }
        
        ringPoints[ringPointIndex] = ringPoint1
        ringPoints[ringPointIndex + 1] = ringPoint2
        ringLineSegments[ringPointIndex] = ringLineSegment
        
        ringPoint1.ringIndex = ringPointIndex
        ringPoint2.ringIndex = ringPointIndex + 1
        
        ringLineSegment.ringIndex = ringPointIndex

        ringPoint1.neighborLeft = neighborLeft
        neighborLeft.neighborRight = ringPoint1
        ringPoint1.neighborRight = ringPoint2
        ringPoint2.neighborLeft = ringPoint1
        ringPoint2.neighborRight = neighborRight
        neighborRight.neighborLeft = ringPoint2
        
        previousLineSegmentLeft.neighborRight = ringLineSegment
        ringLineSegment.neighborLeft = previousLineSegmentLeft
        ringLineSegment.neighborRight = previousLineSegmentRight
        previousLineSegmentRight.neighborLeft = ringLineSegment
        
        ringPoint1.ringLineSegmentLeft = previousLineSegmentLeft
        ringPoint1.ringLineSegmentRight = ringLineSegment
        ringPoint2.ringLineSegmentLeft = ringLineSegment
        ringPoint2.ringLineSegmentRight = previousLineSegmentRight
        
        previousLineSegmentLeft.ringPointRight = ringPoint1
        ringLineSegment.ringPointLeft = ringPoint1
        ringLineSegment.ringPointRight = ringPoint2
        previousLineSegmentRight.ringPointLeft = ringPoint2
        
        previousLineSegmentLeft.x2 = ringPoint1.x
        previousLineSegmentLeft.y2 = ringPoint1.y
        previousLineSegmentLeft.precompute()
        
        ringLineSegment.x1 = ringPoint1.x
        ringLineSegment.y1 = ringPoint1.y
        ringLineSegment.x2 = ringPoint2.x
        ringLineSegment.y2 = ringPoint2.y
        ringLineSegment.precompute()
        
        previousLineSegmentRight.x1 = ringPoint2.x
        previousLineSegmentRight.y1 = ringPoint2.y
        previousLineSegmentRight.precompute()
        
        if previousLineSegmentLeft.isIllegal { return false }
        if ringLineSegment.isIllegal { return false }
        if previousLineSegmentRight.isIllegal { return false }
        
        if !calculateRingPointNormal(ringPoint: neighborLeft) { return false }
        if !calculateRingPointNormal(ringPoint: ringPoint1) { return false }
        if !calculateRingPointNormal(ringPoint: ringPoint2) { return false }
        if !calculateRingPointNormal(ringPoint: neighborRight) { return false }
        if !calculateRingPointAngularSpan(ringPoint: neighborLeft) { return false }
        if !calculateRingPointAngularSpan(ringPoint: ringPoint1) { return false }
        if !calculateRingPointAngularSpan(ringPoint: ringPoint2) { return false }
        if !calculateRingPointAngularSpan(ringPoint: neighborRight) { return false }
        
        return true
    }
}
