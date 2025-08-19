//
//  PolyMeshConstants.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/16/23.
//

import Foundation

public struct PolyMeshConstants {
    
    static let SCALE = Float(1.25)
    //static let SCALE = Float(2.0)
    
    static let POSH_SCALE = Float(1.25)
    
    public static let splineThresholdDistance = Float(14.0) * SCALE
    
    public static let borderPreferredStepSize = Float(8.0)
    public static let borderSkipInterpolationDistance = Float(6.0)
    public static let borderLowFiSampleDistance = Float(24.0)
    public static let borderMedFiSampleDistance = Float(64.0)
    
    static let ringInsetAmountThreatNone = Float(14.0) * SCALE * POSH_SCALE
    
    static let ringInsetAmountThreatLow = Float(12.0) * SCALE * POSH_SCALE
    static let ringInsetAmountThreatMedium = Float(10.0) * SCALE * POSH_SCALE
    static let ringInsetAmountThreatHigh = Float(8.0) * SCALE * POSH_SCALE
    
    static let earClipThresholdRegular = Math.pi_2
    static let earClipThresholdCapOff = Math.pi3_4
    
    static let sweepLinePointTooClose = Float(6.0) * SCALE * POSH_SCALE
    
    static let sweepLinePointTooCloseSquared = sweepLinePointTooClose * sweepLinePointTooClose
    static let sweepLinePointTooClose2 = (sweepLinePointTooClose + sweepLinePointTooClose)
    
    static let sweepLineDivison = Float(12.0) * SCALE
    
    static let sweepCollisionOverlap = Float(1.0) * SCALE
    
    static let capOffThreshold = Float(32.0) * SCALE
    static let capOffThresholdSquared = capOffThreshold * capOffThreshold
    
    static let meldMaxSteps = 8
    
    static let illegalTriangleAngleThreshold = Math.pi_18 // 10 degrees
    static let illegalTriangleAngleThresholdOpposite = Math.pi2 - illegalTriangleAngleThreshold // 350 degrees
    //static let terribleTriangleAngleThreshold = Math.pi_12 // 15 degrees
    
    static let possibleMeldStepDistance = Float(2.0) * SCALE * POSH_SCALE
    static let capOffNotchStepDistance = Float(2.0) * SCALE * POSH_SCALE
    static let probeButtressDefaultDistance = Float(8.0) * SCALE * POSH_SCALE
    
    static let probeMeldNeighborDistance = Float(6.0) * SCALE * POSH_SCALE
    static let probeMeldNeighborDistanceSquared = probeMeldNeighborDistance * probeMeldNeighborDistance
    
    static let probeMeldClusterDistance = Float(8.0) * SCALE * POSH_SCALE
    static let probeMeldClusterDistanceSquared = probeMeldClusterDistance * probeMeldClusterDistance
    
    static let probeMeldClusterMaximumDistance = Float(14.0) * SCALE * POSH_SCALE
    static let probeMeldClusterMaximumDistanceSquared = probeMeldClusterMaximumDistance * probeMeldClusterMaximumDistance
    
    static let probeButtressMergeDistance = Float(8.0) * SCALE * POSH_SCALE
    static let probeButtressMergeDistanceSquared = probeButtressMergeDistance * probeButtressMergeDistance
    
    static let pointTooCloseOuter = Float(4.0) * SCALE * POSH_SCALE
    static let pointTooCloseOuterSquared = pointTooCloseOuter * pointTooCloseOuter
    
    static let pointTooFar = Float(18.0) * SCALE * POSH_SCALE
    static let pointTooFarSquared = pointTooFar * pointTooFar
    
    // Observation: 300 is a little bit too big, there is no right exact number here.
    static let smallTriangleAreaThreshold = Float(250.0) * SCALE * POSH_SCALE
    
    static let probePointTooCloseToLineSegment = Float(4.0) * SCALE * POSH_SCALE
    static let probePointTooCloseToLineSegmentSquared = probePointTooCloseToLineSegment * probePointTooCloseToLineSegment
    
    static let capOffPointTooCloseToLineSegment = Float(6.0) * SCALE * POSH_SCALE
    static let capOffPointTooCloseToLineSegmentSquared = capOffPointTooCloseToLineSegment * capOffPointTooCloseToLineSegment
    
    static let splitPointNeighborGraduationSpan = Float(4.0) * SCALE * POSH_SCALE
    
    static let splitPointNeighborTooCloseToLineSegment = Float(5.0) * SCALE * POSH_SCALE
    
    static let splitPointDistantTooCloseToLineSegment = Float(11.0) * SCALE * POSH_SCALE
    static let splitPointDistantTooCloseToLineSegmentSquared = splitPointDistantTooCloseToLineSegment * splitPointDistantTooCloseToLineSegment
    
    static let meldGeometryTooClose = Float(2.0) * SCALE * POSH_SCALE
    static let meldGeometryTooCloseSquared = meldGeometryTooClose * meldGeometryTooClose
    
    static let capOffGeometryTooClose = Float(2.0) * SCALE * POSH_SCALE
    static let capOffGeometryTooCloseSquared = capOffGeometryTooClose * capOffGeometryTooClose
    
