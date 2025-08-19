//
//  Ring+ProbePointsTagIllegalGeometry.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/2/24.
//

import Foundation

extension Ring {
    
    //@Precondition: calculateProbePoints
    //@Precondition: calculateProbeSegmentsUsingProbePoints
    //@Precondition: buildLineSegmentBucket
    //@Precondition: buildRingProbeSegmentBucket
    func calculateProbePointsWithIllegalGeometry() -> Bool {
        
        var result = false
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.isIllegal = false
        }
        
        // Check of any "probe spoke" (the line from ring point to probe points)
        // intersects with another probe segment (that doesn't include the probe spoke)
        // We do not need to check distance here; as distance will be covered by
        // mainly SEGMENT-SEGMENT distance
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            
            
            for connectionIndex in 0..<ringProbePoint.connectionCount {
                let connection = ringProbePoint.connections[connectionIndex]
                
                ringProbeSegmentBucket.query(minX: min(ringProbePoint.x, connection.x) - Math.epsilon,
                                              maxX: max(ringProbePoint.x, connection.x) + Math.epsilon,
                                              minY: min(ringProbePoint.y, connection.y) - Math.epsilon,
                                              maxY: max(ringProbePoint.y, connection.y) + Math.epsilon)
                for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
                    let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
                    
                    if ringProbePoint.ringProbeSegmentRight === bucketProbeSegment { continue }
                    if ringProbePoint.ringProbeSegmentLeft === bucketProbeSegment { continue }
                    
                    if Math.lineSegmentIntersectsLineSegment(line1Point1X: connection.x, line1Point1Y: connection.y,
                                                             line1Point2X: ringProbePoint.x, line1Point2Y: ringProbePoint.y,
                                                             line2Point1X: bucketProbeSegment.x1, line2Point1Y: bucketProbeSegment.y1,
                                                             line2Point2X: bucketProbeSegment.x2, line2Point2Y: bucketProbeSegment.y2) {
                        bucketProbeSegment.ringProbePointLeft.isIllegal = true
                        bucketProbeSegment.ringProbePointRight.isIllegal = true
                        ringProbePoint.isIllegal = true
                        result = true
                    }
                }
            }
        }
        
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
            
            ringProbeSegmentBucket.query(ringProbeSegment: ringProbeSegment, padding: PolyMeshConstants.probePointTooCloseToLineSegment)
            for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
                let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
                
                if bucketProbeSegment === ringProbeSegment { continue }
                if ringProbeSegment.neighborLeft === bucketProbeSegment { continue }
                if ringProbeSegment.neighborRight === bucketProbeSegment { continue }
                
                if bucketProbeSegment.distanceSquaredToLineSegment(ringProbeSegment) < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                    ringProbeSegment.ringProbePointLeft.isIllegal = true
                    ringProbeSegment.ringProbePointRight.isIllegal = true
                    bucketProbeSegment.ringProbePointLeft.isIllegal = true
                    bucketProbeSegment.ringProbePointRight.isIllegal = true
                    result = true
                }
            }
        }
        
        if isCounterClockwiseProbePoints() {
            for ringProbePointIndex in 0..<ringProbePointCount {
                let ringProbePoint = ringProbePoints[ringProbePointIndex]
                ringProbePoint.isIllegal = true
            }
            result = true
        }
        
        return result
    }
    
    func containsProbePointsWithIllegalGeometry() -> Bool {
        
        // Check of any "probe spoke" (the line from ring point to probe points)
        // intersects with another probe segment (that doesn't include the probe spoke)
        // We do not need to check distance here; as distance will be covered by
        // mainly SEGMENT-SEGMENT distance
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            
            
            for connectionIndex in 0..<ringProbePoint.connectionCount {
                let connection = ringProbePoint.connections[connectionIndex]
                
                ringProbeSegmentBucket.query(minX: min(ringProbePoint.x, connection.x) - Math.epsilon,
                                              maxX: max(ringProbePoint.x, connection.x) + Math.epsilon,
                                              minY: min(ringProbePoint.y, connection.y) - Math.epsilon,
                                              maxY: max(ringProbePoint.y, connection.y) + Math.epsilon)
                for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
                    let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
                    
                    if ringProbePoint.ringProbeSegmentRight === bucketProbeSegment { continue }
                    if ringProbePoint.ringProbeSegmentLeft === bucketProbeSegment { continue }
                    
                    if Math.lineSegmentIntersectsLineSegment(line1Point1X: connection.x, line1Point1Y: connection.y,
                                                             line1Point2X: ringProbePoint.x, line1Point2Y: ringProbePoint.y,
                                                             line2Point1X: bucketProbeSegment.x1, line2Point1Y: bucketProbeSegment.y1,
                                                             line2Point2X: bucketProbeSegment.x2, line2Point2Y: bucketProbeSegment.y2) {
                        return true
                    }
                }
            }
        }
        
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
            
            ringProbeSegmentBucket.query(ringProbeSegment: ringProbeSegment, padding: PolyMeshConstants.probePointTooCloseToLineSegment)
            for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
                let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
                
                if bucketProbeSegment === ringProbeSegment { continue }
                if ringProbeSegment.neighborLeft === bucketProbeSegment { continue }
                if ringProbeSegment.neighborRight === bucketProbeSegment { continue }
                
                if bucketProbeSegment.distanceSquaredToLineSegment(ringProbeSegment) < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                    return true
                }
            }
        }
        
        if isCounterClockwiseProbePoints() {
            return true
        }
        
        return false
    }
}
