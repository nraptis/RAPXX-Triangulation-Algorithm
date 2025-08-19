//
//  Ring+SplitCheckPointCloseness.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/10/24.
//

import Foundation

extension Ring {
    
    //
    // If this returns false, the split cannot be used PERIOD, so the quality
    // will not be set to, for example, "broken" by default. It cannot be used.
    //
    func attemptMeasureSplitQualityPointClosenessNeighbor(index1: Int,
                                                          index2: Int,
                                                          quality: inout RingSplitQuality) -> Bool {
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        let ringPointCount1 = ringPointCount - 1
        
        let highQualityDistance = (RingSplitQuality.splitQualityPointClosenessNeighborThresholdGreat + Math.epsilon)
        var neighborRingPointIndex1 = index1 + 1
        if neighborRingPointIndex1 == ringPointCount {
            neighborRingPointIndex1 = 0
        }
        let neighborRingPoint1 = ringPoints[neighborRingPointIndex1]
        
        let neighborDistanceSquared1 = preComputedLineSegment1.distanceSquaredToClosestPoint(neighborRingPoint1.x, neighborRingPoint1.y)
        if neighborDistanceSquared1 < Math.epsilon { return false }
        let neighborDistance1 = sqrtf(neighborDistanceSquared1)
        let baselineDistance1 = splitRingPoint1.ringLineSegmentRight.length
        let difference1 = baselineDistance1 - neighborDistance1
        var percent1 = difference1 / PolyMeshConstants.splitPointNeighborGraduationSpan
        if percent1 < 0.0 { percent1 = 0.0 }
        if percent1 > 1.0 { percent1 = 1.0 }
        let theoreticalDistance1 = (highQualityDistance * (1.0 - percent1)) + ((neighborDistance1) * percent1)
        
        // 1.) There is no value to the distance measurement when it comes from the original polygon.
        // 2.) There is a danger of a "snap" (e.g. from Grade F to Grade A) if we simply make sure the distance is "not the same.."
        
        if theoreticalDistance1 < PolyMeshConstants.splitPointNeighborTooCloseToLineSegment {
            return false
        }
        
        var neighborRingPointIndex2 = index1 - 1
        if neighborRingPointIndex2 == -1 {
            neighborRingPointIndex2 = ringPointCount1
        }
        let neighborRingPoint2 = ringPoints[neighborRingPointIndex2]
        let neighborDistanceSquared2 = preComputedLineSegment1.distanceSquaredToClosestPoint(neighborRingPoint2.x, neighborRingPoint2.y)
        if neighborDistanceSquared2 < Math.epsilon { return false }
        let neighborDistance2 = sqrtf(neighborDistanceSquared2)
        let baselineDistance2 = splitRingPoint1.ringLineSegmentLeft.length
        let difference2 = baselineDistance2 - neighborDistance2
        var percent2 = difference2 / PolyMeshConstants.splitPointNeighborGraduationSpan
        if percent2 < 0.0 { percent2 = 0.0 }
        if percent2 > 1.0 { percent2 = 1.0 }
        let theoreticalDistance2 = (highQualityDistance * (1.0 - percent2)) + ((neighborDistance2) * percent2)
        
        if theoreticalDistance2 < PolyMeshConstants.splitPointNeighborTooCloseToLineSegment {
            return false
        }
        
        var neighborRingPointIndex3 = index2 + 1
        if neighborRingPointIndex3 == ringPointCount {
            neighborRingPointIndex3 = 0
        }
        let neighborRingPoint3 = ringPoints[neighborRingPointIndex3]
        let neighborDistanceSquared3 = preComputedLineSegment1.distanceSquaredToClosestPoint(neighborRingPoint3.x, neighborRingPoint3.y)
        if neighborDistanceSquared3 < Math.epsilon { return false }
        let neighborDistance3 = sqrtf(neighborDistanceSquared3)
        let baselineDistance3 = splitRingPoint2.ringLineSegmentRight.length
        let difference3 = baselineDistance3 - neighborDistance3
        var percent3 = difference3 / PolyMeshConstants.splitPointNeighborGraduationSpan
        if percent3 < 0.0 { percent3 = 0.0 }
        if percent3 > 1.0 { percent3 = 1.0 }
        let theoreticalDistance3 = (highQualityDistance * (1.0 - percent3)) + ((neighborDistance3) * percent3)
        if theoreticalDistance3 < PolyMeshConstants.splitPointNeighborTooCloseToLineSegment {
            return false
        }
        
        var neighborRingPointIndex4 = index2 - 1
        if neighborRingPointIndex4 == -1 {
            neighborRingPointIndex4 = ringPointCount1
        }
        let neighborRingPoint4 = ringPoints[neighborRingPointIndex4]
        let neighborDistanceSquared4 = preComputedLineSegment1.distanceSquaredToClosestPoint(neighborRingPoint4.x, neighborRingPoint4.y)
        if neighborDistanceSquared4 < Math.epsilon { return false }
        let neighborDistance4 = sqrtf(neighborDistanceSquared4)
        let baselineDistance4 = splitRingPoint2.ringLineSegmentLeft.length
        let difference4 = baselineDistance4 - neighborDistance4
        var percent4 = difference4 / PolyMeshConstants.splitPointNeighborGraduationSpan
        if percent4 < 0.0 { percent4 = 0.0 }
        if percent4 > 1.0 { percent4 = 1.0 }
        let theoreticalDistance4 = (highQualityDistance * (1.0 - percent4)) + ((neighborDistance4) * percent4)
        if theoreticalDistance4 < PolyMeshConstants.splitPointNeighborTooCloseToLineSegment {
            return false
        }
        
        var minDistance = theoreticalDistance1
        if theoreticalDistance2 < minDistance { minDistance = theoreticalDistance2 }
        if theoreticalDistance3 < minDistance { minDistance = theoreticalDistance3 }
        if theoreticalDistance4 < minDistance { minDistance = theoreticalDistance4 }
        
        quality.pointClosenessNeighbor = RingSplitQuality.classifyPointClosenessNeighbor(minDistance)
        
        return true
    }
    
