//
//  RingPointInsidePolygonBucket.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/26/23.
//

import Foundation

final class RingPointInsidePolygonBucket {
    
    private class RingPointInsidePolygonBucketNode {
        
        var ringLineSegments = [RingLineSegment]()
        var ringLineSegmentCount = 0
        
        func remove(_ ringLineSegment: RingLineSegment) {
            for checkIndex in 0..<ringLineSegmentCount {
                if ringLineSegments[checkIndex] === ringLineSegment {
                    remove(checkIndex)
                    return
                }
            }
        }
        
        func remove(_ index: Int) {
            if index >= 0 && index < ringLineSegmentCount {
                let ringLineSegmentCount1 = ringLineSegmentCount - 1
                var ringLineSegmentIndex = index
                while ringLineSegmentIndex < ringLineSegmentCount1 {
                    ringLineSegments[ringLineSegmentIndex] = ringLineSegments[ringLineSegmentIndex + 1]
                    ringLineSegmentIndex += 1
                }
                ringLineSegmentCount -= 1
            }
        }
        
        func add(_ ringLineSegment: RingLineSegment) {
            while ringLineSegments.count <= ringLineSegmentCount {
                ringLineSegments.append(ringLineSegment)
            }
            ringLineSegments[ringLineSegmentCount] = ringLineSegment
            ringLineSegmentCount += 1
        }
        
    }
    
    private static let countH = 24
    
    private var nodes = [RingPointInsidePolygonBucketNode]()
    private var gridX: [Float]
    
    init() {
        gridX = [Float](repeating: 0.0, count: Self.countH)
        var x = 0
        while x < Self.countH {
            let node = RingPointInsidePolygonBucketNode()
            nodes.append(node)
            x += 1
        }
    }
    
    func reset() {
        var x = 0
        while x < Self.countH {
            nodes[x].ringLineSegmentCount = 0
            x += 1
        }
    }
    
    func build(ringLineSegments: [RingLineSegment], ringLineSegmentCount: Int) {
        
        reset()
        
        guard ringLineSegmentCount > 0 else {
            return
        }
        
        let referenceRingLineSegment = ringLineSegments[0]
        
        var minX = min(referenceRingLineSegment.x1, referenceRingLineSegment.x2)
        var maxX = max(referenceRingLineSegment.x1, referenceRingLineSegment.x2)
        
        var ringLineSegmentIndex = 1
        while ringLineSegmentIndex < ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            
            minX = min(minX, ringLineSegment.x1); minX = min(minX, ringLineSegment.x2)
            maxX = max(maxX, ringLineSegment.x1); maxX = max(maxX, ringLineSegment.x2)
            
            ringLineSegmentIndex += 1
        }
        
        minX -= 1.0
        maxX += 1.0
        
        var x = 0
        while x < Self.countH {
            let percent = Float(x) / Float(Self.countH - 1)
            gridX[x] = minX + (maxX - minX) * percent
            x += 1
        }
        
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            
            let _minX = min(ringLineSegment.x1, ringLineSegment.x2)
            let _maxX = max(ringLineSegment.x1, ringLineSegment.x2)
            
            let lowerBoundX = lowerBoundX(value: _minX)
            let upperBoundX = upperBoundX(value: _maxX)
            
            x = lowerBoundX
            while x <= upperBoundX {
                nodes[x].add(ringLineSegment)
                x += 1
            }
        }
    }
    
    func query(x: Float, y: Float) -> Bool {
        var result = false
        let indexX = lowerBoundX(value: x)
        if indexX < Self.countH {
            for ringLineSegmentIndex in 0..<nodes[indexX].ringLineSegmentCount {
                let ringLineSegment = nodes[indexX].ringLineSegments[ringLineSegmentIndex]
                
                let x1: Float
                let y1: Float
                let x2: Float
                let y2: Float
                if ringLineSegment.x1 < ringLineSegment.x2 {
                    x1 = ringLineSegment.x1
                    y1 = ringLineSegment.y1
                    x2 = ringLineSegment.x2
                    y2 = ringLineSegment.y2
                } else {
                    x1 = ringLineSegment.x2
                    y1 = ringLineSegment.y2
                    x2 = ringLineSegment.x1
                    y2 = ringLineSegment.y1
                }
                if x > x1 && x <= x2 {
                    if (x - x1) * (y2 - y1) - (y - y1) * (x2 - x1) < 0.0 {
                        result = !result
                    }
                }
            }
        }
        return result
    }
    
    private func lowerBoundX(value: Float) -> Int {
        var start = 0
        var end = Self.countH
        while start != end {
            let mid = (start + end) >> 1
            if value > gridX[mid] {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
    }
    
    private func upperBoundX(value: Float) -> Int {
        var start = 0
        var end = Self.countH
        while start != end {
            let mid = (start + end) >> 1
            if value >= gridX[mid] {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return min(start, Self.countH - 1)
    }
}
