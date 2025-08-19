//
//  FastTriangulator.swift
//  RAPXX
//
//  Created by Nick Raptis on 3/12/24.
//

import Foundation

class FastTriangulator {
    
    typealias Point = Math.Point
    
    struct FastTriangulatorGridNode {
        
        var x = Float(0.0)
        var y = Float(0.0)
        
        var edgeU = false
        var edgeR = false
        var edgeD = false
        var edgeL = false
        
        var edgePointBaseU: Point = Point.zero
        var edgePointBaseR: Point = Point.zero
        var edgePointBaseD: Point = Point.zero
        var edgePointBaseL: Point = Point.zero
        
        //Is it inside the border outline?
        var inside: Bool = false
    }
    
    nonisolated(unsafe) static let shared = FastTriangulator()
    
    private init() {
        
    }
    
    var grid = [[FastTriangulatorGridNode]]()
    
    func triangulate(polyMeshTriangleData: PolyMeshTriangleData,
                     ringLineSegmentBucket: RingLineSegmentBucket,
                     ringPointInsidePolygonBucket: RingPointInsidePolygonBucket,
                     minX: Float,
                     minY: Float,
                     maxX: Float,
                     maxY: Float,
                     sweepLineCountH: Int,
                     sweepLineCountV: Int) {
        
        let rangeX = (maxX - minX)
        let rangeY = (maxY - minY)
        
        while grid.count < sweepLineCountH {
            grid.append([FastTriangulatorGridNode]())
        }
        for gridIndex in 0..<grid.count {
            while grid[gridIndex].count < sweepLineCountV {
                grid[gridIndex].append(FastTriangulatorGridNode())
            }
        }
        
        for i in 0..<sweepLineCountH {
            let percentX = Float(i) / Float(sweepLineCountH - 1)
            let x = minX + rangeX * percentX
            for n in 0..<sweepLineCountV {
                let percentY = Float(n) / Float(sweepLineCountV - 1)
                let y = minY + rangeY * percentY
                grid[i][n].x = x
                grid[i][n].y = y
                grid[i][n].inside = ringPointInsidePolygonBucket.query(x: x, y: y)
            }
        }
        
        //Reset the border points.
        for i in 0..<sweepLineCountH {
            for n in 0..<sweepLineCountV {
                grid[i][n].edgeU = false
                grid[i][n].edgeR = false
                grid[i][n].edgeD = false
                grid[i][n].edgeL = false
            }
        }
        
        //Find all of the border points for the grid.
        for i in 1..<sweepLineCountH {
            for n in 1..<sweepLineCountV {
                let top = n - 1
                let left = i - 1
                let right = i
                let bottom = n
                if grid[left][bottom].inside == true && grid[left][top].inside == false {
                    grid[left][bottom].edgeU = true
                    grid[left][bottom].edgePointBaseU = closestBorderPointUp(x: grid[left][bottom].x,
                                                                             y: grid[left][bottom].y,
                                                                             ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[right][bottom].inside == true && grid[right][top].inside == false {
                    grid[right][bottom].edgeU = true
                    grid[right][bottom].edgePointBaseU = closestBorderPointUp(x: grid[right][bottom].x,
                                                                              y: grid[right][bottom].y,
                                                                              ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[left][bottom].inside == false && grid[left][top].inside == true {
                    grid[left][top].edgeD = true
                    grid[left][top].edgePointBaseD = closestBorderPointDown(x: grid[left][top].x,
                                                                            y: grid[left][top].y,
                                                                            ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[right][bottom].inside == false && grid[right][top].inside == true {
                    grid[right][top].edgeD = true
                    grid[right][top].edgePointBaseD = closestBorderPointDown(x: grid[right][top].x,
                                                                             y: grid[right][top].y,
                                                                             ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[left][top].inside == false && grid[right][top].inside == true {
                    grid[right][top].edgeL = true
                    grid[right][top].edgePointBaseL = closestBorderPointLeft(x: grid[right][top].x,
                                                                             y: grid[right][top].y,
                                                                             ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[left][bottom].inside == false && grid[right][bottom].inside == true {
                    grid[right][bottom].edgeL = true
                    grid[right][bottom].edgePointBaseL = closestBorderPointLeft(x: grid[right][bottom].x,
                                                                                y: grid[right][bottom].y,
                                                                                ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[left][top].inside == true && grid[right][top].inside == false {
                    grid[left][top].edgeR = true
                    grid[left][top].edgePointBaseR = closestBorderPointRight(x: grid[left][top].x,
                                                                             y: grid[left][top].y,
                                                                             ringLineSegmentBucket: ringLineSegmentBucket)
                }
                if grid[left][bottom].inside == true && grid[right][bottom].inside == false {
                    grid[left][bottom].edgeR = true
                    grid[left][bottom].edgePointBaseR = closestBorderPointRight(x: grid[left][bottom].x,
                                                                                y: grid[left][bottom].y,
                                                                                ringLineSegmentBucket: ringLineSegmentBucket)
                }
            }
        }
        
        polyMeshTriangleData.reset()
        
        //Build the mesh using level 6 magic.
        for i in 1..<sweepLineCountH {
            for n in 1..<sweepLineCountV {
                let top = n - 1
                let left = i - 1
                let right = i
                let bottom = n
                
                let U_L = grid[left][top]
                let D_L = grid[left][bottom]
                let U_R = grid[right][top]
                let D_R = grid[right][bottom]
                
                //All 4 tri's IN
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == true) && (D_R.inside == true) {
                    polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                             x2: D_L.x, y2: D_L.y,
                                             x3: U_R.x, y3: U_R.y)
                    
                    polyMeshTriangleData.add(x1: D_L.x, y1: D_L.y,
                                             x2: U_R.x, y2: U_R.y,
                                             x3: D_R.x, y3: D_R.y)
                }
                
                //Upper-Left in (Corner)
                if (U_L.inside == true) && (U_R.inside == false) && (D_L.inside == false) && (D_R.inside == false) {
                    if U_L.edgeR && U_L.edgeD {
                        polyMeshTriangleData.add(x1: U_L.edgePointBaseD.x,
                                                 y1: U_L.edgePointBaseD.y,
                                                 x2: U_L.x, y2: U_L.y,
                                                 x3: U_L.edgePointBaseR.x,
                                                 y3: U_L.edgePointBaseR.y)
                    }
                }
                
                //Upper-Right in (Corner)
                if (U_L.inside == false) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == false) {
                    if U_R.edgeL && U_R.edgeD {
                        polyMeshTriangleData.add(x1: U_R.edgePointBaseD.x,
                                                 y1: U_R.edgePointBaseD.y,
                                                 x2: U_R.edgePointBaseL.x,
                                                 y2: U_R.edgePointBaseL.y,
                                                 x3: U_R.x, y3: U_R.y)
                    }
                }
                
                //Bottom-Left in (Corner)
                if (U_L.inside == false) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == false) {
                    if D_L.edgeR && D_L.edgeU {
                        polyMeshTriangleData.add(x1: D_L.x, y1: D_L.y,
                                                 x2: D_L.edgePointBaseU.x,
                                                 y2: D_L.edgePointBaseU.y,
                                                 x3: D_L.edgePointBaseR.x,
                                                 y3: D_L.edgePointBaseR.y)
                    }
                }
                
                //Bottom-Right in (Corner)
                if (U_L.inside == false) && (U_R.inside == false) && (D_L.inside == false) && (D_R.inside == true) {
                    if D_R.edgeL && D_R.edgeU {
                        polyMeshTriangleData.add(x1: D_R.edgePointBaseL.x,
                                                 y1: D_R.edgePointBaseL.y,
                                                 x2: D_R.edgePointBaseU.x,
                                                 y2: D_R.edgePointBaseU.y,
                                                 x3: D_R.x, y3: D_R.y)
                    }
                }
                
                //Up in (Side)
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == false) {
                    if U_L.edgeD && U_R.edgeD {
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: U_L.edgePointBaseD.x,
                                                 y2: U_L.edgePointBaseD.y,
                                                 x3: U_R.edgePointBaseD.x,
                                                 y3: U_R.edgePointBaseD.y)
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: U_R.x, y2: U_R.y,
                                                 x3: U_R.edgePointBaseD.x,
                                                 y3: U_R.edgePointBaseD.y)
                    }
                }
                
                //Right in (Side)
                if (U_L.inside == false) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == true) {
                    if U_R.edgeL && D_R.edgeL {
                        polyMeshTriangleData.add(x1: U_R.edgePointBaseL.x,
                                                 y1: U_R.edgePointBaseL.y,
                                                 x2: D_R.edgePointBaseL.x,
                                                 y2: D_R.edgePointBaseL.y,
                                                 x3: U_R.x, y3: U_R.y)
                        polyMeshTriangleData.add(x1: D_R.edgePointBaseL.x,
                                                 y1: D_R.edgePointBaseL.y,
                                                 x2: U_R.x, y2: U_R.y,
                                                 x3: D_R.x, y3: D_R.y)
                    }
                }
                
                //Down in (Side)
                if (U_L.inside == false) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == true) {
                    if D_L.edgeU && D_R.edgeU {
                        polyMeshTriangleData.add(x1: D_L.edgePointBaseU.x,
                                                 y1: D_L.edgePointBaseU.y,
                                                 x2: D_L.x, y2: D_L.y,
                                                 x3: D_R.edgePointBaseU.x,
                                                 y3: D_R.edgePointBaseU.y)
                        polyMeshTriangleData.add(x1: D_L.x, y1: D_L.y,
                                                 x2: D_R.edgePointBaseU.x,
                                                 y2: D_R.edgePointBaseU.y,
                                                 x3: D_R.x, y3: D_R.y)
                    }
                }
                
                //Left in (Side)
                if (U_L.inside == true) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == false) {
                    if U_L.edgeR && D_L.edgeR {
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: U_L.edgePointBaseR.x,
                                                 y2: U_L.edgePointBaseR.y,
                                                 x3: D_L.edgePointBaseR.x,
                                                 y3: D_L.edgePointBaseR.y)
                        polyMeshTriangleData.add(x1: D_L.edgePointBaseR.x,
                                                 y1: D_L.edgePointBaseR.y,
                                                 x2: U_L.x, y2: U_L.y,
                                                 x3: D_L.x, y3: D_L.y)
                    }
                }
                
                //Upper-Left out (Elbow)
                if (U_L.inside == false) && (U_R.inside == true) && (D_L.inside == true) && (D_R.inside == true) {
                    if U_R.edgeL && D_L.edgeU {
                        polyMeshTriangleData.add(x1: D_L.edgePointBaseU.x,
                                                 y1: D_L.edgePointBaseU.y,
                                                 x2: U_R.edgePointBaseL.x,
                                                 y2: U_R.edgePointBaseL.y,
                                                 x3: D_R.x, y3: D_R.y)
                        polyMeshTriangleData.add(x1: D_L.edgePointBaseU.x,
                                                 y1: D_L.edgePointBaseU.y,
                                                 x2: D_L.x, y2: D_L.y,
                                                 x3: D_R.x, y3: D_R.y)
                        polyMeshTriangleData.add(x1: U_R.edgePointBaseL.x,
                                                 y1: U_R.edgePointBaseL.y,
                                                 x2: U_R.x, y2: U_R.y,
                                                 x3: D_R.x, y3: D_R.y)
                    }
                }
                
                //Upper-Right out (Elbow)
                if (U_L.inside == true) && (U_R.inside == false) && (D_L.inside == true) && (D_R.inside == true) {
                    if U_L.edgeR && D_R.edgeU {
                        polyMeshTriangleData.add(x1: D_L.x, y1: D_L.y,
                                                 x2: U_L.edgePointBaseR.x,
                                                 y2: U_L.edgePointBaseR.y,
                                                 x3: D_R.edgePointBaseU.x,
                                                 y3: D_R.edgePointBaseU.y)
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: D_L.x, y2: D_L.y,
                                                 x3: U_L.edgePointBaseR.x,
                                                 y3: U_L.edgePointBaseR.y)
                        polyMeshTriangleData.add(x1: D_L.x, y1: D_L.y,
                                                 x2: D_R.edgePointBaseU.x,
                                                 y2: D_R.edgePointBaseU.y,
                                                 x3: D_R.x, y3: D_R.y)
                    }
                }
                
                //Bottom-Left out (Elbow)
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == false) && (D_R.inside == true) {
                    if U_L.edgeD && D_R.edgeL {
                        polyMeshTriangleData.add(x1: U_L.edgePointBaseD.x,
                                                 y1: U_L.edgePointBaseD.y,
                                                 x2: U_R.x, y2: U_R.y,
                                                 x3: D_R.edgePointBaseL.x,
                                                 y3: D_R.edgePointBaseL.y)
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: U_L.edgePointBaseD.x,
                                                 y2: U_L.edgePointBaseD.y,
                                                 x3: U_R.x, y3: U_R.y)
                        polyMeshTriangleData.add(x1: D_R.edgePointBaseL.x,
                                                 y1: D_R.edgePointBaseL.y,
                                                 x2: U_R.x, y2: U_R.y,
                                                 x3: D_R.x, y3: D_R.y)
                    }
                }
                
                //Bottom-Right out (Elbow)
                if (U_L.inside == true) && (U_R.inside == true) && (D_L.inside == true) && (D_R.inside == false) {
                    if U_R.edgeD && D_L.edgeR {
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: U_R.edgePointBaseD.x,
                                                 y2: U_R.edgePointBaseD.y,
                                                 x3: D_L.edgePointBaseR.x,
                                                 y3: D_L.edgePointBaseR.y)
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: D_L.x, y2: D_L.y,
                                                 x3: D_L.edgePointBaseR.x,
                                                 y3: D_L.edgePointBaseR.y)
                        polyMeshTriangleData.add(x1: U_L.x, y1: U_L.y,
                                                 x2: U_R.x, y2: U_R.y,
                                                 x3: U_R.edgePointBaseD.x,
                                                 y3: U_R.edgePointBaseD.y)
                    }
                }
            }
        }
    }
    
    private static let searchBoxPrimary = Float(32.0)
    private static let searchBoxSecondary = Float(16.0)
    private static let searchBoxRayLength = Float(1024)
    
    func closestBorderPointUp(x: Float, y: Float, ringLineSegmentBucket: RingLineSegmentBucket) -> Point {
        ringLineSegmentBucket.query(minX: x - Self.searchBoxSecondary,
                                    maxX: x + Self.searchBoxSecondary,
                                    minY: y - Self.searchBoxPrimary,
                                    maxY: y + Self.searchBoxSecondary)
        return closestBorderPoint(x: x, y: y, dirX: 0.0, dirY: -1.0, ringLineSegmentBucket: ringLineSegmentBucket)
    }
    
    func closestBorderPointRight(x: Float, y: Float, ringLineSegmentBucket: RingLineSegmentBucket) -> Point {
        ringLineSegmentBucket.query(minX: x - Self.searchBoxSecondary,
                                    maxX: x + Self.searchBoxPrimary,
                                    minY: y - Self.searchBoxSecondary,
                                    maxY: y + Self.searchBoxSecondary)
        return closestBorderPoint(x: x, y: y, dirX: 1.0, dirY: 0.0, ringLineSegmentBucket: ringLineSegmentBucket)
    }
    
    func closestBorderPointDown(x: Float, y: Float, ringLineSegmentBucket: RingLineSegmentBucket) -> Point {
        ringLineSegmentBucket.query(minX: x - Self.searchBoxSecondary,
                                    maxX: x + Self.searchBoxSecondary,
                                    minY: y - Self.searchBoxSecondary,
                                    maxY: y + Self.searchBoxPrimary)
        return closestBorderPoint(x: x, y: y, dirX: 0.0, dirY: 1.0, ringLineSegmentBucket: ringLineSegmentBucket)
    }
    
    func closestBorderPointLeft(x: Float, y: Float, ringLineSegmentBucket: RingLineSegmentBucket) -> Point {
        ringLineSegmentBucket.query(minX: x - Self.searchBoxPrimary,
                                    maxX: x + Self.searchBoxSecondary,
                                    minY: y - Self.searchBoxSecondary,
                                    maxY: y + Self.searchBoxSecondary)
        return closestBorderPoint(x: x, y: y, dirX: -1.0, dirY: 0.0, ringLineSegmentBucket: ringLineSegmentBucket)
    }
    
    func closestBorderPoint(x: Float, y: Float,
                            dirX: Float, dirY: Float,
                            ringLineSegmentBucket: RingLineSegmentBucket) -> Point {
        var result = Point(x: x, y: y)
        var bestDist = Float(100_000_000.0)
        let x2 = x + dirX * Self.searchBoxRayLength
        let y2 = y + dirY * Self.searchBoxRayLength
        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
            let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
            if Math.lineSegmentIntersectsLineSegment(line1Point1X: x,
                                                     line1Point1Y: y,
                                                     line1Point2X: x2,
                                                     line1Point2Y: y2,
                                                     line2Point1X: bucketLineSegment.x1,
                                                     line2Point1Y: bucketLineSegment.y1,
                                                     line2Point2X: bucketLineSegment.x2,
                                                     line2Point2Y: bucketLineSegment.y2) {
                
                let rayRayResult = Math.rayIntersectionRay(rayOrigin1X: bucketLineSegment.x1,
                                                           rayOrigin1Y: bucketLineSegment.y1,
                                                           rayNormal1X: bucketLineSegment.normalX,
                                                           rayNormal1Y: bucketLineSegment.normalY,
                                                           rayOrigin2X: x,
                                                           rayOrigin2Y: y,
                                                           rayDirection2X: dirX,
                                                           rayDirection2Y: dirY)
                
                switch rayRayResult {
                case .invalidCoplanar:
                    break
                case .valid(pointX: let pointX, pointY: let pointY, distance: let distance):
                    if distance < bestDist {
                        bestDist = distance
                        result.x = pointX
                        result.y = pointY
                    }
                }
            }
        }
        return result
    }
}
