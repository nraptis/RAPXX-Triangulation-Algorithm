//
//  Ring+BestSplit.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/11/24.
//

import Foundation

extension Ring {
    func getBestRingSplit() -> RingSplit? {
        if ringSplitCount > 0 {
            var bestRingSplit = ringSplits[0]
            var index = 1
            while index < ringSplitCount {
                let ringSplit = ringSplits[index]
                if ringSplit.splitQuality > bestRingSplit.splitQuality {
                    bestRingSplit = ringSplit
                }
                index += 1
            }
            return bestRingSplit
        } else {
            return nil
        }
    }
}
