//
//  Ring+Complex.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/7/24.
//

import Foundation

extension Ring {
    
    //@Precondition: buildLineSegmentBucket
    func isComplexLineSegments() -> Bool {
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            ringLineSegmentBucket.query(ringLineSegment: ringLineSegment)
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                if bucketLineSegment === ringLineSegment { continue }
                if bucketLineSegment.neighborLeft === ringLineSegment { continue }
                if bucketLineSegment.neighborRight === ringLineSegment { continue }
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringLineSegment.x1,
                                                         line1Point1Y: ringLineSegment.y1,
                                                         line1Point2X: ringLineSegment.x2,
                                                         line1Point2Y: ringLineSegment.y2,
                                                         line2Point1X: bucketLineSegment.x1,
                                                         line2Point1Y: bucketLineSegment.y1,
                                                         line2Point2X: bucketLineSegment.x2,
                                                         line2Point2Y: bucketLineSegment.y2) {
                    return true
                }
            }
        }
        return false
    }
    
    //@Precondition: buildLineSegmentBucket
    func isComplexProbeSegments() -> Bool {
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
            ringProbeSegmentBucket.query(ringProbeSegment: ringProbeSegment)
            for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
                let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
                if bucketProbeSegment === ringProbeSegment { continue }
                if bucketProbeSegment.neighborLeft === ringProbeSegment { continue }
                if bucketProbeSegment.neighborRight === ringProbeSegment { continue }
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringProbeSegment.x1,
                                                         line1Point1Y: ringProbeSegment.y1,
                                                         line1Point2X: ringProbeSegment.x2,
                                                         line1Point2Y: ringProbeSegment.y2,
                                                         line2Point1X: bucketProbeSegment.x1,
                                                         line2Point1Y: bucketProbeSegment.y1,
                                                         line2Point2X: bucketProbeSegment.x2,
                                                         line2Point2Y: bucketProbeSegment.y2) {
                    return true
                }
            }
        }
        return false
    }
    
    //@Precondition: buildRingProbeSegmentBucket
    func isComplexProbeSegmentsWithLineSegments() -> Bool {
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
            ringLineSegmentBucket.query(ringProbeSegment: ringProbeSegment)
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringProbeSegment.x1,
                                                         line1Point1Y: ringProbeSegment.y1,
                                                         line1Point2X: ringProbeSegment.x2,
                                                         line1Point2Y: ringProbeSegment.y2,
                                                         line2Point1X: bucketLineSegment.x1,
                                                         line2Point1Y: bucketLineSegment.y1,
                                                         line2Point2X: bucketLineSegment.x2,
                                                         line2Point2Y: bucketLineSegment.y2) {
                    return true
                }
            }
        }
        return false
    }
    
    //@Precondition: buildRingProbeSegmentBucket
    func isComplexLineSegmentsWithProbeSegments() -> Bool {
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            ringProbeSegmentBucket.query(ringLineSegment: ringLineSegment)
            for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
                let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringLineSegment.x1,
                                                         line1Point1Y: ringLineSegment.y1,
                                                         line1Point2X: ringLineSegment.x2,
                                                         line1Point2Y: ringLineSegment.y2,
                                                         line2Point1X: bucketProbeSegment.x1,
                                                         line2Point1Y: bucketProbeSegment.y1,
                                                         line2Point2X: bucketProbeSegment.x2,
                                                         line2Point2Y: bucketProbeSegment.y2) {
                    return true
                }
            }
        }
        return false
    }
    
    func isComplexRingPoints() -> Bool {
        let count = ringPointCount
        if count > 3 {
            let count_2 = (count - 2)
            let count_1 = (count - 1)
            var outerMinusOne = 0
            var outer = 1
            while outer < count_2 {
                var innerMinusOne = outer + 1
                var inner = innerMinusOne + 1
                while inner < count {
                    if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringPoints[outerMinusOne].x,
                                                             line1Point1Y: ringPoints[outerMinusOne].y,
                                                             line1Point2X: ringPoints[outer].x,
                                                             line1Point2Y: ringPoints[outer].y,
                                                             line2Point1X: ringPoints[innerMinusOne].x,
                                                             line2Point1Y: ringPoints[innerMinusOne].y,
                                                             line2Point2X: ringPoints[inner].x,
                                                             line2Point2Y: ringPoints[inner].y) {
                        return true
                    }
                    innerMinusOne = inner
                    inner += 1
                }
                outerMinusOne = outer
                outer += 1
            }
            outerMinusOne = 1
            outer = 2
            while outer < count_1 {
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringPoints[count_1].x,
                                                         line1Point1Y: ringPoints[count_1].y,
                                                         line1Point2X: ringPoints[0].x,
                                                         line1Point2Y: ringPoints[0].y,
                                                         line2Point1X: ringPoints[outerMinusOne].x,
                                                         line2Point1Y: ringPoints[outerMinusOne].y,
                                                         line2Point2X: ringPoints[outer].x,
                                                         line2Point2Y: ringPoints[outer].y) {
                    return true
                }
                outerMinusOne = outer
                outer += 1
            }
        }
        return false
    }
    
    func isComplexProbePoints() -> Bool {
        let count = ringProbePointCount
        if count > 3 {
            let count_2 = (count - 2)
            let count_1 = (count - 1)
            var outerMinusOne = 0
            var outer = 1
            while outer < count_2 {
                var innerMinusOne = outer + 1
                var inner = innerMinusOne + 1
                while inner < count {
                    if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringProbePoints[outerMinusOne].x,
                                                             line1Point1Y: ringProbePoints[outerMinusOne].y,
                                                             line1Point2X: ringProbePoints[outer].x,
                                                             line1Point2Y: ringProbePoints[outer].y,
                                                             line2Point1X: ringProbePoints[innerMinusOne].x,
                                                             line2Point1Y: ringProbePoints[innerMinusOne].y,
                                                             line2Point2X: ringProbePoints[inner].x,
                                                             line2Point2Y: ringProbePoints[inner].y) {
                        return true
                    }
                    innerMinusOne = inner
                    inner += 1
                }
                outerMinusOne = outer
                outer += 1
            }
            outerMinusOne = 1
            outer = 2
            while outer < count_1 {
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: ringProbePoints[count_1].x,
                                                         line1Point1Y: ringProbePoints[count_1].y,
                                                         line1Point2X: ringProbePoints[0].x,
                                                         line1Point2Y: ringProbePoints[0].y,
                                                         line2Point1X: ringProbePoints[outerMinusOne].x,
                                                         line2Point1Y: ringProbePoints[outerMinusOne].y,
                                                         line2Point2X: ringProbePoints[outer].x,
                                                         line2Point2Y: ringProbePoints[outer].y) {
                    return true
                }
                outerMinusOne = outer
                outer += 1
            }
        }
        return false
    }
}
