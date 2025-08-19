//
//  LineSegmentBucket.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/31/23.
//

import Foundation

final class RingLineSegmentBucket {
    
    private class RingLineSegmentBucketNode {
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
    private static let countV = 24
    
    private var grid = [[RingLineSegmentBucketNode]]()
    private var gridX: [Float]
    private var gridY: [Float]
    
    private(set) var ringLineSegments: [RingLineSegment]
    private(set) var ringLineSegmentCount = 0
    
    init() {
        
        gridX = [Float](repeating: 0.0, count: Self.countH)
        gridY = [Float](repeating: 0.0, count: Self.countV)
        ringLineSegments = [RingLineSegment]()
        
        var x = 0
        while x < Self.countH {
            var column = [RingLineSegmentBucketNode]()
            var y = 0
            while y < Self.countV {
                let node = RingLineSegmentBucketNode()
                column.append(node)
                y += 1
            }
            grid.append(column)
            x += 1
        }
    }
    
    func reset() {
        var x = 0
        var y = 0
        while x < Self.countH {
            y = 0
            while y < Self.countV {
                grid[x][y].ringLineSegmentCount = 0
                y += 1
            }
            x += 1
        }
        
        ringLineSegmentCount = 0
    }
    
    func build(ringLineSegments: [RingLineSegment], ringLineSegmentCount: Int) {
        
        reset()
        
        guard ringLineSegmentCount > 0 else {
            return
        }
        
        let referenceRingLineSegment = ringLineSegments[0]
        
        var minX = min(referenceRingLineSegment.x1, referenceRingLineSegment.x2)
        var maxX = max(referenceRingLineSegment.x1, referenceRingLineSegment.x2)
        var minY = min(referenceRingLineSegment.y1, referenceRingLineSegment.y2)
        var maxY = max(referenceRingLineSegment.y1, referenceRingLineSegment.y2)
        
        var ringLineSegmentIndex = 1
        while ringLineSegmentIndex < ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            minX = min(minX, ringLineSegment.x1); minX = min(minX, ringLineSegment.x2)
            maxX = max(maxX, ringLineSegment.x1); maxX = max(maxX, ringLineSegment.x2)
            minY = min(minY, ringLineSegment.y1); minY = min(minY, ringLineSegment.y2)
            maxY = max(maxY, ringLineSegment.y1); maxY = max(maxY, ringLineSegment.y2)
            ringLineSegmentIndex += 1
        }
        
        minX -= 32.0
        maxX += 32.0
        minY -= 32.0
        maxY += 32.0
        
        var x = 0
        while x < Self.countH {
            let percent = Float(x) / Float(Self.countH - 1)
            gridX[x] = minX + (maxX - minX) * percent
            x += 1
        }
        
        var y = 0
        while y < Self.countV {
            let percent = Float(y) / Float(Self.countV - 1)
            gridY[y] = minY + (maxY - minY) * percent
            y += 1
        }
        
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            
            let _minX = min(ringLineSegment.x1, ringLineSegment.x2)
            let _maxX = max(ringLineSegment.x1, ringLineSegment.x2)
            let _minY = min(ringLineSegment.y1, ringLineSegment.y2)
            let _maxY = max(ringLineSegment.y1, ringLineSegment.y2)
            
            let lowerBoundX = lowerBoundX(value: _minX)
            let upperBoundX = upperBoundX(value: _maxX)
            let lowerBoundY = lowerBoundY(value: _minY)
            let upperBoundY = upperBoundY(value: _maxY)
            
