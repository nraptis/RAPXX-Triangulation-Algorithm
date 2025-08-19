//
//  Ring+SweepPoints.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/17/24.
//

import Foundation

extension Ring {
    
    func calculateSweepPointsHorizontal() {
        
        purgeRingSweepPoints()
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            
            for ringSweepSegmentIndex in 0..<ringSweepLine.ringSweepSegmentCount {
                let ringSweepSegment = ringSweepLine.ringSweepSegments[ringSweepSegmentIndex]
            
                let range = (ringSweepSegment.position2 - ringSweepSegment.position1)
                if range > PolyMeshConstants.sweepLinePointTooClose2 {
                    
                    ringLineSegmentBucket.query(minX: ringSweepSegment.position1 - PolyMeshConstants.sweepLinePointTooClose,
                                                     maxX: ringSweepSegment.position2 + PolyMeshConstants.sweepLinePointTooClose,
                                                     minY: ringSweepLine.position - PolyMeshConstants.sweepLinePointTooClose,
                                                     maxY: ringSweepLine.position + PolyMeshConstants.sweepLinePointTooClose)
                    
                    let sweepPointCount = Int((range / PolyMeshConstants.sweepLineDivison) + 0.5)
                    let sweepPointCount1f = Float(sweepPointCount + 1)
                    
                    var didPlaceSweepPoint = false
                    
                    var sweepPointIndex = 0
                    while sweepPointIndex < sweepPointCount {
                        
                        let percent = Float(sweepPointIndex + 1) / sweepPointCount1f
                        let x = ringSweepSegment.position1 + range * percent
                        
                        var isIllegal = false
                        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                            let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                            
                            if bucketLineSegment.distanceSquaredToClosestPoint(x, ringSweepLine.position) < PolyMeshConstants.sweepLinePointTooCloseSquared {
                                isIllegal = true
                                break
                            }
                            
                        }
                        
                        if !isIllegal {
                            didPlaceSweepPoint = true
                            let ringSweepPoint = PolyMeshPartsFactory.shared.withdrawRingSweepPoint()
                            ringSweepPoint.x = x
                            ringSweepPoint.y = ringSweepLine.position
                            addRingSweepPoint(ringSweepPoint)
                        }
                        sweepPointIndex += 1
                    }
                    
                    // Try the middle point alone
                    if (didPlaceSweepPoint == false) && (sweepPointIndex == 2) {
                        let x = ringSweepSegment.position1 + range * 0.5
                        
                        var isIllegal = false
                        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                            let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                            
                            if bucketLineSegment.distanceSquaredToClosestPoint(x, ringSweepLine.position) < PolyMeshConstants.sweepLinePointTooCloseSquared {
                                isIllegal = true
                                break
                            }
                        }
                        
                        if !isIllegal {
                            let ringSweepPoint = PolyMeshPartsFactory.shared.withdrawRingSweepPoint()
                            ringSweepPoint.x = x
                            ringSweepPoint.y = ringSweepLine.position
                            addRingSweepPoint(ringSweepPoint)
                        }
                    }
                }
            }
        }
    }
    
    func calculateSweepPointsVertical() {
        
        purgeRingSweepPoints()
        for ringSweepLineIndex in 0..<ringSweepLineCount {
            let ringSweepLine = ringSweepLines[ringSweepLineIndex]
            
            for ringSweepSegmentIndex in 0..<ringSweepLine.ringSweepSegmentCount {
                let ringSweepSegment = ringSweepLine.ringSweepSegments[ringSweepSegmentIndex]
            
                let range = (ringSweepSegment.position2 - ringSweepSegment.position1)
                if range > PolyMeshConstants.sweepLinePointTooClose2 {
                    
                    ringLineSegmentBucket.query(minX: ringSweepLine.position - PolyMeshConstants.sweepLinePointTooClose,
                                                maxX: ringSweepLine.position + PolyMeshConstants.sweepLinePointTooClose,
                                                minY: ringSweepSegment.position1 - PolyMeshConstants.sweepLinePointTooClose,
                                                maxY: ringSweepSegment.position2 + PolyMeshConstants.sweepLinePointTooClose)
                    
                    let sweepPointCount = Int((range / PolyMeshConstants.sweepLineDivison) + 0.5)
                    let sweepPointCount1f = Float(sweepPointCount + 1)
                    
                    var didPlaceSweepPoint = false
                    
                    var sweepPointIndex = 0
                    while sweepPointIndex < sweepPointCount {
                        
                        let percent = Float(sweepPointIndex + 1) / sweepPointCount1f
                        let y = ringSweepSegment.position1 + range * percent
                        
                        var isIllegal = false
                        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                            let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                            
                            if bucketLineSegment.distanceSquaredToClosestPoint(ringSweepLine.position, y) < PolyMeshConstants.sweepLinePointTooCloseSquared {
                                isIllegal = true
                                break
                            }
                            
                        }
                        
                        if !isIllegal {
                            didPlaceSweepPoint = true
                            let ringSweepPoint = PolyMeshPartsFactory.shared.withdrawRingSweepPoint()
                            ringSweepPoint.x = ringSweepLine.position
                            ringSweepPoint.y = y
                            addRingSweepPoint(ringSweepPoint)
                        }
                        sweepPointIndex += 1
                    }
                    
                    // Try the middle point alone
                    if (didPlaceSweepPoint == false) && (sweepPointIndex == 2) {
                        let y = ringSweepSegment.position1 + range * 0.5
                        
                        var isIllegal = false
                        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
                            let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
                            
                            if bucketLineSegment.distanceSquaredToClosestPoint(ringSweepLine.position, y) < PolyMeshConstants.sweepLinePointTooCloseSquared {
                                isIllegal = true
                                break
                            }
                        }
                        
                        if !isIllegal {
                            let ringSweepPoint = PolyMeshPartsFactory.shared.withdrawRingSweepPoint()
                            ringSweepPoint.x = ringSweepLine.position
                            ringSweepPoint.y = y
                            addRingSweepPoint(ringSweepPoint)
                        }
                    }
                }
            }
        }
    }
    
}
