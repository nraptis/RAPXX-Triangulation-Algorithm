//
//  Ring+SweepSegments.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/17/24.
//

import Foundation

extension Ring {
    
    func calculateSweepSegmentsHorizontal(minX: Float, maxX: Float, rangeX: Float) {
        
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            ringSweepLine.purgeRingSweepSegments()
        }
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            var ringSweepCollisionIndex1 = 0
            var ringSweepCollisionIndex2 = 1
            while ringSweepCollisionIndex2 < ringSweepLine.ringSweepCollisionCount {
                let ringSweepCollision1 = ringSweepLine.ringSweepCollisions[ringSweepCollisionIndex1]
                let ringSweepCollision2 = ringSweepLine.ringSweepCollisions[ringSweepCollisionIndex2]
                let midPointX = (ringSweepCollision1.x + ringSweepCollision2.x) * 0.5
                if containsRingPoint(midPointX, ringSweepLine.position) {
                    let ringSweepSegment = PolyMeshPartsFactory.shared.withdrawRingSweepSegment()
                    ringSweepSegment.position1 = ringSweepCollision1.x
                    ringSweepSegment.position2 = ringSweepCollision2.x
                    ringSweepLine.addRingSweepSegment(ringSweepSegment)
                }
                ringSweepCollisionIndex1 = ringSweepCollisionIndex2
                ringSweepCollisionIndex2 += 1
            }
        }
    }
    
    func calculateSweepSegmentsVertical(minY: Float, maxY: Float, rangeY: Float) {
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            ringSweepLine.purgeRingSweepSegments()
        }
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            var ringSweepCollisionIndex1 = 0
            var ringSweepCollisionIndex2 = 1
            while ringSweepCollisionIndex2 < ringSweepLine.ringSweepCollisionCount {
                let ringSweepCollision1 = ringSweepLine.ringSweepCollisions[ringSweepCollisionIndex1]
                let ringSweepCollision2 = ringSweepLine.ringSweepCollisions[ringSweepCollisionIndex2]
                let midPointY = (ringSweepCollision1.y + ringSweepCollision2.y) * 0.5
                if containsRingPoint(ringSweepLine.position, midPointY) {
                    let ringSweepSegment = PolyMeshPartsFactory.shared.withdrawRingSweepSegment()
                    ringSweepSegment.position1 = ringSweepCollision1.y
                    ringSweepSegment.position2 = ringSweepCollision2.y
                    ringSweepLine.addRingSweepSegment(ringSweepSegment)
                }
                ringSweepCollisionIndex1 = ringSweepCollisionIndex2
                ringSweepCollisionIndex2 += 1
            }
        }
    }
}
