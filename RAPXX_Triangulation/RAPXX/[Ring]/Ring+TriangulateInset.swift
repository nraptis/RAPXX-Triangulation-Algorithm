//
//  Ring+TriangulateProbeGeometry.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/16/24.
//

import Foundation

extension Ring {
    
    func calculateInsetTriangulation() {
        
        guard let triangleData = triangleData else {
            return
        }
        
        var ringProbePointIndex1 = ringProbePointCount - 1
        var ringProbePointIndex2 = 0
        while ringProbePointIndex2 < ringProbePointCount {
            
            let ringProbePoint1 = ringProbePoints[ringProbePointIndex1]
            let ringProbePoint2 = ringProbePoints[ringProbePointIndex2]
            
            if ringProbePoint1.connectionCount <= 0 {
                ringProbePointIndex1 = ringProbePointIndex2
                ringProbePointIndex2 += 1
                continue
            }
            
            if ringProbePoint2.connectionCount <= 0 {
                ringProbePointIndex1 = ringProbePointIndex2
                ringProbePointIndex2 += 1
                continue
            }
            
            if ringProbePoint2.connectionCount > 1 {
                var connectionIndex1 = 0
                var connectionIndex2 = 1
                while connectionIndex2 < ringProbePoint2.connectionCount {
                    let connection1 = ringProbePoint2.connections[connectionIndex1]
                    let connection2 = ringProbePoint2.connections[connectionIndex2]
                    
                    triangleData.add(x1: connection1.x, y1: connection1.y,
                                              x2: connection2.x, y2: connection2.y,
                                              x3: ringProbePoint2.x, y3: ringProbePoint2.y)
                    
                    connectionIndex1 = connectionIndex2
                    connectionIndex2 += 1
                }
            }
            
            let lastConnection1 = ringProbePoint1.connections[ringProbePoint1.connectionCount - 1]
            let firstConnection2 = ringProbePoint2.connections[0]
            
            if lastConnection1 === firstConnection2 {
                triangleData.add(x1: ringProbePoint1.x, y1: ringProbePoint1.y,
                                          x2: lastConnection1.x, y2: lastConnection1.y,
                                          x3: ringProbePoint2.x, y3: ringProbePoint2.y)
            } else {
                
                let x111 = ringProbePoint1.x
                let y111 = ringProbePoint1.y
                let x211 = lastConnection1.x
                let y211 = lastConnection1.y
                let x311 = ringProbePoint2.x
                let y311 = ringProbePoint2.y
                let angle11 = Math.triangleMinimumAngle(x1: x111, y1: y111, x2: x211, y2: y211, x3: x311, y3: y311)
                let clockwise11 = Math.triangleIsClockwise(x1: x111, y1: y111, x2: x311, y2: y311, x3: x211, y3: y211)
                
                let x112 = ringProbePoint2.x
                let y112 = ringProbePoint2.y
                let x212 = lastConnection1.x
                let y212 = lastConnection1.y
                let x312 = firstConnection2.x
                let y312 = firstConnection2.y
                let angle12 = Math.triangleMinimumAngle(x1: x112, y1: y112, x2: x212, y2: y212, x3: x312, y3: y312)
                let clockwise12 = Math.triangleIsClockwise(x1: x112, y1: y112, x2: x312, y2: y312, x3: x212, y3: y212)
                
                let x121 = ringProbePoint1.x
                let y121 = ringProbePoint1.y
                let x221 = lastConnection1.x
                let y221 = lastConnection1.y
                let x321 = firstConnection2.x
                let y321 = firstConnection2.y
                let angle21 = Math.triangleMinimumAngle(x1: x121, y1: y121, x2: x221, y2: y221, x3: x321, y3: y321)
                
                let x122 = ringProbePoint1.x
                let y122 = ringProbePoint1.y
                let x222 = firstConnection2.x
                let y222 = firstConnection2.y
                let x322 = ringProbePoint2.x
                let y322 = ringProbePoint2.y
                let angle22 = Math.triangleMinimumAngle(x1: x122, y1: y122, x2: x322, y2: y322, x3: x222, y3: y222)
                
                let angle1 = min(angle11, angle12)
                let angle2 = min(angle21, angle22)
                
                if angle1 > angle2 && clockwise11 && clockwise12 {
                    
                    triangleData.add(x1: x111, y1: y111,
                                              x2: x211, y2: y211,
                                              x3: x311, y3: y311)
                    
                    
                    triangleData.add(x1: x112, y1: y112,
                                              x2: x212, y2: y212,
                                              x3: x312, y3: y312)
                    
                } else {
                    triangleData.add(x1: x121, y1: y121,
                                              x2: x221, y2: y221,
                                              x3: x321, y3: y321)
                    
                    triangleData.add(x1: x122, y1: y122,
                                              x2: x222, y2: y222,
                                              x3: x322, y3: y322)
                }
            }
            
            ringProbePointIndex1 = ringProbePointIndex2
            ringProbePointIndex2 += 1
        }
    }
}
