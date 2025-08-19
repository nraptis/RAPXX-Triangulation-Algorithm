//
//  Ring+MeldCheckSpokeTooClose.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 1/30/24.
//

import Foundation

extension Ring {
 
    //@Precondition: Must call calculateMeldsFromPossibleMeldsFinishSpokesAndSpokeAngles for this possibleMeld first!
    func calculateMeldsFromPossibleSpokesTooClose() -> Bool {
        for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
            let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
            for meldLocalLineSegmentIndex in 0..<meldLocalLineSegmentCount {
                let meldLocalLineSegment = meldLocalLineSegments[meldLocalLineSegmentIndex]
                
                if meldLocalLineSegment.ringPointLeft === meldProbeSpoke.connection { continue }
                if meldLocalLineSegment.ringPointRight === meldProbeSpoke.connection { continue }
                
                let distanceSquared = meldProbeSpoke.distanceSquaredToLineSegment(meldLocalLineSegment)
                if distanceSquared < PolyMeshConstants.meldGeometryTooCloseSquared {
                    return false
                }
            }
        }
        return true
    }
    
    //@Precondition: Must call calculateMeldsFromPossibleMeldsFinishSpokesAndSpokeAngles for this possibleMeld first!
    func calculateMeldsFromPossibleMeldsOneSpokeIntersectsProbeSegment() -> Bool {
        
        //
        // This may seem like an incomplete test, however, all the "closeness" checks
        // will also be happening. So, this is really for the case when ALL THE POINTS
        // are too far inset across the other points. Quick check for quick rejection.
        //
        
        if meldProbeSpokeCount > 0 {
            let meldProbeSpoke = meldProbeSpokes[0]
            for meldLocalDisjointProbeSegmentIndex in 0..<meldLocalDisjointProbeSegmentCount {
                let meldLocalDisjointProbeSegment = meldLocalDisjointProbeSegments[meldLocalDisjointProbeSegmentIndex]
                if meldProbeSpoke.intersects(lineSegment: meldLocalDisjointProbeSegment) {
                    return false
                }
            }
        }
        
        return true
    }
    
}