    static let splitLineIntoTwoPointsDistance = Float(12.0) * SCALE * POSH_SCALE
    static let splitLineIntoTwoPointsDistanceSquared = splitLineIntoTwoPointsDistance * splitLineIntoTwoPointsDistance
    
    static let splitLineIntoThreePointsDistance = splitLineIntoTwoPointsDistance + splitLineIntoTwoPointsDistance
    static let splitLineIntoThreePointsDistanceSquared = splitLineIntoThreePointsDistance * splitLineIntoThreePointsDistance
    
    static let ringContentionDistance = Float(36.0) * SCALE * POSH_SCALE
    static let ringContentionDistanceSquared = ringContentionDistance * ringContentionDistance
    
    static let ringSplitDistance = Float(28.0) * SCALE * POSH_SCALE
    static let ringSplitDistanceSquared = ringSplitDistance * ringSplitDistance
    
    // There will be only ONE relax magnitude...
    static let relaxMagnitudeNormal = Float(1.0) * SCALE * POSH_SCALE
    static let relaxMagnitudeIllegal = Float(2.0) * SCALE * POSH_SCALE
    
    static let relaxProbePointTooClose = Float(8.0) * SCALE * POSH_SCALE
    static let relaxProbePointTooCloseSquared = relaxProbePointTooClose * relaxProbePointTooClose
    
    static let meldNotchX: [Float] = [0.0, 0.0, 0.0, possibleMeldStepDistance, -possibleMeldStepDistance,
                                      -possibleMeldStepDistance, possibleMeldStepDistance, -possibleMeldStepDistance, possibleMeldStepDistance,
                                      0.0, 0.0, -possibleMeldStepDistance - possibleMeldStepDistance, possibleMeldStepDistance + possibleMeldStepDistance,
                                      possibleMeldStepDistance, -possibleMeldStepDistance,
                                      possibleMeldStepDistance, -possibleMeldStepDistance,
                                      -possibleMeldStepDistance - possibleMeldStepDistance, -possibleMeldStepDistance - possibleMeldStepDistance,
                                      possibleMeldStepDistance + possibleMeldStepDistance, possibleMeldStepDistance + possibleMeldStepDistance]
        
    static let meldNotchY: [Float] = [0.0, -possibleMeldStepDistance, possibleMeldStepDistance, 0.0, 0.0,
                                      -possibleMeldStepDistance, -possibleMeldStepDistance, possibleMeldStepDistance, possibleMeldStepDistance,
                                      -possibleMeldStepDistance - possibleMeldStepDistance, possibleMeldStepDistance + possibleMeldStepDistance, 0.0, 0.0,
                                      -possibleMeldStepDistance - possibleMeldStepDistance, -possibleMeldStepDistance - possibleMeldStepDistance,
                                      possibleMeldStepDistance + possibleMeldStepDistance, possibleMeldStepDistance + possibleMeldStepDistance,
                                      possibleMeldStepDistance, -possibleMeldStepDistance,
                                      possibleMeldStepDistance, -possibleMeldStepDistance]
    
    // DO NOT CHANGE THESE: This is done.
    // DO NOT USE "ORDER" FOR THESE... TRY ALL POINTS ONCE, PICK BEST. THAT IS IT. THERE IS NO MORE HERE.
    // WHY ARE YOU READING THIS AGAIN, THIS IS DONE.
    static let capOffNotchX: [Float] = [0.0, 0.0, 0.0, capOffNotchStepDistance, -capOffNotchStepDistance,
                                        -capOffNotchStepDistance, capOffNotchStepDistance, -capOffNotchStepDistance, capOffNotchStepDistance,
                                        0.0, 0.0, -capOffNotchStepDistance - capOffNotchStepDistance, capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance, -capOffNotchStepDistance,
                                        capOffNotchStepDistance, -capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance, -capOffNotchStepDistance - capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance, capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance, capOffNotchStepDistance + capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance, -capOffNotchStepDistance - capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance - capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance - capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance - capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance + capOffNotchStepDistance,
                                        0.0, -capOffNotchStepDistance, capOffNotchStepDistance,
                                        0.0, -capOffNotchStepDistance, capOffNotchStepDistance]
    
    static let capOffNotchY: [Float] = [0.0, -capOffNotchStepDistance, capOffNotchStepDistance, 0.0, 0.0,
                                        -capOffNotchStepDistance, -capOffNotchStepDistance, capOffNotchStepDistance, capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance, capOffNotchStepDistance + capOffNotchStepDistance, 0.0, 0.0,
                                        -capOffNotchStepDistance - capOffNotchStepDistance, -capOffNotchStepDistance - capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance, capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance, -capOffNotchStepDistance,
                                        capOffNotchStepDistance, -capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance, -capOffNotchStepDistance - capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance, -capOffNotchStepDistance - capOffNotchStepDistance,
                                        0.0, -capOffNotchStepDistance, capOffNotchStepDistance,
                                        0.0, -capOffNotchStepDistance, capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance - capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance - capOffNotchStepDistance,
                                        -capOffNotchStepDistance - capOffNotchStepDistance - capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance + capOffNotchStepDistance,
                                        capOffNotchStepDistance + capOffNotchStepDistance + capOffNotchStepDistance]
    
}
