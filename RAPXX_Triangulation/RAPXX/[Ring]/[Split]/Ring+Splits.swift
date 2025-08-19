//
//  Ring+SplitCalculate.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/11/24.
//

import Foundation

extension Ring {
    
    func calculateRingSplitsAndExecuteInstantSplitIfExists() -> Bool {
        
        guard let triangleData = triangleData else {
            return false
        }
        
        for possibleSplitPairIndex in 0..<possibleSplitPairCount {
            let possibleSplitPair = possibleSplitPairs[possibleSplitPairIndex]
            
            if attemptMeasureSplitQuality(index1: possibleSplitPair.ringPoint1.ringIndex,
                                               index2: possibleSplitPair.ringPoint2.ringIndex,
                                               quality: &tempRingSplitQuality) {
                
                if tempRingSplitQuality.isInstantSplit {
                    let splitPointCount = getSplitPointCount(index1: possibleSplitPair.ringPoint1.ringIndex,
                                                                  index2: possibleSplitPair.ringPoint2.ringIndex)
                    
                    let splitRing1 = PolyMeshPartsFactory.shared.withdrawRing(triangleData: triangleData)
                    let splitRing2 = PolyMeshPartsFactory.shared.withdrawRing(triangleData: triangleData)
                    
                    if split(splitRing1: splitRing1,
                             splitRing2: splitRing2,
                             index1: possibleSplitPair.ringPoint1.ringIndex,
                             index2: possibleSplitPair.ringPoint2.ringIndex, count: splitPointCount) {
                        
                        PolyMeshPartsFactory.shared.depositRingContent(self)
                        
                        addSubring(splitRing1)
                        addSubring(splitRing2)
                        return true
                    } else {
                        PolyMeshPartsFactory.shared.depositRing(splitRing1)
                        PolyMeshPartsFactory.shared.depositRing(splitRing2)
                    }
                } else {
                    let ringSplit = PolyMeshPartsFactory.shared.withdrawRingSplit()
                    ringSplit.index1 = possibleSplitPair.ringPoint1.ringIndex
                    ringSplit.index2 = possibleSplitPair.ringPoint2.ringIndex
                    ringSplit.splitQuality = tempRingSplitQuality
                    addRingSplit(ringSplit)
                }
            }
        }
        return false
    }
    
    func executeBestSplitPossible() -> Bool {
        
        guard let triangleData = triangleData else {
            return false
        }
        
        var numberTried = 0
        
        while ringSplits.count > 0 {
            if let bestRingSplit = getBestRingSplit() {
                numberTried += 1
             
                let splitRing1 = PolyMeshPartsFactory.shared.withdrawRing(triangleData: triangleData)
                let splitRing2 = PolyMeshPartsFactory.shared.withdrawRing(triangleData: triangleData)
                
                let splitPointCount = getSplitPointCount(index1: bestRingSplit.index1,
                                                         index2: bestRingSplit.index2)
                
                if split(splitRing1: splitRing1,
                         splitRing2: splitRing2,
                         index1: bestRingSplit.index1,
                         index2: bestRingSplit.index2,
                         count: splitPointCount) {
                    
                    PolyMeshPartsFactory.shared.depositRingContent(self)
                    
                    addSubring(splitRing1)
                    addSubring(splitRing2)
                    
                    return true
                } else {
                    
                    PolyMeshPartsFactory.shared.depositRing(splitRing1)
                    PolyMeshPartsFactory.shared.depositRing(splitRing2)
                    
                    removeRingSplit(bestRingSplit)
                }
                
            } else {
                return false
            }
        }
        
        return false
    }
}
