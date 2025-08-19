//
//  Ring+MeldCheckEnds.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/29/24.
//

import Foundation

extension Ring {
    
    func calculateMeldsFromPossibleMeldsEdgeAngles(possibleMeld: PossibleMeld,
                                                   meldProbePointFirst: RingProbePoint,
                                                   meldProbePointLast: RingProbePoint,
                                                   meldProbePointBeforeFirst: RingProbePoint,
                                                   meldProbePointAfterLast: RingProbePoint,
                                                   minBeforeAngle: inout Float,
                                                   minAfterAngle: inout Float) -> Bool {
        
        if meldProbePointAfterLast.connectionCount > 0 && meldProbePointLast.connectionCount > 0 {
            let meldProbeConnectionLast = meldProbePointLast.connections[meldProbePointLast.connectionCount - 1]
            let meldProbeConnectionFirstAfterLast = meldProbePointAfterLast.connections[0]
            if meldProbeConnectionLast === meldProbeConnectionFirstAfterLast {
                
                let x1 = possibleMeld.x
                let y1 = possibleMeld.y
                let x2 = meldProbePointAfterLast.x
                let y2 = meldProbePointAfterLast.y
                let x3 = meldProbeConnectionFirstAfterLast.x
                let y3 = meldProbeConnectionFirstAfterLast.y
                if Math.triangleIsClockwise(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3) {
                    minAfterAngle = Math.triangleMinimumAngle(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3)
                } else {
                    minAfterAngle = 0.0
                }
            } else {
                let x111 = possibleMeld.x
                let y111 = possibleMeld.y
                let x211 = meldProbeConnectionFirstAfterLast.x
                let y211 = meldProbeConnectionFirstAfterLast.y
                let x311 = meldProbeConnectionLast.x
                let y311 = meldProbeConnectionLast.y
                let angle11 = Math.triangleMinimumAngle(x1: x111, y1: y111, x2: x211, y2: y211, x3: x311, y3: y311)
                let clockwise11 = Math.triangleIsClockwise(x1: x111, y1: y111, x2: x211, y2: y211, x3: x311, y3: y311)
                
                let x112 = possibleMeld.x
                let y112 = possibleMeld.y
                let x212 = meldProbePointAfterLast.x
                let y212 = meldProbePointAfterLast.y
                let x312 = meldProbeConnectionFirstAfterLast.x
                let y312 = meldProbeConnectionFirstAfterLast.y
                let angle12 = Math.triangleMinimumAngle(x1: x112, y1: y112, x2: x212, y2: y212, x3: x312, y3: y312)
                let clockwise12 = Math.triangleIsClockwise(x1: x112, y1: y112, x2: x212, y2: y212, x3: x312, y3: y312)
                
                let x121 = possibleMeld.x
                let y121 = possibleMeld.y
                let x221 = meldProbePointAfterLast.x
                let y221 = meldProbePointAfterLast.y
                let x321 = meldProbeConnectionLast.x
                let y321 = meldProbeConnectionLast.y
                let angle21 = Math.triangleMinimumAngle(x1: x121, y1: y121, x2: x221, y2: y221, x3: x321, y3: y321)
                let clockwise21 = Math.triangleIsClockwise(x1: x121, y1: y121, x2: x221, y2: y221, x3: x321, y3: y321)
                
                let x122 = meldProbeConnectionLast.x
                let y122 = meldProbeConnectionLast.y
                let x222 = meldProbePointAfterLast.x
                let y222 = meldProbePointAfterLast.y
                let x322 = meldProbeConnectionFirstAfterLast.x
                let y322 = meldProbeConnectionFirstAfterLast.y
                let angle22 = Math.triangleMinimumAngle(x1: x122, y1: y122, x2: x222, y2: y222, x3: x322, y3: y322)
                let clockwise22 = Math.triangleIsClockwise(x1: x122, y1: y122, x2: x222, y2: y222, x3: x322, y3: y322)

                let angle1 = min(angle11, angle12)
                let angle2 = min(angle21, angle22)
                
                if angle1 > angle2 && clockwise11 && clockwise12 {
                    minAfterAngle = angle1
                    
                } else if clockwise21 && clockwise22 {
                    minAfterAngle = angle2
                } else {
                    minAfterAngle = 0.0
                }
            }
        } else {
            minBeforeAngle = 0.0
            minAfterAngle = 0.0
            return false
        }
        
        if meldProbePointBeforeFirst.connectionCount > 0 && meldProbePointFirst.connectionCount > 0 {
            let meldProbeConnectionFirst = meldProbePointFirst.connections[0]
            let meldProbeConnectionLastAfterFirst = meldProbePointBeforeFirst.connections[meldProbePointBeforeFirst.connectionCount - 1]
            if meldProbeConnectionFirst === meldProbeConnectionLastAfterFirst {
                
                let x1 = possibleMeld.x
                let y1 = possibleMeld.y
                let x2 = meldProbeConnectionLastAfterFirst.x
                let y2 = meldProbeConnectionLastAfterFirst.y
                let x3 = meldProbePointBeforeFirst.x
                let y3 = meldProbePointBeforeFirst.y

                if Math.triangleIsClockwise(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3) {
                    minBeforeAngle = Math.triangleMinimumAngle(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3)
                } else {
                    minBeforeAngle = 0.0
                }
            } else {
                
                let x111 = possibleMeld.x
                let y111 = possibleMeld.y
                let x211 = meldProbeConnectionFirst.x
                let y211 = meldProbeConnectionFirst.y
                let x311 = meldProbeConnectionLastAfterFirst.x
                let y311 = meldProbeConnectionLastAfterFirst.y
                let angle11 = Math.triangleMinimumAngle(x1: x111, y1: y111, x2: x211, y2: y211, x3: x311, y3: y311)
                let clockwise11 = Math.triangleIsClockwise(x1: x111, y1: y111, x2: x211, y2: y211, x3: x311, y3: y311)
                
                let x112 = possibleMeld.x
                let y112 = possibleMeld.y
                let x212 = meldProbeConnectionLastAfterFirst.x
                let y212 = meldProbeConnectionLastAfterFirst.y
                let x312 = meldProbePointBeforeFirst.x
                let y312 = meldProbePointBeforeFirst.y
                let angle12 = Math.triangleMinimumAngle(x1: x112, y1: y112, x2: x212, y2: y212, x3: x312, y3: y312)
                let clockwise12 = Math.triangleIsClockwise(x1: x112, y1: y112, x2: x212, y2: y212, x3: x312, y3: y312)
                
                let x121 = possibleMeld.x
                let y121 = possibleMeld.y
                let x221 = meldProbeConnectionFirst.x
                let y221 = meldProbeConnectionFirst.y
                let x321 = meldProbePointBeforeFirst.x
                let y321 = meldProbePointBeforeFirst.y
                let angle21 = Math.triangleMinimumAngle(x1: x121, y1: y121, x2: x221, y2: y221, x3: x321, y3: y321)
                let clockwise21 = Math.triangleIsClockwise(x1: x121, y1: y121, x2: x221, y2: y221, x3: x321, y3: y321)
                
                let x122 = meldProbeConnectionFirst.x
                let y122 = meldProbeConnectionFirst.y
                let x222 = meldProbeConnectionLastAfterFirst.x
                let y222 = meldProbeConnectionLastAfterFirst.y
                let x322 = meldProbePointBeforeFirst.x
                let y322 = meldProbePointBeforeFirst.y
                let angle22 = Math.triangleMinimumAngle(x1: x122, y1: y122, x2: x222, y2: y222, x3: x322, y3: y322)
                let clockwise22 = Math.triangleIsClockwise(x1: x122, y1: y122, x2: x222, y2: y222, x3: x322, y3: y322)
                
                let angle1 = min(angle11, angle12)
                let angle2 = min(angle21, angle22)
                if angle1 > angle2 && clockwise11 && clockwise12 {
                    minBeforeAngle = angle1
                } else if clockwise21 && clockwise22 {
                    minBeforeAngle = angle2
                } else {
                    minAfterAngle = 0.0
                }
            }
        } else {
            minBeforeAngle = 0.0
            minAfterAngle = 0.0
            return false
        }
        
        if minBeforeAngle < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        } else if minAfterAngle < PolyMeshConstants.illegalTriangleAngleThreshold {
            return false
        } else {
            return true
        }
    }
}
