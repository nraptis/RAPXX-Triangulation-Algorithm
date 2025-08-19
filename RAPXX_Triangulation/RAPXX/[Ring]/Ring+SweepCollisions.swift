//
//  Ring+SweepCollisions.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/17/24.
//

import Foundation

extension Ring {
   
    func calculateSweepCollisionsHorizontal(minX: Float, maxX: Float, rangeX: Float) {
        
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            ringSweepLine.purgeRingSweepCollisions()
        }
        
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            ringLineSegmentBucket.query(minX: minX,
                                             
                                        maxX: maxX,
                                        
                                        minY: ringSweepLine.position - Math.epsilon,
                                        
                                        maxY: ringSweepLine.position + Math.epsilon)
            
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: bucketLineSegment.x1,
                                                         line1Point1Y: bucketLineSegment.y1,
                                                         line1Point2X: bucketLineSegment.x2,
                                                         line1Point2Y: bucketLineSegment.y2,
                                                         line2Point1X: minX,
                                                         line2Point1Y: ringSweepLine.position,
                                                         line2Point2X: maxX,
                                                         line2Point2Y: ringSweepLine.position) {
                    
                    let rayRayResult = Math.rayIntersectionRay(rayOrigin1X: bucketLineSegment.x1,
                                                               rayOrigin1Y: bucketLineSegment.y1,
                                                               rayNormal1X: bucketLineSegment.normalX,
                                                               rayNormal1Y: bucketLineSegment.normalY,
                                                               rayOrigin2X: minX,
                                                               rayOrigin2Y: ringSweepLine.position,
                                                               rayDirection2X: 1.0,
                                                               rayDirection2Y: 0.0)
                    
                    switch rayRayResult {
                    case .invalidCoplanar:
                        break
                    case .valid(let collisionX, let collisionY, _):
                        if !ringSweepLine.containsSweepCollision(x: collisionX,
                                                                 y: collisionY) {
                            let ringSweepCollision = PolyMeshPartsFactory.shared.withdrawRingSweepCollision()
                            ringSweepCollision.x = collisionX
                            ringSweepCollision.y = collisionY
                            ringSweepLine.addRingSweepCollision(ringSweepCollision)
                        }
                    }
                }
            }
            ringSweepLine.sortCollisionsX()
        }
    }
    
    func calculateSweepCollisionsVertical(minY: Float, maxY: Float, rangeY: Float) {
        
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            ringSweepLine.purgeRingSweepCollisions()
        }
        
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            
            ringLineSegmentBucket.query(minX: ringSweepLine.position - Math.epsilon,
            
                                        maxX: ringSweepLine.position + Math.epsilon,
                                
                                        minY: minY,
                                        maxY: maxY)
            
            for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                if Math.lineSegmentIntersectsLineSegment(line1Point1X: bucketLineSegment.x1,
                                                         line1Point1Y: bucketLineSegment.y1,
                                                         line1Point2X: bucketLineSegment.x2,
                                                         line1Point2Y: bucketLineSegment.y2,
                                                         line2Point1X: ringSweepLine.position,
                                                         line2Point1Y: minY,
                                                         line2Point2X: ringSweepLine.position,
                                                         line2Point2Y: maxY) {
                    
                    let rayRayResult = Math.rayIntersectionRay(rayOrigin1X: bucketLineSegment.x1,
                                                               rayOrigin1Y: bucketLineSegment.y1,
                                                               rayNormal1X: bucketLineSegment.normalX,
                                                               rayNormal1Y: bucketLineSegment.normalY,
                                                               rayOrigin2X: ringSweepLine.position,
                                                               rayOrigin2Y: minY,
                                                               rayDirection2X: 0.0,
                                                               rayDirection2Y: 1.0)
                    
                    switch rayRayResult {
                    case .invalidCoplanar:
                        break
                    case .valid(let collisionX, let collisionY, _):
                        if !ringSweepLine.containsSweepCollision(x: collisionX,
                                                                 y: collisionY) {
                            let ringSweepCollision = PolyMeshPartsFactory.shared.withdrawRingSweepCollision()
                            ringSweepCollision.x = collisionX
                            ringSweepCollision.y = collisionY
                            ringSweepLine.addRingSweepCollision(ringSweepCollision)
                        }
                    }
                }
            }
            ringSweepLine.sortCollisionsY()
        }
        
    }
}

