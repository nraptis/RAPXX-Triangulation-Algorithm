//
//  Ring+BestMeld.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 1/31/24.
//

import Foundation

extension Ring {
    
    // Note: There may be more than 1 tied for "best"
    // @Precondition: The meld points are already computed.
    func getBestRingMeld() -> RingMeld? {
        if ringMeldCount > 0 {
            var bestRingMeld = ringMelds[0]
            var index = 1
            while index < ringMeldCount {
                let ringMeld = ringMelds[index]
                if ringMeld.meldQuality > bestRingMeld.meldQuality {
                    bestRingMeld = ringMeld
                }
                index += 1
            }
            return bestRingMeld
        } else {
            return nil
        }
    }
}
