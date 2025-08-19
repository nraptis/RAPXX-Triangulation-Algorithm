//
//  Ring+ThreatDetection.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/26/23.
//

import Foundation

extension Ring {
    
    //@Precondition: calculateRingPointPinchGates
    //@Precondition: buildLineSegmentBucket
    func calculateLineSegmentThreats(needsContentions: Bool) {
        
        if needsContentions {
            calculateRingLineSegmentContentions()
        }
        
        /*
        if POLY_MESH_MONO_THREATS_ENABLED {
            if depth == POLY_MESH_MONO_THREATS_LEVEL {
                
            } else {
                return
            }
        } else {
            if POLY_MESH_OMNI_THREATS_ENABLED && (depth <= POLY_MESH_OMNI_THREATS_LEVEL) {
                
            } else {
                return
            }
        }
        */
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            var threatLevel = RingPoint.ThreatLevel.none
            for lineSegmentContentionIndex in 0..<ringPoint.lineSegmentContentionCount {
                let lineSegmentContention = ringPoint.lineSegmentContentions[lineSegmentContentionIndex]
                if lineSegmentContention.distanceSquared <= PolyMeshConstants.ringContentionDistanceSquared {
                    threatLevel = .high
                }
            }
            ringPoint.threatLevel = threatLevel
        }
        
        expandPointThreat()
        
    }
    
    private func expandPointThreat() {
        
        // If HIGH, neighbors should be at least MEDIUM
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.threatLevel == .high {
                ringPoint.neighborLeft.threatLevel = max(ringPoint.neighborLeft.threatLevel, .medium)
                ringPoint.neighborLeft.neighborLeft.threatLevel = max(ringPoint.neighborLeft.neighborLeft.threatLevel, .medium)
                ringPoint.neighborRight.threatLevel = max(ringPoint.neighborRight.threatLevel, .medium)
                ringPoint.neighborRight.neighborRight.threatLevel = max(ringPoint.neighborRight.neighborRight.threatLevel, .medium)
            }
        }
        
        // If MEDIUM, make HIGH
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.threatLevel == .medium {
                ringPoint.threatLevel = .high
            }
        }
        
        // If HIGH, neighbors should be at least MEDIUM
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.threatLevel == .high {
                ringPoint.neighborLeft.threatLevel = max(ringPoint.neighborLeft.threatLevel, .medium)
                ringPoint.neighborLeft.neighborLeft.threatLevel = max(ringPoint.neighborLeft.neighborLeft.threatLevel, .medium)
                
                ringPoint.neighborRight.threatLevel = max(ringPoint.neighborRight.threatLevel, .medium)
                ringPoint.neighborRight.neighborRight.threatLevel = max(ringPoint.neighborRight.neighborRight.threatLevel, .medium)
            }
        }
        
        
        // If MEDIUM, neighbors should be at least LOW
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.threatLevel == .medium {
                ringPoint.neighborLeft.threatLevel = max(ringPoint.neighborLeft.threatLevel, .low)
                ringPoint.neighborLeft.neighborLeft.threatLevel = max(ringPoint.neighborLeft.neighborLeft.threatLevel, .low)
                
                ringPoint.neighborRight.threatLevel = max(ringPoint.neighborRight.threatLevel, .low)
                ringPoint.neighborRight.neighborRight.threatLevel = max(ringPoint.neighborRight.neighborRight.threatLevel, .low)
            }
        }
        
        // If LOW, make MEDIUM
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.threatLevel == .low {
                ringPoint.threatLevel = .medium
            }
        }
        
        // If MEDIUM, neighbors should be at least LOW
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            if ringPoint.threatLevel == .medium {
                ringPoint.neighborLeft.threatLevel = max(ringPoint.neighborLeft.threatLevel, .low)
                ringPoint.neighborLeft.neighborLeft.threatLevel = max(ringPoint.neighborLeft.neighborLeft.threatLevel, .low)
                
                ringPoint.neighborRight.threatLevel = max(ringPoint.neighborRight.threatLevel, .low)
                ringPoint.neighborRight.neighborRight.threatLevel = max(ringPoint.neighborRight.neighborRight.threatLevel, .low)
                
            }
        }
        
    }
}
