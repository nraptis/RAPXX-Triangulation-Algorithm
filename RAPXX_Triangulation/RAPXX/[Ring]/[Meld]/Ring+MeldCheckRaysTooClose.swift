//
//  Ring+MeldRay1Ray2.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/28/24.
//

import Foundation

extension Ring {
    
    func calculateMeldsFromPossibleMeldsRayTooClose1(possibleMeld: PossibleMeld,
                                                     meldProbePointBeforeFirst: RingProbePoint,
                                                     minDistanceToLineSegmentSquared: inout Float,
                                                     maxDistanceToLineSegmentSquared: inout Float) -> Bool {
        
        // Basics 101, #1, Distance from first ray to probe segments...
        preComputedLineSegment1.x1 = meldProbePointBeforeFirst.x
        preComputedLineSegment1.y1 = meldProbePointBeforeFirst.y
        preComputedLineSegment1.x2 = possibleMeld.x
        preComputedLineSegment1.y2 = possibleMeld.y
        preComputedLineSegment1.precompute()
        
        minDistanceToLineSegmentSquared = min(preComputedLineSegment1.lengthSquared, minDistanceToLineSegmentSquared)
        maxDistanceToLineSegmentSquared = max(preComputedLineSegment1.lengthSquared, maxDistanceToLineSegmentSquared)
        
        for meldLocalDisjointProbeSegmentIndex in 0..<meldLocalDisjointProbeSegmentCount {
            let meldLocalDisjointProbeSegment = meldLocalDisjointProbeSegments[meldLocalDisjointProbeSegmentIndex]
            
            let distanceSquared = preComputedLineSegment1.distanceSquaredToLineSegment(meldLocalDisjointProbeSegment)
            if distanceSquared < PolyMeshConstants.meldGeometryTooCloseSquared {
                return false
            }
        }
        
        // Basics 101, #2, Distance from first ray to line segments...
        for meldLocalLineSegmentIndex in 0..<meldLocalLineSegmentCount {
            let meldLocalLineSegment = meldLocalLineSegments[meldLocalLineSegmentIndex]
            let distanceSquared = preComputedLineSegment1.distanceSquaredToLineSegment(meldLocalLineSegment)
            if distanceSquared < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                return false
            }
            if distanceSquared < minDistanceToLineSegmentSquared {
                minDistanceToLineSegmentSquared = distanceSquared
            }
            if distanceSquared > maxDistanceToLineSegmentSquared {
                minDistanceToLineSegmentSquared = distanceSquared
            }
        }
        
