//
//  Ring+RelaxDirections.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/28/24.
//

import Foundation

extension Ring {
    
    func calculateProbePointRelaxGeometryIfNotComputedLocal() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            if !ringProbePoint.isRelaxDirectionComputed {
                if ringProbePoint.connectionCount == 1 {
                    calculateProbePointRelaxGeometrySingleConnectionLocal(ringProbePoint: ringProbePoint)
                } else if ringProbePoint.connectionCount > 1 {
                    calculateProbePointRelaxGeometryMultiConnectionLocal(ringProbePoint: ringProbePoint)
                }
            }
            if ringProbePoint.isRelaxable {
                ringProbePoint.isRelaxDirectionComputed = true
            }
        }
    }
    
    func calculateProbePointRelaxGeometryIfNotComputedAll() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            if !ringProbePoint.isRelaxDirectionComputed {
                if ringProbePoint.connectionCount == 1 {
                    calculateProbePointRelaxGeometrySingleConnectionAll(ringProbePoint: ringProbePoint)
                } else if ringProbePoint.connectionCount > 1 {
                    calculateProbePointRelaxGeometryMultiConnectionAll(ringProbePoint: ringProbePoint)
                }
            }
            if ringProbePoint.isRelaxable {
                ringProbePoint.isRelaxDirectionComputed = true
            }
        }
    }
    
    func calculateRelaxableWithRelaxGeometryAlreadyComputed() -> Bool {
        var result = false
        for ringProbePointIndex in 0..<ringProbePointCount {
            
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.isRelaxable = false
            
            if ringProbePoint.isRelaxDirectionComputed {
                
                var relaxMagnitude: Float
                if ringProbePoint.isIllegal {
                    relaxMagnitude = PolyMeshConstants.relaxMagnitudeIllegal
                } else {
                    relaxMagnitude = PolyMeshConstants.relaxMagnitudeNormal
                }
                
                let proposedX = ringProbePoint.x + ringProbePoint.relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + ringProbePoint.relaxDirectionY * relaxMagnitude
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.isRelaxable = true
                    result = true
                }
            }
        }
        return result
    }
    
    private func calculateProbePointRelaxGeometryMultiConnectionLocal(ringProbePoint: RingProbePoint) {
        
        var diffX = Float(0.0)
        var diffY = Float(0.0)
        var lengthSquared = Float(0.0)
        var length = Float(0.0)
        
        var relaxMagnitude: Float
        if ringProbePoint.isIllegal {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeIllegal
        } else {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeNormal
        }
        
        let firstRingPoint = ringProbePoint.connections[0]
        let lastRingPoint = ringProbePoint.connections[ringProbePoint.connectionCount - 1]
        
        var diffX1 = firstRingPoint.x - ringProbePoint.x
        var diffY1 = firstRingPoint.y - ringProbePoint.y
        let lengthSquared1 = diffX1 * diffX1 + diffY1 * diffY1
        var length1 = Float(0.0)
        
        var diffX2 = lastRingPoint.x - ringProbePoint.x
        var diffY2 = lastRingPoint.y - ringProbePoint.y
        let lengthSquared2 = diffX2 * diffX2 + diffY2 * diffY2
        var length2 = Float(0.0)
        
        if lengthSquared1 > Math.epsilon && lengthSquared2 > Math.epsilon {
            length1 = sqrtf(lengthSquared1)
            length2 = sqrtf(lengthSquared2)
            
            let relaxDirectionX1 = diffX1 / length1
            let relaxDirectionY1 = diffY1 / length1
            
            let relaxDirectionX2 = diffX2 / length2
            let relaxDirectionY2 = diffY2 / length2
            
            diffX = relaxDirectionX1 + relaxDirectionX2
            diffY = relaxDirectionY1 + relaxDirectionY2
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                var relaxDirectionX = diffX / length
                var relaxDirectionY = diffY / length
                
                var proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                var proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if Math.triangleIsClockwise(x1: ringProbePoint.x, y1: ringProbePoint.y,
                                            x2: firstRingPoint.x, y2: firstRingPoint.y,
                                            x3: proposedX, y3: proposedY) {
                    
                    relaxDirectionX = -relaxDirectionX
                    relaxDirectionY = -relaxDirectionY
                    
                    proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                    proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                }
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
                
            } else {
                
                // In this case, we have probably a 180 degree angle,
                // so, we will need to make a small adjustment to both angles...
                
                let angle1 = -atan2f(-diffX1, -diffY1) + Math.pi_8
                let angle2 = -atan2f(-diffX2, -diffY2) - Math.pi_8
                
                diffX1 = sinf(angle1)
                diffY1 = -cosf(angle1)
                
                diffX2 = sinf(angle2)
                diffY2 = -cosf(angle2)
                
                diffX = diffX1 + diffX2
                diffY = diffY1 + diffY2
                
                lengthSquared = diffX * diffX + diffY * diffY
                
                if lengthSquared > Math.epsilon {
                    
                    length = sqrtf(lengthSquared)
                    
                    var relaxDirectionX = diffX / length
                    var relaxDirectionY = diffY / length
                    
                    var proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                    var proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                    
                    if Math.triangleIsClockwise(x1: ringProbePoint.x, y1: ringProbePoint.y,
                                                x2: firstRingPoint.x, y2: firstRingPoint.y,
                                                x3: proposedX, y3: proposedY) {
                        
                        relaxDirectionX = -relaxDirectionX
                        relaxDirectionY = -relaxDirectionY
                        
                        proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                        proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                        
                    }
                    
                    if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                     x: proposedX,
                                                                     y: proposedY) {
                        ringProbePoint.relaxDirectionX = relaxDirectionX
                        ringProbePoint.relaxDirectionY = relaxDirectionY
                        ringProbePoint.isRelaxable = true
                        return
                    }
                }
            }
        }
        
        if (ringProbePoint.connectionCount & 1) == 0 {
            // This is even, we go to line segment
            
            let middleRingPoint = ringProbePoint.connections[ringProbePoint.connectionCount / 2]
            let middleSegment = middleRingPoint.ringLineSegmentLeft!
            let middlePointX = middleSegment.centerX
            let middlePointY = middleSegment.centerY
            
            diffX = middlePointX - ringProbePoint.x
            diffY = middlePointY - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
            
        } else {
            
            let middleRingPoint = ringProbePoint.connections[ringProbePoint.connectionCount / 2]
            
            let middlePointX = middleRingPoint.x
            let middlePointY = middleRingPoint.y
                
            diffX = middlePointX - ringProbePoint.x
            diffY = middlePointY - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        }
    }
    
    private func calculateProbePointRelaxGeometryMultiConnectionAll(ringProbePoint: RingProbePoint) {
        
        var diffX = Float(0.0)
        var diffY = Float(0.0)
        var lengthSquared = Float(0.0)
        var length = Float(0.0)
        
        var relaxMagnitude: Float
        if ringProbePoint.isIllegal {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeIllegal
        } else {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeNormal
        }
        
        let firstRingPoint = ringProbePoint.connections[0]
        let lastRingPoint = ringProbePoint.connections[ringProbePoint.connectionCount - 1]
        
        var diffX1 = firstRingPoint.x - ringProbePoint.x
        var diffY1 = firstRingPoint.y - ringProbePoint.y
        let lengthSquared1 = diffX1 * diffX1 + diffY1 * diffY1
        var length1 = Float(0.0)
        
        var diffX2 = lastRingPoint.x - ringProbePoint.x
        var diffY2 = lastRingPoint.y - ringProbePoint.y
        let lengthSquared2 = diffX2 * diffX2 + diffY2 * diffY2
        var length2 = Float(0.0)
        
        if lengthSquared1 > Math.epsilon && lengthSquared2 > Math.epsilon {
            length1 = sqrtf(lengthSquared1)
            length2 = sqrtf(lengthSquared2)
            
            let relaxDirectionX1 = diffX1 / length1
            let relaxDirectionY1 = diffY1 / length1
            
            let relaxDirectionX2 = diffX2 / length2
            let relaxDirectionY2 = diffY2 / length2
            
            diffX = relaxDirectionX1 + relaxDirectionX2
            diffY = relaxDirectionY1 + relaxDirectionY2
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                var relaxDirectionX = diffX / length
                var relaxDirectionY = diffY / length
                
                var proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                var proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if Math.triangleIsClockwise(x1: ringProbePoint.x, y1: ringProbePoint.y,
                                            x2: firstRingPoint.x, y2: firstRingPoint.y,
                                            x3: proposedX, y3: proposedY) {
                    
                    relaxDirectionX = -relaxDirectionX
                    relaxDirectionY = -relaxDirectionY
                    
                    proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                    proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                }
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
                
            } else {
                
                // In this case, we have probably a 180 degree angle,
                // so, we will need to make a small adjustment to both angles...
                
                let angle1 = -atan2f(-diffX1, -diffY1) + Math.pi_8
                let angle2 = -atan2f(-diffX2, -diffY2) - Math.pi_8
                
                diffX1 = sinf(angle1)
                diffY1 = -cosf(angle1)
                
                diffX2 = sinf(angle2)
                diffY2 = -cosf(angle2)
                
                diffX = diffX1 + diffX2
                diffY = diffY1 + diffY2
                
                lengthSquared = diffX * diffX + diffY * diffY
                
                if lengthSquared > Math.epsilon {
                    
                    length = sqrtf(lengthSquared)
                    
                    var relaxDirectionX = diffX / length
                    var relaxDirectionY = diffY / length
                    
                    var proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                    var proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                    
                    if Math.triangleIsClockwise(x1: ringProbePoint.x, y1: ringProbePoint.y,
                                                x2: firstRingPoint.x, y2: firstRingPoint.y,
                                                x3: proposedX, y3: proposedY) {
                        
                        relaxDirectionX = -relaxDirectionX
                        relaxDirectionY = -relaxDirectionY
                        
                        proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                        proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                        
                    }
                    
                    if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                      x: proposedX,
                                                                      y: proposedY) {
                        ringProbePoint.relaxDirectionX = relaxDirectionX
                        ringProbePoint.relaxDirectionY = relaxDirectionY
                        ringProbePoint.isRelaxable = true
                        return
                    }
                }
            }
        }
        
        if (ringProbePoint.connectionCount & 1) == 0 {
            // This is even, we go to line segment
            
            let middleRingPoint = ringProbePoint.connections[ringProbePoint.connectionCount / 2]
            let middleSegment = middleRingPoint.ringLineSegmentLeft!
            let middlePointX = middleSegment.centerX
            let middlePointY = middleSegment.centerY
            
            diffX = middlePointX - ringProbePoint.x
            diffY = middlePointY - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        } else {
            
            let middleRingPoint = ringProbePoint.connections[ringProbePoint.connectionCount / 2]
            
            let middlePointX = middleRingPoint.x
            let middlePointY = middleRingPoint.y
                
            diffX = middlePointX - ringProbePoint.x
            diffY = middlePointY - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        }
    }
    
    private func calculateProbePointRelaxGeometrySingleConnectionLocal(ringProbePoint: RingProbePoint) {
        
        var relaxMagnitude: Float
        if ringProbePoint.isIllegal {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeIllegal
        } else {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeNormal
        }
        
        let connection = ringProbePoint.connections[0]
        
        var diffX = connection.x - ringProbePoint.x
        var diffY = connection.y - ringProbePoint.y
        var lengthSquared = diffX * diffX + diffY * diffY
        var length = Float(0.0)
        
        if lengthSquared > Math.epsilon {
            
            length = sqrtf(lengthSquared)
            
            let relaxDirectionX = diffX / length
            let relaxDirectionY = diffY / length
            
            let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
            let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
            
            if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint, x: proposedX, y: proposedY) {
                ringProbePoint.relaxDirectionX = relaxDirectionX
                ringProbePoint.relaxDirectionY = relaxDirectionY
                ringProbePoint.isRelaxable = true
                return
            }
        }
        
        let notchX1 = connection.x + connection.ringLineSegmentRight.directionX * PolyMeshConstants.probePointTooCloseToLineSegment
        let notchY1 = connection.y + connection.ringLineSegmentRight.directionY * PolyMeshConstants.probePointTooCloseToLineSegment
        let notchX2 = connection.x - connection.ringLineSegmentLeft.directionX * PolyMeshConstants.probePointTooCloseToLineSegment
        let notchY2 = connection.y - connection.ringLineSegmentLeft.directionY * PolyMeshConstants.probePointTooCloseToLineSegment
        
        let distanceToNotch1 = Math.distanceSquared(x1: ringProbePoint.x, y1: ringProbePoint.y, x2: notchX1, y2: notchY1)
        let distanceToNotch2 = Math.distanceSquared(x1: ringProbePoint.x, y1: ringProbePoint.y, x2: notchX2, y2: notchY2)
        
        if distanceToNotch1 < distanceToNotch2 {
            // In this case, we should try notch 1 FIRST
            
            diffX = notchX1 - ringProbePoint.x
            diffY = notchY1 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
            
            diffX = notchX2 - ringProbePoint.x
            diffY = notchY2 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        } else {
            // In this case, we should try notch 2 FIRST
            
            diffX = notchX2 - ringProbePoint.x
            diffY = notchY2 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
            
            diffX = notchX1 - ringProbePoint.x
            diffY = notchY1 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringLocalLineSegments(ringProbePoint: ringProbePoint,
                                                                 x: proposedX,
                                                                 y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        }
    }
    
    private func calculateProbePointRelaxGeometrySingleConnectionAll(ringProbePoint: RingProbePoint) {
        
        var relaxMagnitude: Float
        if ringProbePoint.isIllegal {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeIllegal
        } else {
            relaxMagnitude = PolyMeshConstants.relaxMagnitudeNormal
        }
        
        let connection = ringProbePoint.connections[0]
        
        var diffX = connection.x - ringProbePoint.x
        var diffY = connection.y - ringProbePoint.y
        var lengthSquared = diffX * diffX + diffY * diffY
        var length = Float(0.0)
        
        if lengthSquared > Math.epsilon {
            
            length = sqrtf(lengthSquared)
            
            let relaxDirectionX = diffX / length
            let relaxDirectionY = diffY / length
            
            let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
            let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
            
            if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint, x: proposedX, y: proposedY) {
                ringProbePoint.relaxDirectionX = relaxDirectionX
                ringProbePoint.relaxDirectionY = relaxDirectionY
                ringProbePoint.isRelaxable = true
                return
            }
        }
        
        let notchX1 = connection.x + connection.ringLineSegmentRight.directionX * PolyMeshConstants.probePointTooCloseToLineSegment
        let notchY1 = connection.y + connection.ringLineSegmentRight.directionY * PolyMeshConstants.probePointTooCloseToLineSegment
        let notchX2 = connection.x - connection.ringLineSegmentLeft.directionX * PolyMeshConstants.probePointTooCloseToLineSegment
        let notchY2 = connection.y - connection.ringLineSegmentLeft.directionY * PolyMeshConstants.probePointTooCloseToLineSegment
        
        let distanceToNotch1 = Math.distanceSquared(x1: ringProbePoint.x, y1: ringProbePoint.y, x2: notchX1, y2: notchY1)
        let distanceToNotch2 = Math.distanceSquared(x1: ringProbePoint.x, y1: ringProbePoint.y, x2: notchX2, y2: notchY2)
        
        if distanceToNotch1 < distanceToNotch2 {
            // In this case, we should try notch 1 FIRST
            
            diffX = notchX1 - ringProbePoint.x
            diffY = notchY1 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
            
            diffX = notchX2 - ringProbePoint.x
            diffY = notchY2 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        } else {
            // In this case, we should try notch 2 FIRST
            
            diffX = notchX2 - ringProbePoint.x
            diffY = notchY2 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
            
            diffX = notchX1 - ringProbePoint.x
            diffY = notchY1 - ringProbePoint.y
            lengthSquared = diffX * diffX + diffY * diffY
            if lengthSquared > Math.epsilon {
                
                length = sqrtf(lengthSquared)
                
                let relaxDirectionX = diffX / length
                let relaxDirectionY = diffY / length
                
                let proposedX = ringProbePoint.x + relaxDirectionX * relaxMagnitude
                let proposedY = ringProbePoint.y + relaxDirectionY * relaxMagnitude
                
                if canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: ringProbePoint,
                                                                  x: proposedX,
                                                                  y: proposedY) {
                    ringProbePoint.relaxDirectionX = relaxDirectionX
                    ringProbePoint.relaxDirectionY = relaxDirectionY
                    ringProbePoint.isRelaxable = true
                    return
                }
            }
        }
    }
    
    private func canProbePointMoveConsideringLocalLineSegments(ringProbePoint: RingProbePoint, x: Float, y: Float) -> Bool {
        if ringProbePoint.connectionCount > 0 {
            let firstLineSegment = ringProbePoint.connections[0].ringLineSegmentLeft!
            let lastLineSegment = ringProbePoint.connections[ringProbePoint.connectionCount - 1].ringLineSegmentRight!
            var fudge = 0
            var lineSegment = firstLineSegment
            while true {
                let distanceSquared = lineSegment.distanceSquaredToClosestPoint(x, y)
                if distanceSquared < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                    return false
                }
                if lineSegment === lastLineSegment {
                    break
                } else {
                    lineSegment = lineSegment.neighborRight!
                }
                fudge += 1
                if fudge >= 64 {
                    break
                }
            }
        }
        return true
    }
    
    private func canProbePointMoveConsideringNearbyLineSegments(ringProbePoint: RingProbePoint, x: Float, y: Float) -> Bool {
        
        ringLineSegmentBucket.query(minX: x - PolyMeshConstants.probePointTooCloseToLineSegment,
                                    maxX: x + PolyMeshConstants.probePointTooCloseToLineSegment,
                                    minY: y - PolyMeshConstants.probePointTooCloseToLineSegment,
                                    maxY: y + PolyMeshConstants.probePointTooCloseToLineSegment)
        
        for bucketLineSegmentIndex in 0..<ringLineSegmentBucket.ringLineSegmentCount {
            let bucketLineSegment = ringLineSegmentBucket.ringLineSegments[bucketLineSegmentIndex]
            if bucketLineSegment.distanceSquaredToClosestPoint(x, y) < PolyMeshConstants.probePointTooCloseToLineSegmentSquared {
                return false
            }
        }
        
        return true
    }
}
