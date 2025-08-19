//
//  Ring+MeldAndRelax.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/6/24.
//

import Foundation

extension Ring {
    
    private static let maxMeldAndRelaxCallDepth = 64
    
    // Returns true if the final geometry is legal.
    func attemptMeldAndRelax() -> Bool {
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.isRelaxDirectionComputed = false
            ringProbePoint.isRelaxable = false
        }

        if !attemptMeldRelaxResolveOutsidePoints() {
            return false
        }
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.isRelaxDirectionComputed = false
            ringProbePoint.isRelaxable = false
        }
        
        attemptMeldAndRelaxMain()
        
        if isComplexProbeSegmentsWithLineSegments() {
            return false
        }
        
        for _ in 0..<6 {
            if !attemptSeparateProbePointsPass() {
                break
            }
        }
        
        if containsProbePointsThatAreTooFarApart() {
            resolveProbePointsThatAreTooFarApart()
            
            //calculateRingProbePointIndices()
            //calculateProbePointNeighbors()
            //calculateProbeSegmentsUsingProbePoints()
            //buildRingProbeSegmentBucket()
        }
        
        return true
    }
    
    func isProbePointOutsideRingOrTooCloseToEdge(ringProbePoint: RingProbePoint) -> Bool {
        
        if !containsRingPoint(ringProbePoint.x, ringProbePoint.y) {
            return true
        }
        
        for connectionIndex in 0..<ringProbePoint.connectionCount {
            let connection = ringProbePoint.connections[connectionIndex]
            
            let minX = min(connection.x, ringProbePoint.x) - PolyMeshConstants.probePointTooCloseToLineSegment
            let maxX = max(connection.x, ringProbePoint.x) + PolyMeshConstants.probePointTooCloseToLineSegment
            let minY = min(connection.y, ringProbePoint.y) - PolyMeshConstants.probePointTooCloseToLineSegment
            let maxY = max(connection.y, ringProbePoint.y) + PolyMeshConstants.probePointTooCloseToLineSegment
            
            ringLineSegmentBucket.query(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
            
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                
                if bucketLineSegment.ringPointLeft === connection { continue }
                if bucketLineSegment.ringPointRight === connection { continue }
                
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringProbePoint.x,
                                                         line1Point1Y: ringProbePoint.y,
                                                         line1Point2X: connection.x,
                                                         line1Point2Y: connection.y,
                                                         line2Point1X: bucketLineSegment.x1,
                                                         line2Point1Y: bucketLineSegment.y1,
                                                         line2Point2X: bucketLineSegment.x2,
                                                         line2Point2Y: bucketLineSegment.y2) {
                    return true
                }
                
                if bucketLineSegment.distanceSquaredToClosestPoint(ringProbePoint.x, ringProbePoint.y) < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                    return true
                }
            }
        }
        
        return false
    }
    
    func attemptMeldRelaxResolveOutsidePoints() -> Bool {
        
        var fudge = 0
        while true {
            
            var isAnyProbePointMisplaced = false
            
            for ringProbePointIndex in 0..<ringProbePointCount {
                let ringProbePoint = ringProbePoints[ringProbePointIndex]
                if isProbePointOutsideRingOrTooCloseToEdge(ringProbePoint: ringProbePoint) {
                    isAnyProbePointMisplaced = true
                    break
                }
            }
            
            if !isAnyProbePointMisplaced {
                // We are okay to proceed.
                return true
            }
            
            calculateProbePointRelaxGeometryIfNotComputedLocal()
            
            if calculateRelaxableWithRelaxGeometryAlreadyComputed() {
                
                relaxProbePoints()
            } else {
                return false
            }
            
            fudge += 1
            if fudge >= 32 {
                break
            }
        }
        return false
    }
    
    // Returns true if a change was made.
    func attemptMeldAndRelaxMain() {
        
        var callDepth = 0
        if calculateProbePointMeldContentionCounts() {
            if attemptMeldAndRelaxStartingWithMeld(callDepth: &callDepth) {
                return
            }
        }
        if calculateProbePointsWithIllegalGeometry() {
            if attemptMeldAndRelaxStartingWithRelax(callDepth: &callDepth) {
                return
            }
        }
    }
    
    //@Precondition: calculateProbePointMeldContentionCounts() returned true
    func attemptMeldAndRelaxStartingWithMeld(callDepth: inout Int) -> Bool {
        
        callDepth += 1
        if callDepth > Self.maxMeldAndRelaxCallDepth {
            return false
        }
        
        if meldPass() {
            // we will bobble it back to the relax process, otherwise repeat...
            if calculateProbePointsWithIllegalGeometry() {
                if attemptMeldAndRelaxStartingWithRelax(callDepth: &callDepth) {
                    return true
                }
            }
            
            _ = attemptMeldAndRelaxStartingWithMeld(callDepth: &callDepth)
            return true
        }

        return false
    }
    
    //@Precondition: calculateProbePointsWithIllegalGeometry() returned true
    func attemptMeldAndRelaxStartingWithRelax(callDepth: inout Int) -> Bool {
        
        callDepth += 1
        if callDepth > Self.maxMeldAndRelaxCallDepth {
            return false
        }
        
        calculateProbePointRelaxGeometryIfNotComputedAll()
        
        if calculateRelaxableWithRelaxGeometryAlreadyComputed() {
            
            relaxProbePoints()
            
            //1.) Should we meld? If we do meld, we can exit.
            if calculateProbePointMeldContentionCounts() {
                if attemptMeldAndRelaxStartingWithMeld(callDepth: &callDepth) {
                    return true
                }
            }
            
            //2.) Should we relax more? We do not need to re-calc the directions.
            if calculateProbePointsWithIllegalGeometry() {
                _ = attemptMeldAndRelaxStartingWithRelax(callDepth: &callDepth)
            }
            
            return true
        } else {
            return false
        }
    }
    
    func attemptSeparateProbePointsPass() -> Bool {
        
        var result = false
        
        for ringProbePointIndex in 0..<ringProbePointCount {
            
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            
            if ringProbePoint.isButtressCenter {
                continue
            }
            
            var ringProbePointIndexBack1 = ringProbePointIndex - 1
            if ringProbePointIndexBack1 == -1 {
                ringProbePointIndexBack1 = ringProbePointCount - 1
            }
            var ringProbePointIndexBack2 = ringProbePointIndexBack1 - 1
            if ringProbePointIndexBack2 == -1 {
                ringProbePointIndexBack2 = ringProbePointCount - 1
            }
            
            var ringProbePointIndexForward1 = ringProbePointIndex + 1
            if ringProbePointIndexForward1 == ringProbePointCount {
                ringProbePointIndexForward1 = 0
            }
            
            var ringProbePointIndexForward2 = ringProbePointIndexForward1 + 1
            if ringProbePointIndexForward2 == ringProbePointCount {
                ringProbePointIndexForward2 = 0
            }
            
            let ringProbePointBack1 = ringProbePoints[ringProbePointIndexBack1]
            let ringProbePointForward1 = ringProbePoints[ringProbePointIndexForward1]
            
            let distanceSquaredToBack1 = ringProbePoint.distanceSquared(ringProbePoint: ringProbePointBack1)
            let distanceSquaredToForward1 = ringProbePoint.distanceSquared(ringProbePoint: ringProbePointForward1)
            let distanceSquaredMax = max(distanceSquaredToBack1, distanceSquaredToForward1)
            
            if distanceSquaredToBack1 < PolyMeshConstants.relaxProbePointTooCloseSquared &&
                distanceSquaredToForward1 > PolyMeshConstants.relaxProbePointTooCloseSquared {
                
                var diffX = ringProbePointForward1.x - ringProbePoint.x
                var diffY = ringProbePointForward1.y - ringProbePoint.y
                var distance = diffX * diffX + diffY * diffY
                if distance > Math.epsilon {
                    distance = sqrtf(distance)
                    diffX /= distance
                    diffY /= distance
                    
                    let proposedX = ringProbePoint.x + diffX
                    let proposedY = ringProbePoint.y + diffY
                    
                    let proposedDistanceSquaredToBack1 = ringProbePointBack1.distanceSquared(x: proposedX, y: proposedY)
                    let proposedDistanceSquaredToForward1 = ringProbePointForward1.distanceSquared(x: proposedX, y: proposedY)
                    let proposedDistanceSquaredMax = max(proposedDistanceSquaredToBack1, proposedDistanceSquaredToForward1)
                    
                    if proposedDistanceSquaredMax < distanceSquaredMax {
                        
                        ringProbePoint.x = proposedX
                        ringProbePoint.y = proposedY
                        result = true
                    }
                }
                
            } else if distanceSquaredToBack1 > PolyMeshConstants.relaxProbePointTooCloseSquared &&
                        distanceSquaredToForward1 < PolyMeshConstants.relaxProbePointTooCloseSquared {
                
                var diffX = ringProbePointBack1.x - ringProbePoint.x
                var diffY = ringProbePointBack1.y - ringProbePoint.y
                var distance = diffX * diffX + diffY * diffY
                if distance > Math.epsilon {
                    distance = sqrtf(distance)
                    diffX /= distance
                    diffY /= distance
                    
                    let proposedX = ringProbePoint.x + diffX
                    let proposedY = ringProbePoint.y + diffY
                    
                    let proposedDistanceSquaredToBack1 = ringProbePointBack1.distanceSquared(x: proposedX, y: proposedY)
                    let proposedDistanceSquaredToForward1 = ringProbePointForward1.distanceSquared(x: proposedX, y: proposedY)
                    let proposedDistanceSquaredMax = max(proposedDistanceSquaredToBack1, proposedDistanceSquaredToForward1)
                    
                    if proposedDistanceSquaredMax < distanceSquaredMax {
                        
                        //ringProbeSegmentBucket.remove(ringProbeSegment: ringProbePoint.ringProbeSegmentLeft)
                        //ringProbeSegmentBucket.remove(ringProbeSegment: ringProbePoint.ringProbeSegmentRight)
                        
                        ringProbePoint.x = proposedX
                        ringProbePoint.y = proposedY
                        
                        //ringProbePoint.ringProbeSegmentLeft.x2 = proposedX
                        //ringProbePoint.ringProbeSegmentLeft.y2 = proposedY
                        //ringProbePoint.ringProbeSegmentLeft.precompute()
                        //ringProbeSegmentBucket.add(ringProbeSegment: ringProbePoint.ringProbeSegmentLeft)
                        
                        //ringProbePoint.ringProbeSegmentRight.x1 = proposedX
                        //ringProbePoint.ringProbeSegmentRight.y1 = proposedY
                        //ringProbePoint.ringProbeSegmentRight.precompute()
                        //ringProbeSegmentBucket.add(ringProbeSegment: ringProbePoint.ringProbeSegmentRight)
                        
                        result = true
                    }
                }
            }
        }
        return result
    }
    
}
