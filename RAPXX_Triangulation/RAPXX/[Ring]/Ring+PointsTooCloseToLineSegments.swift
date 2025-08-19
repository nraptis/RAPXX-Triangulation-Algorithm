//
//  Ring+BadLineSegments.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/22/23.
//

import Foundation

extension Ring {
    
    //@Precondition: polyPointBucket is populated
    //@Precondition: ringLineSegmentBucket is populated
    func containsPointsThatAreTooCloseToLineSegmentsOuterRing() -> Bool {
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            let minX = ringPoint.x - PolyMeshConstants.pointTooCloseOuter - Math.epsilon
            let maxX = ringPoint.x + PolyMeshConstants.pointTooCloseOuter + Math.epsilon
            let minY = ringPoint.y - PolyMeshConstants.pointTooCloseOuter - Math.epsilon
            let maxY = ringPoint.y + PolyMeshConstants.pointTooCloseOuter + Math.epsilon
            ringLineSegmentBucket.query(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                let distanceSquared = bucketLineSegment.distanceSquaredToClosestPoint(ringPoint.x, ringPoint.y)
                if distanceSquared < PolyMeshConstants.pointTooCloseOuterSquared {
                    if isSafeConnection(ringPoint: ringPoint,
                                        ringLineSegment: bucketLineSegment) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    //
    // From what I can tell, this is exactly the same as "outer ring" with a smaller value
    //
    
    /*
    //@Precondition: polyPointBucket is populated
    //@Precondition: ringLineSegmentBucket is populated
    func containsPointsThatAreTooCloseToLineSegmentsInnerRing() -> Bool {
        
        // Note: We don't really benefit from strictness here...
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            let minX = ringPoint.x - PolyMeshConstants.pointTooCloseInner - Math.epsilon
            let maxX = ringPoint.x + PolyMeshConstants.pointTooCloseInner + Math.epsilon
            let minY = ringPoint.y - PolyMeshConstants.pointTooCloseInner - Math.epsilon
            let maxY = ringPoint.y + PolyMeshConstants.pointTooCloseInner + Math.epsilon
            
            ringLineSegmentBucket.query(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                
                let distanceSquared = bucketLineSegment.distanceSquaredToClosestPoint(ringPoint.x, ringPoint.y)
                if distanceSquared < PolyMeshConstants.pointTooCloseInnerSquared {
                    if isSafeConnection(ringPoint: ringPoint, ringLineSegment: bucketLineSegment) {
                        return true
                    }
                }
            }
        }
        return false
    }
    */
}
