//
//  RingProbeSegmentBucket.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/31/23.
//

import Foundation

final class RingProbeSegmentBucket {
    
    private class RingProbeSegmentBucketNode {
        var ringProbeSegments = [RingProbeSegment]()
        var ringProbeSegmentCount = 0
        
        func remove(_ ringProbeSegment: RingProbeSegment) {
            for checkIndex in 0..<ringProbeSegmentCount {
                if ringProbeSegments[checkIndex] === ringProbeSegment {
                    remove(checkIndex)
                    return
                }
            }
        }
        
        func remove(_ index: Int) {
            if index >= 0 && index < ringProbeSegmentCount {
                let ringProbeSegmentCount1 = ringProbeSegmentCount - 1
                var ringProbeSegmentIndex = index
                while ringProbeSegmentIndex < ringProbeSegmentCount1 {
                    ringProbeSegments[ringProbeSegmentIndex] = ringProbeSegments[ringProbeSegmentIndex + 1]
                    ringProbeSegmentIndex += 1
                }
                ringProbeSegmentCount -= 1
            }
        }
        
        func add(_ ringProbeSegment: RingProbeSegment) {
            while ringProbeSegments.count <= ringProbeSegmentCount {
                ringProbeSegments.append(ringProbeSegment)
            }
            ringProbeSegments[ringProbeSegmentCount] = ringProbeSegment
            ringProbeSegmentCount += 1
        }
    }
    
    private static let countH = 24
    private static let countV = 24
    
    private var grid = [[RingProbeSegmentBucketNode]]()
    private var gridX: [Float]
    private var gridY: [Float]
    
    private(set) var ringProbeSegments: [RingProbeSegment]
    private(set) var ringProbeSegmentCount = 0
    
    init() {
        
        gridX = [Float](repeating: 0.0, count: Self.countH)
        gridY = [Float](repeating: 0.0, count: Self.countV)
        ringProbeSegments = [RingProbeSegment]()
        
        var x = 0
        while x < Self.countH {
            var column = [RingProbeSegmentBucketNode]()
            var y = 0
            while y < Self.countV {
                let node = RingProbeSegmentBucketNode()
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
                grid[x][y].ringProbeSegmentCount = 0
                y += 1
            }
            x += 1
        }
        
        ringProbeSegmentCount = 0
    }
    
    func build(ringProbeSegments: [RingProbeSegment], ringProbeSegmentCount: Int) {
        
        reset()
        
        guard ringProbeSegmentCount > 0 else {
            return
        }
        
        let referenceRingProbeSegment = ringProbeSegments[0]
        
        var minX = min(referenceRingProbeSegment.x1, referenceRingProbeSegment.x2)
        var maxX = max(referenceRingProbeSegment.x1, referenceRingProbeSegment.x2)
        var minY = min(referenceRingProbeSegment.y1, referenceRingProbeSegment.y2)
        var maxY = max(referenceRingProbeSegment.y1, referenceRingProbeSegment.y2)
        
        var ringProbeSegmentIndex = 1
        while ringProbeSegmentIndex < ringProbeSegmentCount {
            let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
            minX = min(minX, ringProbeSegment.x1); minX = min(minX, ringProbeSegment.x2)
            maxX = max(maxX, ringProbeSegment.x1); maxX = max(maxX, ringProbeSegment.x2)
            minY = min(minY, ringProbeSegment.y1); minY = min(minY, ringProbeSegment.y2)
            maxY = max(maxY, ringProbeSegment.y1); maxY = max(maxY, ringProbeSegment.y2)
            ringProbeSegmentIndex += 1
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
        
        for ringProbeSegmentIndex in 0..<ringProbeSegmentCount {
            let ringProbeSegment = ringProbeSegments[ringProbeSegmentIndex]
            
            let _minX = min(ringProbeSegment.x1, ringProbeSegment.x2)
            let _maxX = max(ringProbeSegment.x1, ringProbeSegment.x2)
            let _minY = min(ringProbeSegment.y1, ringProbeSegment.y2)
            let _maxY = max(ringProbeSegment.y1, ringProbeSegment.y2)
            
            let lowerBoundX = lowerBoundX(value: _minX)
            let upperBoundX = upperBoundX(value: _maxX)
            let lowerBoundY = lowerBoundY(value: _minY)
            let upperBoundY = upperBoundY(value: _maxY)
            
            x = lowerBoundX
            while x <= upperBoundX {
                y = lowerBoundY
                while y <= upperBoundY {
                    grid[x][y].add(ringProbeSegment)
                    y += 1
                }
                x += 1
            }
        }
    }
    
    func remove(ringProbeSegment: RingProbeSegment) {
        let _minX = min(ringProbeSegment.x1, ringProbeSegment.x2)
        let _maxX = max(ringProbeSegment.x1, ringProbeSegment.x2)
        let _minY = min(ringProbeSegment.y1, ringProbeSegment.y2)
        let _maxY = max(ringProbeSegment.y1, ringProbeSegment.y2)
        
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
                grid[x][y].remove(ringProbeSegment)
                y += 1
            }
            x += 1
        }
    }
    
    func add(ringProbeSegment: RingProbeSegment) {
        
        let _minX = min(ringProbeSegment.x1, ringProbeSegment.x2)
        let _maxX = max(ringProbeSegment.x1, ringProbeSegment.x2)
        let _minY = min(ringProbeSegment.y1, ringProbeSegment.y2)
        let _maxY = max(ringProbeSegment.y1, ringProbeSegment.y2)
        
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
                grid[x][y].add(ringProbeSegment)
                y += 1
            }
            x += 1
        }
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
    
    func query(minX: Float, maxX: Float, minY: Float, maxY: Float) {
        
        ringProbeSegmentCount = 0
        
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
                for ringProbeSegmentIndex in 0..<grid[x][y].ringProbeSegmentCount {
                    grid[x][y].ringProbeSegments[ringProbeSegmentIndex].isBucketed = false
                }
                y += 1
            }
            x += 1
        }
        
        x = lowerBoundX
        while x <= upperBoundX {
            y = lowerBoundY
            while y <= upperBoundY {
                for ringProbeSegmentIndex in 0..<grid[x][y].ringProbeSegmentCount {
                  
                    let ringProbeSegment = grid[x][y].ringProbeSegments[ringProbeSegmentIndex]
                    
                    if ringProbeSegment.isBucketed == false {
                        ringProbeSegment.isBucketed = true
                        
                        while ringProbeSegments.count <= ringProbeSegmentCount {
                            ringProbeSegments.append(ringProbeSegment)
                        }
                        ringProbeSegments[ringProbeSegmentCount] = ringProbeSegment
                        ringProbeSegmentCount += 1
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
