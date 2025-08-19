//
//  Ring+RelaxShared.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/21/24.
//

import Foundation

extension Ring {
    
    func relaxProbePoints() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            if ringProbePoint.isRelaxable {
                if ringProbePoint.isIllegal {
                    ringProbePoint.x = ringProbePoint.x + ringProbePoint.relaxDirectionX * PolyMeshConstants.relaxMagnitudeIllegal
                    ringProbePoint.y = ringProbePoint.y + ringProbePoint.relaxDirectionY * PolyMeshConstants.relaxMagnitudeIllegal
                } else {
                    ringProbePoint.x = ringProbePoint.x + ringProbePoint.relaxDirectionX * PolyMeshConstants.relaxMagnitudeNormal
                    ringProbePoint.y = ringProbePoint.y + ringProbePoint.relaxDirectionY * PolyMeshConstants.relaxMagnitudeNormal
                }
            }
        }
        calculateProbeSegmentsUsingProbePoints()
        buildRingProbeSegmentBucket()
    }
}
