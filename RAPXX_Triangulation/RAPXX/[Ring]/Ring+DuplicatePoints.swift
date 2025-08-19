//
//  Ring+DuplicatePoints.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/22/23.
//

import Foundation

extension Ring {
    
    public func containsDuplicatePointsOuter() -> Bool {
        
        let pointTooCloseOuter = PolyMeshConstants.pointTooCloseOuter
        let pointTooCloseOuterSquared = pointTooCloseOuter * pointTooCloseOuter
        
        var index1 = ringPointCount - 1
        var index2 = 0
        while index2 < ringPointCount {
            let ringPoint1 = ringPoints[index1]
            let ringPoint2 = ringPoints[index2]
            
            if ringPoint1.distanceSquared(x: ringPoint2.x,
                                          y: ringPoint2.y) < pointTooCloseOuterSquared {
                return true
            }
            index1 = index2
            index2 += 1
        }
        return false
    }
    
    public func resolveOneDuplicatePointOuter() {
        
        let pointTooCloseOuter = PolyMeshConstants.pointTooCloseOuter
        let pointTooCloseOuterSquared = pointTooCloseOuter * pointTooCloseOuter
        
        var index1 = ringPointCount - 1
        var index2 = 0
        var removeIndex = -1
        while index2 < ringPointCount {
            let ringPoint1 = ringPoints[index1]
            let ringPoint2 = ringPoints[index2]
            if ringPoint1.distanceSquared(x: ringPoint2.x,
                                          y: ringPoint2.y) < pointTooCloseOuterSquared {
                removeIndex = index2
                break
            }
            index1 = index2
            index2 += 1
        }
        
        removeRingPoint(removeIndex)
    }
}
