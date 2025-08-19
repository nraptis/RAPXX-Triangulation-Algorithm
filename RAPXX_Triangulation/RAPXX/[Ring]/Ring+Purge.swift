//
//  Ring+Purge.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/7/24.
//

import Foundation

extension Ring {
    
    func purgeRingPoints() {
        for ringPointIndex in 0..<ringPointCount {
            PolyMeshPartsFactory.shared.depositRingPoint(ringPoints[ringPointIndex])
        }
        ringPointCount = 0
    }
    
    func purgeRingLineSegments() {
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            PolyMeshPartsFactory.shared.depositRingLineSegment(ringLineSegments[ringLineSegmentIndex])
        }
        ringLineSegmentCount = 0
    }
    
    func purgeProbePoints() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            PolyMeshPartsFactory.shared.depositRingProbePoint(ringProbePoints[ringProbePointIndex])
        }
        ringProbePointCount = 0
    }
    
    func purgeProbeSegments() {
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            PolyMeshPartsFactory.shared.depositRingProbeSegment(ringProbeSegments[ringProbeSegmentIndex])
        }
        ringProbeSegmentCount = 0
    }
    
    func purgePossibleSplitPairs() {
        for possibleSplitPairIndex in 0..<possibleSplitPairCount {
            let possibleSplitPair = possibleSplitPairs[possibleSplitPairIndex]
            PolyMeshPartsFactory.shared.depositPossibleSplitPair(possibleSplitPair)
        }
        possibleSplitPairCount = 0
    }
    
    func purgeRingSplits() {
        for ringSplitIndex in 0..<ringSplitCount {
            let ringSplit = ringSplits[ringSplitIndex]
            PolyMeshPartsFactory.shared.depositRingSplit(ringSplit)
        }
        ringSplitCount = 0
    }
    
    func purgeRingSweepLines() {
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            PolyMeshPartsFactory.shared.depositRingSweepLine(ringSweepLines[ringSweepLineIndex])
        }
        ringSweepLineCount = 0
    }
    
    /*
    func purgeSweepCollisionBucket() {
        for sweepCollisionBucketIndex in sweepCollisionBucket.indices {
            for sweepLineLineCollisionIndex in sweepCollisionBucket[sweepCollisionBucketIndex].indices {
                let sweepLineLineCollision = sweepCollisionBucket[sweepCollisionBucketIndex][sweepLineLineCollisionIndex]
                PolyMeshPartsFactory.shared.depositRingSweepCollision(sweepLineLineCollision)
            }
            sweepCollisionBucket[sweepCollisionBucketIndex].removeAll(keepingCapacity: true)
        }
    }
    */
    
    func purgePossibleMelds() {
        for possibleMeldIndex in 0..<possibleMeldCount {
            let possibleMeld = possibleMelds[possibleMeldIndex]
            PolyMeshPartsFactory.shared.depositPossibleMeld(possibleMeld)
        }
        possibleMeldCount = 0
    }
    
    func purgeRingMelds() {
        for ringMeldIndex in 0..<ringMeldCount {
            let ringMeld = ringMelds[ringMeldIndex]
            PolyMeshPartsFactory.shared.depositRingMeld(ringMeld)
        }
        ringMeldCount = 0
    }
    
    func purgeRingCapOffs() {
        for ringCapOffIndex in 0..<ringCapOffCount {
            let ringCapOff = ringCapOffs[ringCapOffIndex]
            PolyMeshPartsFactory.shared.depositRingCapOff(ringCapOff)
        }
        ringCapOffCount = 0
    }
    
    func purgeMeldProbeSpokes() {
        for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
            let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
            PolyMeshPartsFactory.shared.depositRingProbeSpoke(meldProbeSpoke)
        }
        meldProbeSpokeCount = 0
    }
    
    func purgeRingSweepPoints() {
        for ringSweepPointIndex in 0..<ringSweepPointCount {
            PolyMeshPartsFactory.shared.depositRingSweepPoint(ringSweepPoints[ringSweepPointIndex])
        }
        ringSweepPointCount = 0
    }
    
    /*
    func purgeAllSavedProbePoints() {
        for ringProbePointIndex in 0..<savedRingProbePointCount {
            let ringProbePoint = savedRingProbePoints[ringProbePointIndex]
            PolyMeshPartsFactory.shared.depositRingProbePoint(ringProbePoint)
        }
        savedRingProbePointCount = 0
    }
    */
}
