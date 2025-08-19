//
//  Ring+MeldCheckSpokes.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/29/24.
//

import Foundation

extension Ring {
    
    func calculateMeldsFromPossibleMeldsSpokeAngles(possibleMeld: PossibleMeld,
                                                    minSpokeAngle: inout Float) -> Bool {
        
        minSpokeAngle = Math.pi2
        if meldProbeSpokeCount <= 1 {
            return true
        }
        
        var index1 = 0
        var index2 = 1
        while index2 < meldProbeSpokeCount {
            
            let meldProbeSpoke1 = meldProbeSpokes[index1]
            let meldProbeSpoke2 = meldProbeSpokes[index2]

            let x1 = possibleMeld.x
            let y1 = possibleMeld.y
            
            let x2 = meldProbeSpoke2.x2
            let y2 = meldProbeSpoke2.y2
            
            let x3 = meldProbeSpoke1.x2
            let y3 = meldProbeSpoke1.y2
            
            let spokeAngle = Math.triangleMinimumAngle(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3)
            if spokeAngle < minSpokeAngle {
                minSpokeAngle = spokeAngle
            }
            
            index1 = index2
            index2 += 1
        }
        
        if minSpokeAngle < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        } else {
            return true
        }
    }
}
