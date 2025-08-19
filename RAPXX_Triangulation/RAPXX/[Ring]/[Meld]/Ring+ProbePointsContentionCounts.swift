//
//  Ring+ProbeSegmentLeftAndRightContentions.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/1/24.
//

import Foundation

extension Ring {
    
    func calculateMaxMeldContentionCount() -> Int {
        var result = 0
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            if ringProbePoint.meldContentionCount > result {
                result = ringProbePoint.meldContentionCount
            }
        }
        return result
    }
    
    func calculateProbePointMeldContentionCounts() -> Bool {
        
        var result = false
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.meldContentionCount = 0
        }
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            
            if probePointContendsLeft(ringProbePoint: ringProbePoint) {
                ringProbePoint.neighborLeft.meldContentionCount = 1
                result = true
            }
            if probePointContendsLeftWedgeCases(ringProbePoint: ringProbePoint) {
                ringProbePoint.neighborLeft.meldContentionCount = 1
                result = true
            }
            if probePointContendsRightWedgeCases(ringProbePoint: ringProbePoint) {
                ringProbePoint.meldContentionCount = 1
                result = true
            }
        }
        if result {
            expandMeldContentionCounts()
            return true
        } else {
            return false
        }
    }
    
    private func expandMeldContentionCounts() {
        
        temp_1_ringProbePointCount = 0
        temp_2_ringProbePointCount = 0
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            if ringProbePoint.meldContentionCount > 0 {
                ringProbePoint.calculateFirstAndLastConnectionSpokes()
                addTemp_1_RingProbePoint(ringProbePoint)
            }
        }
        
        var steps = 2
        let ceiling = ringProbePointCount - 1
        while steps < ceiling {
            
            var didExpand = false
            for ringProbePointIndex in 0..<temp_1_ringProbePointCount {
                let ringProbePoint = temp_1_ringProbePoints[ringProbePointIndex]
                if probePointContendsRightSubsequent(ringProbePoint: ringProbePoint, steps: steps) {
                    ringProbePoint.meldContentionCount += 1
                    addTemp_2_RingProbePoint(ringProbePoint)
                    didExpand = true
                }
            }
            
            if didExpand {
                temp_1_ringProbePointCount = 0
                for ringProbePointIndex in 0..<temp_2_ringProbePointCount {
                    let ringProbePoint = temp_2_ringProbePoints[ringProbePointIndex]
                    addTemp_1_RingProbePoint(ringProbePoint)
                }
                temp_2_ringProbePointCount = 0
                steps += 1
            } else {
                break
            }
        }
    }
    
    private func probePointContendsLeftWedgeCases(ringProbePoint: RingProbePoint) -> Bool {
        let ringProbeSegmentRight = ringProbePoint.ringProbeSegmentRight!
        if !ringProbeSegmentRight.isIllegal {
            let neighborLeft = ringProbePoint.neighborLeft!
            if ringProbeSegmentRight.distanceSquaredToClosestPoint(neighborLeft.x, neighborLeft.y) < PolyMeshConstants.probeMeldNeighborDistance {
                return true
            }
        }
        return false
    }
    
    private func probePointContendsRightWedgeCases(ringProbePoint: RingProbePoint) -> Bool {
        let ringProbeSegmentLeft = ringProbePoint.ringProbeSegmentLeft!
        if !ringProbeSegmentLeft.isIllegal {
            let neighborRight = ringProbePoint.neighborRight!
            if ringProbeSegmentLeft.distanceSquaredToClosestPoint(neighborRight.x, neighborRight.y) < PolyMeshConstants.probeMeldNeighborDistance {
                return true
            }
        }
        return false
    }
    
    private func probePointContendsLeft(ringProbePoint: RingProbePoint) -> Bool {
        
        if ringProbePoint.distanceSquared(ringProbePoint: ringProbePoint.neighborLeft) < PolyMeshConstants.probeMeldNeighborDistanceSquared {
            return true
        }
        
        if ringProbePoint.connectionCount > 0 {
            let firstConnection = ringProbePoint.connections[0]
            let neighborLeft = ringProbePoint.neighborLeft!
            if neighborLeft.connectionCount > 0 {
                let neighborLeftLastConnection = neighborLeft.connections[neighborLeft.connectionCount - 1]
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringProbePoint.x,
                                                         line1Point1Y: ringProbePoint.y,
                                                         line1Point2X: firstConnection.x,
                                                         line1Point2Y: firstConnection.y,
                                                         line2Point1X: neighborLeft.x,
                                                         line2Point1Y: neighborLeft.y,
                                                         line2Point2X: neighborLeftLastConnection.x,
                                                         line2Point2Y: neighborLeftLastConnection.y) {
                    return true
                }
            }
        }
        return false
    }
    
    func probePointContendsRightSubsequent(ringProbePoint: RingProbePoint,
                                           steps: Int) -> Bool {
        
        if steps < 2 {
            return false
        }
        
        if steps >= (ringProbePointCount - 1) {
            return false
        }
        
        var otherProbePointIndex = ringProbePoint.ringIndex + steps
        if otherProbePointIndex >= ringProbePointCount {
            otherProbePointIndex -= ringProbePointCount
        }
        
        let otherProbePoint = ringProbePoints[otherProbePointIndex]
        let distanceSquared = ringProbePoint.distanceSquared(ringProbePoint: otherProbePoint)
        if distanceSquared < PolyMeshConstants.probeMeldClusterDistanceSquared {
            return true
        }
        
        else {//if distanceSquared < PolyMeshConstants.probeMeldClusterMaximumDistanceSquared {
            if ringProbePoint.connectionCount > 0 {
                let otherProbePointRightProbeSegment = otherProbePoint.ringProbeSegmentRight!
                if ringProbePoint.firstConnectionSpoke.intersects(lineSegment: otherProbePointRightProbeSegment) {
                    return true
                }
                if ringProbePoint.connectionCount > 1 {
                    if ringProbePoint.lastConnectionSpoke.intersects(lineSegment: otherProbePointRightProbeSegment) {
                        return true
                    }
                }
                
                /*
                let otherProbePointLeftProbeSegment = otherProbePoint.ringProbeSegmentLeft!
                if ringProbePoint.firstConnectionSpoke.intersects(lineSegment: otherProbePointLeftProbeSegment) {
                    return true
                }
                if ringProbePoint.connectionCount > 1 {
                    if ringProbePoint.lastConnectionSpoke.intersects(lineSegment: otherProbePointLeftProbeSegment) {
                        return true
                    }
                }
                */
            }
        }
        
        return false
    }
    
}