        return true
    }
    
    func calculateMeldsFromPossibleMeldsRayTooClose1_Opposite(meldProbePointFirst: RingProbePoint,
                                                              meldProbePointBeforeFirst: RingProbePoint) -> Bool {
        
        // Basics 101, #1, Distance from first ray to probe segments...
        preComputedLineSegment3.x1 = meldProbePointFirst.x
        preComputedLineSegment3.y1 = meldProbePointFirst.y
        preComputedLineSegment3.x2 = meldProbePointBeforeFirst.x
        preComputedLineSegment3.y2 = meldProbePointBeforeFirst.y
        preComputedLineSegment3.precompute()
        
        for meldLocalDisjointProbeSegmentIndex in 0..<meldLocalDisjointProbeSegmentCount {
            let meldLocalDisjointProbeSegment = meldLocalDisjointProbeSegments[meldLocalDisjointProbeSegmentIndex]
            
            let distanceSquared = preComputedLineSegment3.distanceSquaredToLineSegment(meldLocalDisjointProbeSegment)
            if distanceSquared < PolyMeshConstants.meldGeometryTooCloseSquared {
                return false
            }
        }
        
        // Basics 101, #2, Distance from first ray to line segments...
        for meldLocalLineSegmentIndex in 0..<meldLocalLineSegmentCount {
            let meldLocalLineSegment = meldLocalLineSegments[meldLocalLineSegmentIndex]
            let distanceSquared = preComputedLineSegment3.distanceSquaredToLineSegment(meldLocalLineSegment)
            if distanceSquared < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                return false
            }
        }
        return true
    }
    
    func calculateMeldsFromPossibleMeldsRayTooClose2(possibleMeld: PossibleMeld,
                                                     meldProbePointAfterLast: RingProbePoint,
                                                     minDistanceToLineSegmentSquared: inout Float,
                                                     maxDistanceToLineSegmentSquared: inout Float) -> Bool {
        
        // Basics 101, #2, Distance from second ray to probe segments...
        preComputedLineSegment2.x1 = possibleMeld.x
        preComputedLineSegment2.y1 = possibleMeld.y
        preComputedLineSegment2.x2 = meldProbePointAfterLast.x
        preComputedLineSegment2.y2 = meldProbePointAfterLast.y
        preComputedLineSegment2.precompute()
        
        minDistanceToLineSegmentSquared = min(preComputedLineSegment2.lengthSquared, minDistanceToLineSegmentSquared)
        maxDistanceToLineSegmentSquared = max(preComputedLineSegment2.lengthSquared, maxDistanceToLineSegmentSquared)
        
        
        for meldLocalDisjointProbeSegmentIndex in 0..<meldLocalDisjointProbeSegmentCount {
            let meldLocalDisjointProbeSegment = meldLocalDisjointProbeSegments[meldLocalDisjointProbeSegmentIndex]
            let distanceSquared = preComputedLineSegment2.distanceSquaredToLineSegment(meldLocalDisjointProbeSegment)
            if distanceSquared < PolyMeshConstants.meldGeometryTooCloseSquared {
                return false
            }
        }
                
        // Basics 101, #2, Distance from second ray to line segments...
        for meldLocalLineSegmentIndex in 0..<meldLocalLineSegmentCount {
            let meldLocalLineSegment = meldLocalLineSegments[meldLocalLineSegmentIndex]
            let distanceSquared = preComputedLineSegment2.distanceSquaredToLineSegment(meldLocalLineSegment)
            if distanceSquared < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                return false
            }
            if distanceSquared < minDistanceToLineSegmentSquared {
                minDistanceToLineSegmentSquared = distanceSquared
            }
            if distanceSquared > maxDistanceToLineSegmentSquared {
                minDistanceToLineSegmentSquared = distanceSquared
            }
        }
        return true
    }
    
    func calculateMeldsFromPossibleMeldsRayTooClose2_Opposite(meldProbePointLast: RingProbePoint,
                                                              meldProbePointAfterLast: RingProbePoint) -> Bool {
        
        // Basics 101, #2, Distance from second ray to probe segments...
        preComputedLineSegment4.x1 = meldProbePointLast.x
        preComputedLineSegment4.y1 = meldProbePointLast.y
        preComputedLineSegment4.x2 = meldProbePointAfterLast.x
        preComputedLineSegment4.y2 = meldProbePointAfterLast.y
        preComputedLineSegment4.precompute()
        
        for meldLocalDisjointProbeSegmentIndex in 0..<meldLocalDisjointProbeSegmentCount {
            let meldLocalDisjointProbeSegment = meldLocalDisjointProbeSegments[meldLocalDisjointProbeSegmentIndex]
            let distanceSquared = preComputedLineSegment4.distanceSquaredToLineSegment(meldLocalDisjointProbeSegment)
            if distanceSquared < PolyMeshConstants.meldGeometryTooCloseSquared {
                return false
            }
        }
                
        // Basics 101, #2, Distance from second ray to line segments...
        for meldLocalLineSegmentIndex in 0..<meldLocalLineSegmentCount {
            let meldLocalLineSegment = meldLocalLineSegments[meldLocalLineSegmentIndex]
            let distanceSquared = preComputedLineSegment4.distanceSquaredToLineSegment(meldLocalLineSegment)
            if distanceSquared < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                return false
            }
        }
        return true
    }
    
}
