//
//  Ring+SafePointPointConnection.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/30/23.
//

import Foundation

extension Ring {
    
    //@Precondition: polyPointBucket is populated
    //@Precondition: ringLineSegmentBucket is *populated* AND *queried* with acceptable range...
    func isSafeConnection(ringPoint: RingPoint,
                          ringLineSegment: RingLineSegment) -> Bool {
        
        if ringPoint === ringLineSegment.ringPointLeft { return false }
        if ringPoint === ringLineSegment.ringPointRight { return false }
        
        
        
        
        
        //os_signpost(.begin, log: ringMeshifyLog, name: "safe_connection_contains_point")
        if !containsRingPoint((ringPoint.x + ringLineSegment.centerX) * 0.5,
                              (ringPoint.y + ringLineSegment.centerY) * 0.5) {
            //os_signpost(.end, log: ringMeshifyLog, name: "safe_connection_contains_point")
            return false
        } else {
            //os_signpost(.end, log: ringMeshifyLog, name: "safe_connection_contains_point")
        }
        
        
        // This loop is good for ringLineSegment.p1
        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
            let considerRingLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
            
            if considerRingLineSegment === ringLineSegment { continue }
            if considerRingLineSegment.ringPointRight === ringPoint { continue }
            if considerRingLineSegment.ringPointLeft === ringPoint { continue }
            if considerRingLineSegment.neighborRight === ringLineSegment { continue }
            
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringPoint.x,
                                                     line1Point1Y: ringPoint.y,
                                                     line1Point2X: ringLineSegment.x1,
                                                     line1Point2Y: ringLineSegment.y1,
                                                     line2Point1X: considerRingLineSegment.x1,
                                                     line2Point1Y: considerRingLineSegment.y1,
                                                     line2Point2X: considerRingLineSegment.x2,
                                                     line2Point2Y: considerRingLineSegment.y2) {
                return false
            }
        }
        
        // This loop is good for ringLineSegment.p2
        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
            let considerRingLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
            
            if considerRingLineSegment === ringLineSegment { continue }
            if considerRingLineSegment.ringPointRight === ringPoint { continue }
            if considerRingLineSegment.ringPointLeft === ringPoint { continue }
            if considerRingLineSegment.neighborLeft === ringLineSegment { continue }
            
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringPoint.x,
                                                     line1Point1Y: ringPoint.y,
                                                     line1Point2X: ringLineSegment.x2,
                                                     line1Point2Y: ringLineSegment.y2,
                                                     line2Point1X: considerRingLineSegment.x1,
                                                     line2Point1Y: considerRingLineSegment.y1,
                                                     line2Point2X: considerRingLineSegment.x2,
                                                     line2Point2Y: considerRingLineSegment.y2) {
                return false
            }
        }
        
        return true
    }
    
    func isSafeConnectionForSplit(ringPoint: RingPoint,
                                  splitRingPoint1: RingPoint,
                                  splitRingPoint2: RingPoint) -> Bool {
        
        if Math.polygonIndexDistance(index1: ringPoint.ringIndex, index2: splitRingPoint1.ringIndex, count: ringPointCount) <= 1 {
            return true
        }
        
        if Math.polygonIndexDistance(index1: ringPoint.ringIndex, index2: splitRingPoint2.ringIndex, count: ringPointCount) <= 1 {
            return true
        }
        
        if !containsRingPoint((ringPoint.x + splitRingPoint1.x) * 0.5,
                              (ringPoint.y + splitRingPoint1.y) * 0.5) {
            return false
        }
        
        if !containsRingPoint((ringPoint.x + splitRingPoint2.x) * 0.5,
                              (ringPoint.y + splitRingPoint2.y) * 0.5) {
            return false
        }
        
        // This loop is good for ringLineSegment.p1
        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
            let considerRingLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
            
            if considerRingLineSegment.ringPointRight === splitRingPoint1 { continue }
            if considerRingLineSegment.ringPointLeft === splitRingPoint1 { continue }
            if considerRingLineSegment.ringPointRight === ringPoint { continue }
            if considerRingLineSegment.ringPointLeft === ringPoint { continue }
            
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringPoint.x,
                                                     line1Point1Y: ringPoint.y,
                                                     line1Point2X: splitRingPoint1.x,
                                                     line1Point2Y: splitRingPoint1.y,
                                                     line2Point1X: considerRingLineSegment.x1,
                                                     line2Point1Y: considerRingLineSegment.y1,
                                                     line2Point2X: considerRingLineSegment.x2,
                                                     line2Point2Y: considerRingLineSegment.y2) {
                return false
            }
        }
        
        // This loop is good for ringLineSegment.p2
        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
            let considerRingLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
            if considerRingLineSegment.ringPointRight === splitRingPoint2 { continue }
            if considerRingLineSegment.ringPointLeft === splitRingPoint2 { continue }
            if considerRingLineSegment.ringPointRight === ringPoint { continue }
            if considerRingLineSegment.ringPointLeft === ringPoint { continue }
            
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringPoint.x,
                                                     line1Point1Y: ringPoint.y,
                                                     line1Point2X: splitRingPoint2.x,
                                                     line1Point2Y: splitRingPoint2.y,
                                                     line2Point1X: considerRingLineSegment.x1,
                                                     line2Point1Y: considerRingLineSegment.y1,
                                                     line2Point2X: considerRingLineSegment.x2,
                                                     line2Point2Y: considerRingLineSegment.y2) {
                return false
            }
        }
        return true
    }
    
    func isSafeConnectionForEar(ringPoint: RingPoint,
                                splitRingPoint1: RingPoint,
                                splitRingPoint2: RingPoint,
                                splitSegment: PrecomputedLineSegment,
                                closestX: Float,
                                closestY: Float) -> Bool {
        
        let distanceToSplitPoint1 = splitRingPoint1.distanceSquared(x: closestX, y: closestY)
        if distanceToSplitPoint1 <= Math.epsilon {
            return false
        }
        
        let distanceToSplitPoint2 = splitRingPoint2.distanceSquared(x: closestX, y: closestY)
        if distanceToSplitPoint2 <= Math.epsilon {
            return false
        }
        
        let considerRingLineSegment1 = splitRingPoint1.ringLineSegmentRight!
        if Math.lineSegmentIntersectsLineSegment(line1Point1X: considerRingLineSegment1.x1,
                                                 line1Point1Y: considerRingLineSegment1.y1,
                                                 line1Point2X: considerRingLineSegment1.x2,
                                                 line1Point2Y: considerRingLineSegment1.y2,
                                                 line2Point1X: ringPoint.x, line2Point1Y: ringPoint.y,
                                                 line2Point2X: closestX, line2Point2Y: closestY) {
            return false
        }
        
        let considerRingLineSegment2 = splitRingPoint1.ringLineSegmentLeft!
        if considerRingLineSegment2 !== considerRingLineSegment1 {
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: considerRingLineSegment2.x1,
                                                     line1Point1Y: considerRingLineSegment2.y1,
                                                     line1Point2X: considerRingLineSegment2.x2,
                                                     line1Point2Y: considerRingLineSegment2.y2,
                                                     line2Point1X: ringPoint.x,
                                                     line2Point1Y: ringPoint.y,
                                                     line2Point2X: closestX,
                                                     line2Point2Y: closestY) {
                return false
            }
        }
        
        
        let considerRingLineSegment3 = splitRingPoint2.ringLineSegmentRight!
        if considerRingLineSegment3 !== considerRingLineSegment1 &&
            considerRingLineSegment3 !== considerRingLineSegment2 {
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: considerRingLineSegment3.x1,
                                                     line1Point1Y: considerRingLineSegment3.y1,
                                                     line1Point2X: considerRingLineSegment3.x2,
                                                     line1Point2Y: considerRingLineSegment3.y2,
                                                     line2Point1X: ringPoint.x,
                                                     line2Point1Y: ringPoint.y,
                                                     line2Point2X: closestX,
                                                     line2Point2Y: closestY) {
                return false
            }
        }
        
        let considerRingLineSegment4 = splitRingPoint2.ringLineSegmentLeft!
        if considerRingLineSegment4 !== considerRingLineSegment1 &&
            considerRingLineSegment4 !== considerRingLineSegment2 &&
            considerRingLineSegment4 !== considerRingLineSegment3 {
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: considerRingLineSegment4.x1,
                                                     line1Point1Y: considerRingLineSegment4.y1,
                                                     line1Point2X: considerRingLineSegment4.x2,
                                                     line1Point2Y: considerRingLineSegment4.y2,
                                                     line2Point1X: ringPoint.x,
                                                     line2Point1Y: ringPoint.y,
                                                     line2Point2X: closestX,
                                                     line2Point2Y: closestY) {
                return false
            }
        }
        return true
    }
}
