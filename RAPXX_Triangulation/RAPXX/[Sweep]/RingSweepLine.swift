//
//  RingSweepLine.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/3/23.
//

import Foundation

class RingSweepLine {
    
    var position = Float(0.0)
    
    var ringSweepSegments = [RingSweepSegment]()
    var ringSweepSegmentCount = 0
    func addRingSweepSegment(_ ringSweepSegment: RingSweepSegment) {
        while ringSweepSegments.count <= ringSweepSegmentCount {
            ringSweepSegments.append(ringSweepSegment)
        }
        ringSweepSegments[ringSweepSegmentCount] = ringSweepSegment
        ringSweepSegmentCount += 1
    }
    
    func purgeRingSweepSegments() {
        for ringSweepSegmentIndex in 0..<ringSweepSegmentCount {
            PolyMeshPartsFactory.shared.depositRingSweepSegment(ringSweepSegments[ringSweepSegmentIndex])
        }
        ringSweepSegmentCount = 0
    }
    
    func containsSweepCollision(x: Float, y: Float) -> Bool {
        for ringSweepCollisionIndex in 0..<ringSweepCollisionCount {
            let ringSweepCollision = ringSweepCollisions[ringSweepCollisionIndex]
            let deltaX = fabsf(ringSweepCollision.x - x)
            let deltaY = fabsf(ringSweepCollision.y - y)
            if (deltaX < PolyMeshConstants.sweepCollisionOverlap) && (deltaY < PolyMeshConstants.sweepCollisionOverlap) {
                return true
            }
        }
        return false
    }
    
    var ringSweepCollisions = [RingSweepCollision]()
    var ringSweepCollisionCount = 0
    func addRingSweepCollision(_ ringSweepCollision: RingSweepCollision) {
        while ringSweepCollisions.count <= ringSweepCollisionCount {
            ringSweepCollisions.append(ringSweepCollision)
        }
        ringSweepCollisions[ringSweepCollisionCount] = ringSweepCollision
        ringSweepCollisionCount += 1
    }
    
    func purgeRingSweepCollisions() {
        for ringSweepCollisionIndex in 0..<ringSweepCollisionCount {
            PolyMeshPartsFactory.shared.depositRingSweepCollision(ringSweepCollisions[ringSweepCollisionIndex])
        }
        ringSweepCollisionCount = 0
    }
    
    func sortCollisionsX() {
        var i = 1
        while i < ringSweepCollisionCount {
            let hold = ringSweepCollisions[i]
            var j = i - 1
            while j >= 0 && ringSweepCollisions[j].x > hold.x {
                ringSweepCollisions[j + 1] = ringSweepCollisions[j]
                j -= 1
            }
            ringSweepCollisions[j + 1] = hold
            i += 1
        }
    }
    
    func sortCollisionsY() {
        var i = 1
        while i < ringSweepCollisionCount {
            let hold = ringSweepCollisions[i]
            var j = i - 1
            while j >= 0 && ringSweepCollisions[j].y > hold.y {
                ringSweepCollisions[j + 1] = ringSweepCollisions[j]
                j -= 1
            }
            ringSweepCollisions[j + 1] = hold
            i += 1
        }
    }
}
