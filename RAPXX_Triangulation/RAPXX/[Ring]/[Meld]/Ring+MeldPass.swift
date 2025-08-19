//
//  Ring+MeldPass.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/5/24.
//

import Foundation

extension Ring {
    
    // We should ALWAYS flush. The whole advantage of the fast
    // geometry update is that we can quickly re-calculate
    // the contentions and things... Better to be accurate than redundant
    
    //@Precondition: calculateProbePointMeldContentionCounts returned true
    //func meldPass(ignoreButtressCenters: Bool) -> Bool {
    func meldPass() -> Bool {
        
        var result = false
        
        var continueToMeldOuterLoop = true
        while continueToMeldOuterLoop {
            continueToMeldOuterLoop = false
            
            // Assuming right here: calculateProbePointMeldContentionCounts() did return true
            let maxMeldContentionCount = calculateMaxMeldContentionCount()
            guard maxMeldContentionCount > 0 else {
                break
            }
            
            var meldContentionCount = maxMeldContentionCount
            while meldContentionCount > 0 && continueToMeldOuterLoop == false {
                for ringProbePointIndex in 0..<ringProbePointCount where continueToMeldOuterLoop == false {
                    let ringProbePoint = ringProbePoints[ringProbePointIndex]
                    if ringProbePoint.meldContentionCount == meldContentionCount {
                        purgeRingMelds()
                        if attemptToGeneratePossibleMeldsAndMelds(ringProbePointIndex: ringProbePointIndex,
                                                                  numberOfPointsToMeld: meldContentionCount + 1) {
                            if let bestRingMeld = getBestRingMeld() {
                                if meldProbePoints(ringMeld: bestRingMeld) {
                                    
                                    if calculateProbePointMeldContentionCounts() {
                                        result = true
                                        continueToMeldOuterLoop = true
                                    } else {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
                meldContentionCount -= 1
            }
        }
        
        return result
    }
}