    func attemptMeasureSplitQualityPointClosenessDistant(index1: Int,
                                                         index2: Int,
                                                         quality: inout RingSplitQuality) -> Bool {
        
        /*
         if TOOL_MARKUP_1_ENABLED {
         
         if ringPointCount < 6 {
         quality.pointClosenessDistant = .excellent
         return true
         }
         
         let splitRingPoint1 = ringPoints[index1]
         let splitRingPoint2 = ringPoints[index2]
         let ringPointCount1 = ringPointCount - 1
         
         var minDistanceSquared = Float(100_000_000.0)
         
         var ceiling1 = index2 - 1
         if ceiling1 == -1 {
         ceiling1 = ringPointCount1
         }
         
         let minX = min(splitRingPoint1.x, splitRingPoint2.x) - RingSplitQuality.splitQualityPointClosenessDistantThresholdGreat - Math.epsilon
         let maxX = max(splitRingPoint1.x, splitRingPoint2.x) + RingSplitQuality.splitQualityPointClosenessDistantThresholdGreat + Math.epsilon
         let minY = min(splitRingPoint1.y, splitRingPoint2.y) - RingSplitQuality.splitQualityPointClosenessDistantThresholdGreat - Math.epsilon
         let maxY = max(splitRingPoint1.y, splitRingPoint2.y) + RingSplitQuality.splitQualityPointClosenessDistantThresholdGreat + Math.epsilon
         
         ringLineSegmentBucket.query(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
         
         var ringPointIndex1 = index1 + 2
         while ringPointIndex1 < ceiling1 {
         
         let ringPoint = ringPoints[ringPointIndex1]
         
         let distanceSquared = preComputedLineSegment1.distanceSquaredToClosestPoint(ringPoint.x, ringPoint.y)
         if distanceSquared < RingSplitQuality.splitQualityPointClosenessDistantThresholdGreatSquared {
         if isSafeConnectionForSplit(ringPoint: ringPoint,
         splitRingPoint1: splitRingPoint1,
         splitRingPoint2: splitRingPoint2) {
         let distanceSquared = preComputedLineSegment1.distanceSquaredToClosestPoint(ringPoint.x, ringPoint.y)
         if distanceSquared < minDistanceSquared {
         minDistanceSquared = distanceSquared
         }
         if distanceSquared < PolyMeshConstants.splitPointDistantTooCloseToLineSegmentSquared {
         return false
         }
         }
         }
         ringPointIndex1 += 1
         }
         
         // How many points will we cross?
         let numberOfPointsInSpan2 = (ringPointCount1 - index2) + (index1)
         
         if numberOfPointsInSpan2 < 3 {
         quality.pointClosenessDistant = RingSplitQuality.classifyPointClosenessDistant(minDistanceSquared)
         return true
         }
         
         var ceiling2 = index1 - 1
         if ceiling2 == -1 {
         ceiling2 = ringPointCount1
         }
         
         var ringPointIndex2 = index2 + 2
         if ringPointIndex2 >= ringPointCount {
         ringPointIndex2 -= ringPointCount
         }
         
         while ringPointIndex2 != ceiling2 {
         
         let ringPoint = ringPoints[ringPointIndex2]
         
         let distanceSquared = preComputedLineSegment1.distanceSquaredToClosestPoint(ringPoint.x, ringPoint.y)
         if distanceSquared < RingSplitQuality.splitQualityPointClosenessDistantThresholdGreatSquared {
         if isSafeConnectionForSplit(ringPoint: ringPoint,
         splitRingPoint1: splitRingPoint1,
         splitRingPoint2: splitRingPoint2) {
         
         if distanceSquared < minDistanceSquared {
         minDistanceSquared = distanceSquared
         }
         
         if distanceSquared < PolyMeshConstants.splitPointDistantTooCloseToLineSegmentSquared {
         return false
         }
         }
         }
         ringPointIndex2 += 1
         if ringPointIndex2 == ringPointCount {
         ringPointIndex2 = 0
         }
         }
         
         quality.pointClosenessDistant = RingSplitQuality.classifyPointClosenessDistant(minDistanceSquared)
         
         return true
         
         } else {
         */
        
        if ringPointCount < 6 {
            quality.pointClosenessDistant = .excellent
            return true
        }
        
        let splitRingPoint1 = ringPoints[index1]
        let splitRingPoint2 = ringPoints[index2]
        let ringPointCount1 = ringPointCount - 1
        
        var minDistanceSquared = Float(100_000_000.0)
        
        var ceiling1 = index2 - 1
        if ceiling1 == -1 {
            ceiling1 = ringPointCount1
        }
        
        var ringPointIndex1 = index1 + 2
        while ringPointIndex1 < ceiling1 {
            
            let ringPoint = ringPoints[ringPointIndex1]
            
            var closestX = Float(0.0)
            var closestY = Float(0.0)
            
            preComputedLineSegment1.closestPoint(ringPoint.x, ringPoint.y, &closestX, &closestY)
            
            let distanceSquared = ringPoint.distanceSquared(x: closestX, y: closestY)
            
            if distanceSquared < RingSplitQuality.splitQualityPointClosenessDistantThresholdGreatSquared {
                if isSafeConnectionForEar(ringPoint: ringPoint,
                                          splitRingPoint1: splitRingPoint1,
                                          splitRingPoint2: splitRingPoint2,
                                          splitSegment: preComputedLineSegment1,
                                          closestX: closestX,
                                          closestY: closestY) {
                    if distanceSquared < minDistanceSquared {
                        minDistanceSquared = distanceSquared
                    }
                    if distanceSquared < PolyMeshConstants.splitPointDistantTooCloseToLineSegmentSquared {
                        return false
                    }
                }
            }
            ringPointIndex1 += 1
        }
        
        // How many points will we cross?
        let numberOfPointsInSpan2 = (ringPointCount1 - index2) + (index1)
        
        if numberOfPointsInSpan2 < 3 {
            quality.pointClosenessDistant = RingSplitQuality.classifyPointClosenessDistant(minDistanceSquared)
            return true
        }
        
        var ceiling2 = index1 - 1
        if ceiling2 == -1 {
            ceiling2 = ringPointCount1
        }
        
        var ringPointIndex2 = index2 + 2
        if ringPointIndex2 >= ringPointCount {
            ringPointIndex2 -= ringPointCount
        }
        
        while ringPointIndex2 != ceiling2 {
            
            let ringPoint = ringPoints[ringPointIndex2]
            
            var closestX = Float(0.0)
            var closestY = Float(0.0)
            
            preComputedLineSegment1.closestPoint(ringPoint.x, ringPoint.y, &closestX, &closestY)
            
            let distanceSquared = ringPoint.distanceSquared(x: closestX, y: closestY)
            if distanceSquared < RingSplitQuality.splitQualityPointClosenessDistantThresholdGreatSquared {
                if isSafeConnectionForEar(ringPoint: ringPoint,
                                          splitRingPoint1: splitRingPoint1,
                                          splitRingPoint2: splitRingPoint2,
                                          splitSegment: preComputedLineSegment1,
                                          closestX: closestX,
                                          closestY: closestY) {
                    
                    if distanceSquared < minDistanceSquared {
                        minDistanceSquared = distanceSquared
                    }
                    
                    if distanceSquared < PolyMeshConstants.splitPointDistantTooCloseToLineSegmentSquared {
                        return false
                    }
                }
            }
            ringPointIndex2 += 1
            if ringPointIndex2 == ringPointCount {
                ringPointIndex2 = 0
            }
        }
        
        quality.pointClosenessDistant = RingSplitQuality.classifyPointClosenessDistant(minDistanceSquared)
        
        return true
        
        //}
    }
}
