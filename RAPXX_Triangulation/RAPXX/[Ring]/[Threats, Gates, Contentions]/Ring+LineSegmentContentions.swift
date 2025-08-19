//
//  Ring+ContendingLineSegments.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/29/23.
//

import Foundation

extension Ring {
    
    //
    // Note: This seems to work good, I don't see any reason to change, improve, or re-do this.
    //
    
    //@Precondition: ringPointInsidePolygonBucket is populated
    //@Precondition: ringLineSegmentBucket is populated
    //@Precondition: calculateRingPointPinchGates is called
    func calculateRingLineSegmentContentions() {
        
        for ringPointIndex in 0..<ringPointCount {
            ringPoints[ringPointIndex].purgeRingLineSegmentContentions()
        }
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            
            let pinchGateRightIndex = ringPoint.pinchGateRightIndex
            let pinchGateLeftIndex = ringPoint.pinchGateLeftIndex
            
            if pinchGateRightIndex != -1 && pinchGateLeftIndex != -1 {
                ringLineSegmentBucket.query(minX: ringPoint.x - PolyMeshConstants.ringContentionDistance,
                                            maxX: ringPoint.x + PolyMeshConstants.ringContentionDistance,
                                            minY: ringPoint.y - PolyMeshConstants.ringContentionDistance,
                                            maxY: ringPoint.y + PolyMeshConstants.ringContentionDistance)
                
                for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                    let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                    let ringLineSegmentIndex = Int(bucketLineSegment.ringIndex)
                    if Math.polygonTourCrosses(index: ringLineSegmentIndex, startIndex: pinchGateRightIndex, endIndex: pinchGateLeftIndex) {
                        let distanceSquared = bucketLineSegment.distanceSquaredToClosestPoint(ringPoint.x, ringPoint.y)
                        if distanceSquared <= PolyMeshConstants.ringContentionDistanceSquared  {
                            if isSafeConnection(ringPoint: ringPoint, ringLineSegment: bucketLineSegment) {
                                let lineSegmentContention = PolyMeshPartsFactory.shared.withdrawRingLineSegmentContention()
                                lineSegmentContention.ringLineSegment = bucketLineSegment
                                lineSegmentContention.distanceSquared = distanceSquared
                                ringPoint.addRingLineSegmentContention(lineSegmentContention)
                            }
                        }
                    }
                }
            }
        }
    }
}
