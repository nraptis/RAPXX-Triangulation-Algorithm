//
//  Ring+Neighbors.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/6/24.
//

import Foundation

extension Ring {
    
    func fixRingPointAndLineSegmentAdjacency() {
        calculateRingPointIndices()
        calculateRingPointNeighbors()
        calculateLineSegmentIndices()
        calculateLineSegmentNeighbors()
        calculateLineSegmentPointNeighbors()
        calculateRingPointLineSegmentNeighbors()
    }
    
    func fixProbePointAndProbeSegmentAdjacency() {
        calculateRingProbePointIndices()
        calculateProbePointNeighbors()
        calculateProbeSegmentIndices()
        calculateProbeSegmentNeighbors()
        calculateProbeSegmentPointNeighbors()
        calculateProbePointProbeSegmentNeighbors()
    }
    
    func calculateRingPointNeighborsAndIndices() {
        calculateRingPointIndices()
        calculateRingPointNeighbors()
    }
    
    func calculateRingPointIndices() {
        for ringPointIndex in 0..<ringPointCount {
            ringPoints[ringPointIndex].ringIndex = ringPointIndex
        }
    }
    
    func calculateRingProbePointIndices() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            ringProbePoints[ringProbePointIndex].ringIndex = ringProbePointIndex
        }
    }
    
    func calculateLineSegmentIndices() {
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            ringLineSegments[ringLineSegmentIndex].ringIndex = ringLineSegmentIndex
        }
    }
    
    func calculateProbeSegmentIndices() {
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            ringProbeSegments[ringProbeSegmentIndex].ringIndex = ringProbeSegmentIndex
        }
    }
    
    func calculateRingPointNeighbors() {
        if ringPointCount > 2 {
            var ringPointIndex = ringPointCount - 1
            var ringPointIndexRight = 0
            var ringPointIndexLeft = ringPointIndex - 1
            while ringPointIndexRight < ringPointCount {
                let ringPoint = ringPoints[ringPointIndex]
                ringPoint.neighborRight = ringPoints[ringPointIndexRight]
                ringPoint.neighborLeft = ringPoints[ringPointIndexLeft]
                ringPointIndexLeft = ringPointIndex
                ringPointIndex = ringPointIndexRight
                ringPointIndexRight += 1
            }
        } else if ringPointCount == 2 {
            ringPoints[0].neighborLeft = ringPoints[1]
            ringPoints[0].neighborRight = ringPoints[1]
            ringPoints[1].neighborLeft = ringPoints[0]
            ringPoints[1].neighborRight = ringPoints[0]
        } else if ringPointCount == 1 {
            ringPoints[0].neighborLeft = ringPoints[0]
            ringPoints[0].neighborRight = ringPoints[0]
        }
    }
    
    func calculateProbePointNeighbors() {
        if ringProbePointCount > 2 {
            var ringProbePointIndex = ringProbePointCount - 1
            var ringProbePointIndexRight = 0
            var ringProbePointIndexLeft = ringProbePointIndex - 1
            while ringProbePointIndexRight < ringProbePointCount {
                let ringProbePoint = ringProbePoints[ringProbePointIndex]
                ringProbePoint.neighborRight = ringProbePoints[ringProbePointIndexRight]
                ringProbePoint.neighborLeft = ringProbePoints[ringProbePointIndexLeft]
                ringProbePointIndexLeft = ringProbePointIndex
                ringProbePointIndex = ringProbePointIndexRight
                ringProbePointIndexRight += 1
            }
        } else if ringProbePointCount == 2 {
            ringProbePoints[0].neighborLeft = ringProbePoints[1]
            ringProbePoints[0].neighborRight = ringProbePoints[1]
            ringProbePoints[1].neighborLeft = ringProbePoints[0]
            ringProbePoints[1].neighborRight = ringProbePoints[0]
        } else if ringProbePointCount == 1 {
            ringProbePoints[0].neighborLeft = ringProbePoints[0]
            ringProbePoints[0].neighborRight = ringProbePoints[0]
        }
    }
    
    func calculateLineSegmentNeighbors() {
        if ringLineSegmentCount > 2 {
            var ringLineSegmentIndex = ringLineSegmentCount - 1
            var ringLineSegmentIndexRight = 0
            var ringLineSegmentIndexLeft = ringLineSegmentIndex - 1
            while ringLineSegmentIndexRight < ringLineSegmentCount {
                let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
                ringLineSegment.neighborRight = ringLineSegments[ringLineSegmentIndexRight]
                ringLineSegment.neighborLeft = ringLineSegments[ringLineSegmentIndexLeft]
                ringLineSegmentIndexLeft = ringLineSegmentIndex
                ringLineSegmentIndex = ringLineSegmentIndexRight
                ringLineSegmentIndexRight += 1
            }
        } else if ringLineSegmentCount == 2 {
            ringLineSegments[0].neighborLeft = ringLineSegments[1]
            ringLineSegments[0].neighborRight = ringLineSegments[1]
            ringLineSegments[1].neighborLeft = ringLineSegments[0]
            ringLineSegments[1].neighborRight = ringLineSegments[0]
        } else if ringLineSegmentCount == 1 {
            ringLineSegments[0].neighborLeft = ringLineSegments[0]
            ringLineSegments[0].neighborRight = ringLineSegments[0]
        }
    }
    
    func calculateProbeSegmentNeighbors() {
        if ringProbeSegmentCount > 2 {
            var ringProbeSegmentIndex = ringProbeSegmentCount - 1
            var ringProbeSegmentIndexRight = 0
            var ringProbeSegmentIndexLeft = ringProbeSegmentIndex - 1
            while ringProbeSegmentIndexRight < ringProbeSegmentCount {
                let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
                ringProbeSegment.neighborRight = ringProbeSegments[ringProbeSegmentIndexRight]
                ringProbeSegment.neighborLeft = ringProbeSegments[ringProbeSegmentIndexLeft]
                ringProbeSegmentIndexLeft = ringProbeSegmentIndex
                ringProbeSegmentIndex = ringProbeSegmentIndexRight
                ringProbeSegmentIndexRight += 1
            }
        } else if ringProbeSegmentCount == 2 {
            ringProbeSegments[0].neighborLeft = ringProbeSegments[1]
            ringProbeSegments[0].neighborRight = ringProbeSegments[1]
            ringProbeSegments[1].neighborLeft = ringProbeSegments[0]
            ringProbeSegments[1].neighborRight = ringProbeSegments[0]
        } else if ringProbeSegmentCount == 1 {
            ringProbeSegments[0].neighborLeft = ringProbeSegments[0]
            ringProbeSegments[0].neighborRight = ringProbeSegments[0]
        }
    }
    
    func calculateLineSegmentPointNeighbors() {
        if ringPointCount > 0 {
            
            guard ringLineSegmentCount == ringPointCount else {
                return
            }
            
            var ringLineSegmentIndex1 = 0
            var ringLineSegmentIndex2 = 1
            while ringLineSegmentIndex1 < ringLineSegmentCount {
                let ringLineSegment = ringLineSegments[ringLineSegmentIndex1]
                ringLineSegment.ringPointLeft = ringPoints[ringLineSegmentIndex1]
                ringLineSegment.ringPointRight = ringPoints[ringLineSegmentIndex2]
                ringLineSegmentIndex1 += 1
                ringLineSegmentIndex2 += 1
                if ringLineSegmentIndex2 == ringLineSegmentCount {
                    ringLineSegmentIndex2 = 0
                }
            }
        }
    }
    
    func calculateProbeSegmentPointNeighbors() {
        if ringProbePointCount > 0 {
                    
            guard ringProbeSegmentCount == ringProbePointCount else {
                return
            }
            
            var ringProbeSegmentIndex1 = 0
            var ringProbeSegmentIndex2 = 1
            while ringProbeSegmentIndex1 < ringProbeSegmentCount {
                let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex1]
                ringProbeSegment.ringProbePointLeft = ringProbePoints[ringProbeSegmentIndex1]
                ringProbeSegment.ringProbePointRight = ringProbePoints[ringProbeSegmentIndex2]
                ringProbeSegmentIndex1 += 1
                ringProbeSegmentIndex2 += 1
                if ringProbeSegmentIndex2 == ringProbeSegmentCount {
                    ringProbeSegmentIndex2 = 0
                }
            }
        }
    }
    
    func calculateRingPointLineSegmentNeighbors() {
        var ringPointIndex = 0
        while ringPointIndex < ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            var ringLineSegmentIndexLeft = ringPointIndex - 1
            if ringLineSegmentIndexLeft == -1 {
                ringLineSegmentIndexLeft = ringLineSegmentCount - 1
            }
            var ringLineSegmentIndexRight = ringLineSegmentIndexLeft + 1
            if ringLineSegmentIndexRight == ringLineSegmentCount {
                ringLineSegmentIndexRight = 0
            }
            
            ringPoint.ringLineSegmentLeft = ringLineSegments[ringLineSegmentIndexLeft]
            ringPoint.ringLineSegmentRight = ringLineSegments[ringLineSegmentIndexRight]
            
            ringPointIndex += 1
        }
    }
    
    func calculateProbePointProbeSegmentNeighbors() {
        var ringProbePointIndex = 0
        while ringProbePointIndex < ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            var ringProbeSegmentIndexLeft = ringProbePointIndex - 1
            if ringProbeSegmentIndexLeft == -1 {
                ringProbeSegmentIndexLeft = ringProbeSegmentCount - 1
            }
            var ringProbeSegmentIndexRight = ringProbeSegmentIndexLeft + 1
            if ringProbeSegmentIndexRight == ringProbeSegmentCount {
                ringProbeSegmentIndexRight = 0
            }
            
            ringProbePoint.ringProbeSegmentLeft = ringProbeSegments[ringProbeSegmentIndexLeft]
            ringProbePoint.ringProbeSegmentRight = ringProbeSegments[ringProbeSegmentIndexRight]
            
            ringProbePointIndex += 1
        }
    }
}
