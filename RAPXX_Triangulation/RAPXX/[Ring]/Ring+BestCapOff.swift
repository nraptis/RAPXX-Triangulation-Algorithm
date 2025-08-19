//
//  Ring+BestCapOff.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/15/24.
//

import Foundation

extension Ring {
    
    // Note: There may be more than 1 tied for "best"
    // @Precondition: The cap offs are already computed.
    func getBestCapOff() -> RingCapOff? {
        if ringCapOffCount > 0 {
            var bestRingCapOff = ringCapOffs[0]
            var index = 1
            while index < ringCapOffCount {
                let ringCapOff = ringCapOffs[index]
                if ringCapOff.capOffQuality > bestRingCapOff.capOffQuality {
                    bestRingCapOff = ringCapOff
                }
                index += 1
            }
            return bestRingCapOff
        } else {
            return nil
        }
    }
}