            x = lowerBoundX
            while x <= upperBoundX {
                y = lowerBoundY
                while y <= upperBoundY {
                    grid[x][y].add(ringLineSegment)
                    y += 1
                }
                x += 1
            }
        }
    }
    
    func remove(ringLineSegment: RingLineSegment) {
        let _minX = min(ringLineSegment.x1, ringLineSegment.x2)
        let _maxX = max(ringLineSegment.x1, ringLineSegment.x2)
        let _minY = min(ringLineSegment.y1, ringLineSegment.y2)
        let _maxY = max(ringLineSegment.y1, ringLineSegment.y2)
        
        let lowerBoundX = lowerBoundX(value: _minX)
        let upperBoundX = upperBoundX(value: _maxX)
        let lowerBoundY = lowerBoundY(value: _minY)
        let upperBoundY = upperBoundY(value: _maxY)
        
        var x = 0
        var y = 0
        x = lowerBoundX
        while x <= upperBoundX {
            y = lowerBoundY
            while y <= upperBoundY {
                grid[x][y].remove(ringLineSegment)
                y += 1
            }
            x += 1
        }
    }
    
    func add(ringLineSegment: RingLineSegment) {
            
        let _minX = min(ringLineSegment.x1, ringLineSegment.x2)
        let _maxX = max(ringLineSegment.x1, ringLineSegment.x2)
        let _minY = min(ringLineSegment.y1, ringLineSegment.y2)
        let _maxY = max(ringLineSegment.y1, ringLineSegment.y2)
        
        let lowerBoundX = lowerBoundX(value: _minX)
        let upperBoundX = upperBoundX(value: _maxX)
        let lowerBoundY = lowerBoundY(value: _minY)
        let upperBoundY = upperBoundY(value: _maxY)
        
        var x = 0
        var y = 0
        x = lowerBoundX
        while x <= upperBoundX {
            y = lowerBoundY
            while y <= upperBoundY {
                grid[x][y].add(ringLineSegment)
                y += 1
            }
            x += 1
        }
    }
    
    func query(ringLineSegment: RingLineSegment) {
        let x1 = ringLineSegment.x1
        let y1 = ringLineSegment.y1
        let x2 = ringLineSegment.x2
        let y2 = ringLineSegment.y2
        query(minX: min(x1, x2),
              maxX: max(x1, x2),
              minY: min(y1, y2),
              maxY: max(y1, y2))
    }
    
    func query(ringLineSegment: RingLineSegment, padding: Float) {
        let x1 = ringLineSegment.x1
        let y1 = ringLineSegment.y1
        let x2 = ringLineSegment.x2
        let y2 = ringLineSegment.y2
        query(minX: min(x1, x2) - padding,
              maxX: max(x1, x2) + padding,
              minY: min(y1, y2) - padding,
              maxY: max(y1, y2) + padding)
    }
    
    func query(ringProbeSegment: RingProbeSegment) {
        let x1 = ringProbeSegment.x1
        let y1 = ringProbeSegment.y1
        let x2 = ringProbeSegment.x2
        let y2 = ringProbeSegment.y2
        query(minX: min(x1, x2),
              maxX: max(x1, x2),
              minY: min(y1, y2),
              maxY: max(y1, y2))
    }
    
    func query(ringProbeSegment: RingProbeSegment, padding: Float) {
        let x1 = ringProbeSegment.x1
        let y1 = ringProbeSegment.y1
        let x2 = ringProbeSegment.x2
        let y2 = ringProbeSegment.y2
        query(minX: min(x1, x2) - padding,
              maxX: max(x1, x2) + padding,
              minY: min(y1, y2) - padding,
              maxY: max(y1, y2) + padding)
    }
    
    func query(minX: Float, maxX: Float, minY: Float, maxY: Float) {
        
        ringLineSegmentCount = 0
        
        let lowerBoundX = lowerBoundX(value: minX)
        var upperBoundX = upperBoundX(value: maxX)
        let lowerBoundY = lowerBoundY(value: minY)
        var upperBoundY = upperBoundY(value: maxY)
        
        if upperBoundX >= Self.countH {
            upperBoundX = Self.countH - 1
        }
        
        if upperBoundY >= Self.countV {
            upperBoundY = Self.countV - 1
        }
        
        var x = 0
        var y = 0
        
        x = lowerBoundX
        while x <= upperBoundX {
            y = lowerBoundY
            while y <= upperBoundY {
                for ringLineSegmentIndex in 0..<grid[x][y].ringLineSegmentCount {
                    grid[x][y].ringLineSegments[ringLineSegmentIndex].isBucketed = false
                }
                y += 1
            }
            x += 1
        }
        
        x = lowerBoundX
        while x <= upperBoundX {
            y = lowerBoundY
            while y <= upperBoundY {
                for ringLineSegmentIndex in 0..<grid[x][y].ringLineSegmentCount {
                    let ringLineSegment = grid[x][y].ringLineSegments[ringLineSegmentIndex]
                    if ringLineSegment.isBucketed == false {
                        ringLineSegment.isBucketed = true
                        
                        while ringLineSegments.count <= ringLineSegmentCount {
                            ringLineSegments.append(ringLineSegment)
                        }
                        ringLineSegments[ringLineSegmentCount] = ringLineSegment
                        ringLineSegmentCount += 1
                    }
                }
                y += 1
            }
            x += 1
        }
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
    
    func lowerBoundY(value: Float) -> Int {
        var start = 0
        var end = Self.countV
        while start != end {
            let mid = (start + end) >> 1
            if value > gridY[mid] {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return start
        
    }
    
    func upperBoundY(value: Float) -> Int {
        var start = 0
        var end = Self.countV
        while start != end {
            let mid = (start + end) >> 1
            if value >= gridY[mid] {
                start = mid + 1
            } else {
                end = mid
            }
        }
        return min(start, Self.countV - 1)
    }
}
