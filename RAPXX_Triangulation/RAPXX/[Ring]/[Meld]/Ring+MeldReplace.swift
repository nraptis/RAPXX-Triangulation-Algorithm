//
//  Ring+MeldReplace.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 2/5/24.
//

import Foundation

extension Ring {
    
    // Note: This will not fixup the probe segments.
    func meldReplaceProbePointRangeWithOneProbePoint(startIndex: Int, endIndex: Int, _ ringProbePoint: RingProbePoint) {
        
        if startIndex < 0 {
            return
        }
        if startIndex >= ringProbePointCount {
            return
        }
        if endIndex < 0 {
            return
        }
        if endIndex >= ringProbePointCount {
            return
        }
        
        if startIndex > endIndex {
            if endIndex != 0 {
                let shift = endIndex
                var index = 1
                let ceiling = ringProbePointCount - shift - (ringProbePointCount - startIndex)
                while index < ceiling {
                    ringProbePoints[index] = ringProbePoints[index + shift]
                    ringProbePoints[index].ringIndex = index
                    index += 1
                }
            }
            ringProbePoints[0] = ringProbePoint
            ringProbePoint.ringIndex = 0
            ringProbePointCount -= ((ringProbePointCount - startIndex) + endIndex)
            
            if ringProbePointCount > 1 {
                let ringProbePointCount1 = ringProbePointCount - 1
                ringProbePoint.neighborRight = ringProbePoints[1]
                ringProbePoints[1].neighborLeft = ringProbePoint
                ringProbePoints[ringProbePointCount1].neighborRight = ringProbePoint
                ringProbePoint.neighborLeft = ringProbePoints[ringProbePointCount1]
            } else {
                ringProbePoint.neighborLeft = ringProbePoint
                ringProbePoint.neighborRight = ringProbePoint
            }
        } else {
            if endIndex != 0 {
                let shift = (endIndex - startIndex)
                let ceiling = ringProbePointCount - shift
                var index = startIndex + 1
                while index < ceiling {
                    ringProbePoints[index] = ringProbePoints[index + shift]
                    ringProbePoints[index].ringIndex = index
                    index += 1
                }
                ringProbePointCount -= shift
            }
            ringProbePoints[startIndex] = ringProbePoint
            ringProbePoint.ringIndex = startIndex
            if ringProbePointCount > 1 {
                var nextIndex = startIndex + 1
                if nextIndex == ringProbePointCount {
                    nextIndex = 0
                }
                ringProbePoint.neighborRight = ringProbePoints[nextIndex]
                ringProbePoints[nextIndex].neighborLeft = ringProbePoint
                var prevIndex = startIndex - 1
                if prevIndex == -1 {
                    prevIndex = ringProbePointCount - 1
                }
                ringProbePoint.neighborLeft = ringProbePoints[prevIndex]
                ringProbePoints[prevIndex].neighborRight = ringProbePoint
            } else {
                ringProbePoint.neighborLeft = ringProbePoint
                ringProbePoint.neighborRight = ringProbePoint
            }
        }
    }
    
    // Note: This will not fixup the probe point neighbors.
    func meldReplaceProbeSegmentRangeWithTwoProbeSegments(startIndex: Int,
                                                      endIndex: Int,
                                                      _ ringProbeSegment1: RingProbeSegment,
                                                      _ ringProbeSegment2: RingProbeSegment) {
        
        if startIndex < 0 {
            return
        }
        if startIndex >= ringProbeSegmentCount {
            return
        }
        if endIndex < 0 {
            return
        }
        if endIndex >= ringProbeSegmentCount {
            return
        }
        
        if startIndex > endIndex {
            if endIndex == 0 {
                // In this case, we need to make an extra space...
                var index = ringProbeSegmentCount - 2
                while index >= 0 {
                    let index1 = index + 1
                    ringProbeSegments[index1] = ringProbeSegments[index]
                    ringProbeSegments[index1].ringIndex = index1
                    index -= 1
                }
            } else if endIndex > 1 {
                let shift = endIndex - 1
                var index = 2
                let ceiling = ringProbeSegmentCount - shift - (ringProbeSegmentCount - startIndex)
                while index < ceiling {
                    ringProbeSegments[index] = ringProbeSegments[index + shift]
                    ringProbeSegments[index].ringIndex = index
                    index += 1
                }
            }
            ringProbeSegmentCount -= ((ringProbeSegmentCount - startIndex) + endIndex - 1)
            ringProbeSegments[0] = ringProbeSegment1
            ringProbeSegment1.ringIndex = 0
            ringProbeSegments[1] = ringProbeSegment2
            ringProbeSegment2.ringIndex = 1
            if ringProbeSegmentCount > 2 {
                ringProbeSegment1.neighborRight = ringProbeSegment2
                ringProbeSegment2.neighborLeft = ringProbeSegment1
                ringProbeSegment2.neighborRight = ringProbeSegments[2]
                ringProbeSegments[2].neighborLeft = ringProbeSegment2
                let ringProbeSegmentCount1 = ringProbeSegmentCount - 1
                ringProbeSegments[ringProbeSegmentCount1].neighborRight = ringProbeSegment1
                ringProbeSegment1.neighborLeft = ringProbeSegments[ringProbeSegmentCount1]
            } else {
                ringProbeSegment1.neighborLeft = ringProbeSegment2
                ringProbeSegment1.neighborRight = ringProbeSegment2
                ringProbeSegment2.neighborLeft = ringProbeSegment1
                ringProbeSegment2.neighborRight = ringProbeSegment1
            }
        } else {
            if endIndex == startIndex {
                return
            } else {
                let shift = (endIndex - startIndex) - 1
                let ceiling = ringProbeSegmentCount - shift
                var index = startIndex + 2
                while index < ceiling {
                    ringProbeSegments[index] = ringProbeSegments[index + shift]
                    ringProbeSegments[index].ringIndex = index
                    index += 1
                }
                ringProbeSegmentCount -= shift
            }
            ringProbeSegments[startIndex] = ringProbeSegment1
            ringProbeSegment1.ringIndex = startIndex
            ringProbeSegments[startIndex + 1] = ringProbeSegment2
            ringProbeSegment2.ringIndex = startIndex + 1
            if ringProbeSegmentCount > 2 {
                ringProbeSegment1.neighborRight = ringProbeSegment2
                ringProbeSegment2.neighborLeft = ringProbeSegment1
                var nextIndex = startIndex + 2
                if nextIndex >= ringProbeSegmentCount {
                    nextIndex -= ringProbeSegmentCount
                }
                ringProbeSegment2.neighborRight = ringProbeSegments[nextIndex]
                ringProbeSegments[nextIndex].neighborLeft = ringProbeSegment2
                var prevIndex = startIndex - 1
                if prevIndex == -1 {
                    prevIndex = ringProbeSegmentCount - 1
                }
                ringProbeSegment1.neighborLeft = ringProbeSegments[prevIndex]
                ringProbeSegments[prevIndex].neighborRight = ringProbeSegment1
            } else {
                ringProbeSegment1.neighborLeft = ringProbeSegment2
                ringProbeSegment1.neighborRight = ringProbeSegment2
                ringProbeSegment2.neighborLeft = ringProbeSegment1
                ringProbeSegment2.neighborRight = ringProbeSegment1
            }
        }
    }
}
