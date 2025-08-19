//
//  Ring+MeldList.swift
//  RAPXX
//
//  Created by Nick "The Fallen" Raptis on 1/30/24.
//

import Foundation

extension Ring {
    
    func attemptToGeneratePossibleMeldsAndMelds(ringProbePointIndex: Int,
                                                numberOfPointsToMeld: Int) -> Bool {
        
        purgePossibleMelds()
        
        if ringProbePointCount <= 1 { return false }
        if ringProbePointIndex < 0 || ringProbePointIndex >= ringProbePointCount { return false }
        
        if numberOfPointsToMeld < 2 {
            return false
        }
        
        if numberOfPointsToMeld >= ringProbePointCount { return false }
        
        
            var index = ringProbePointIndex
            var loopIndex = 0
            while loopIndex < numberOfPointsToMeld {
                let ringProbePoint = ringProbePoints[index]
                if ringProbePoint.isButtressCenter {
                    return false
                }
                index += 1
                if index == ringProbePointCount {
                    index = 0
                }
                loopIndex += 1
            }
            
            index = ringProbePointIndex
            loopIndex = 0

        
            index = ringProbePointIndex
            loopIndex = 0
            while loopIndex < numberOfPointsToMeld {
                let ringProbePoint = ringProbePoints[index]
                if ringProbePoint.isMelded {
                    return false
                }
                index += 1
                if index == ringProbePointCount {
                    index = 0
                }
                loopIndex += 1
            }
        
        index = ringProbePointIndex
        loopIndex = 0
        meldProbePointCount = 0
        while loopIndex < numberOfPointsToMeld {
            let ringProbePoint = ringProbePoints[index]
            addMeldProbePoint(ringProbePoint)
            
            index += 1
            if index == ringProbePointCount {
                index = 0
            }
            loopIndex += 1
        }
        
        if meldProbePointCount < 1 {
            return false
        }
        
        let meldProbePointFirst = meldProbePoints[0]
        let meldProbePointLast = meldProbePoints[meldProbePointCount - 1]
        
        var meldProbePointBeforeFirstIndex = meldProbePointFirst.ringIndex - 1
        if meldProbePointBeforeFirstIndex == -1 {
            meldProbePointBeforeFirstIndex = ringProbePointCount - 1
        }
        let meldProbePointBeforeFirst = ringProbePoints[meldProbePointBeforeFirstIndex]
        
        var meldProbePointAfterLastIndex = meldProbePointLast.ringIndex + 1
        if meldProbePointAfterLastIndex == ringProbePointCount {
            meldProbePointAfterLastIndex = 0
        }
        let meldProbePointAfterLast = ringProbePoints[meldProbePointAfterLastIndex]
        
        var minX = meldProbePointFirst.x; var maxX = meldProbePointFirst.x
        var minY = meldProbePointFirst.y; var maxY = meldProbePointFirst.y
        
        minX = min(minX, meldProbePointAfterLast.x); maxX = max(maxX, meldProbePointAfterLast.x)
        minY = min(minY, meldProbePointAfterLast.y); maxY = max(maxY, meldProbePointAfterLast.y)
        minX = min(minX, meldProbePointBeforeFirst.x); maxX = max(maxX, meldProbePointBeforeFirst.x)
        minY = min(minY, meldProbePointBeforeFirst.y); maxY = max(maxY, meldProbePointBeforeFirst.y)
        
        if meldProbePointAfterLast.connectionCount > 0 && meldProbePointLast.connectionCount > 0 {
            let meldProbeConnectionFirstAfterLast = meldProbePointAfterLast.connections[0]
            minX = min(minX, meldProbeConnectionFirstAfterLast.x)
            maxX = max(maxX, meldProbeConnectionFirstAfterLast.x)
            minY = min(minY, meldProbeConnectionFirstAfterLast.y)
            maxY = max(maxY, meldProbeConnectionFirstAfterLast.y)
        }
        
        if meldProbePointBeforeFirst.connectionCount > 0 && meldProbePointFirst.connectionCount > 0 {
            let meldProbeConnectionLastAfterFirst = meldProbePointBeforeFirst.connections[meldProbePointBeforeFirst.connectionCount - 1]
            minX = min(minX, meldProbeConnectionLastAfterFirst.x)
            maxX = max(maxX, meldProbeConnectionLastAfterFirst.x)
            minY = min(minY, meldProbeConnectionLastAfterFirst.y)
            maxY = max(maxY, meldProbeConnectionLastAfterFirst.y)
        }
        
        for meldProbePointIndex in 0..<meldProbePointCount {
            let ringProbePoint = meldProbePoints[meldProbePointIndex]
            minX = min(minX, ringProbePoint.x); maxX = max(maxX, ringProbePoint.x)
            minY = min(minY, ringProbePoint.y); maxY = max(maxY, ringProbePoint.y)
            for connectionIndex in 0..<ringProbePoint.connectionCount {
                let ringProbePointConnection = ringProbePoint.connections[connectionIndex]
                minX = min(minX, ringProbePointConnection.x); maxX = max(maxX, ringProbePointConnection.x)
                minY = min(minY, ringProbePointConnection.y); maxY = max(maxY, ringProbePointConnection.y)
            }
        }
        
        minX -= PolyMeshConstants.possibleMeldStepDistance - PolyMeshConstants.possibleMeldStepDistance - Math.epsilon
        maxX += PolyMeshConstants.possibleMeldStepDistance + PolyMeshConstants.possibleMeldStepDistance + Math.epsilon
        minY -= PolyMeshConstants.possibleMeldStepDistance - PolyMeshConstants.possibleMeldStepDistance - Math.epsilon
        maxY += PolyMeshConstants.possibleMeldStepDistance + PolyMeshConstants.possibleMeldStepDistance + Math.epsilon
        
        purgeMeldProbeSpokes()
        for meldProbePointIndex in 0..<meldProbePointCount {
            let ringProbePoint = meldProbePoints[meldProbePointIndex]
            for connectionIndex in 0..<ringProbePoint.connectionCount {
                let meldProbePointConnection = ringProbePoint.connections[connectionIndex]
                if !meldProbeSpokesContainsConnection(meldProbePointConnection) {
                    let ringProbeSpoke = PolyMeshPartsFactory.shared.withdrawRingProbeSpoke()
                    ringProbeSpoke.precomputeStep1(connection: meldProbePointConnection)
                    addMeldProbeSpoke(ringProbeSpoke)
                }
            }
        }
        
        let firstLineSegment = meldProbePointBeforeFirst.connections[meldProbePointBeforeFirst.connectionCount - 1].ringLineSegmentLeft!
        let lastLineSegment = meldProbePointAfterLast.connections[0].ringLineSegmentRight!
        meldLocalLineSegmentCount = 0
        
        var fudge = 0
        var lineSegment = firstLineSegment
        while true {
            addMeldLocalLineSegment(lineSegment)
            
            if lineSegment === lastLineSegment {
                break
            } else {
                lineSegment = lineSegment.neighborRight!
            }
            
            fudge += 1
            if fudge >= 64 {
                return false
            }
        }
        
        meldLocalDisjointProbeSegmentCount = 0
        ringProbeSegmentBucket.query(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        
        for bucketProbeSegmentIndex in 0..<ringProbeSegmentBucket.ringProbeSegmentCount {
            let bucketProbeSegment = ringProbeSegmentBucket.ringProbeSegments[bucketProbeSegmentIndex]
            if meldProbePointsContains(ringProbePoint: bucketProbeSegment.ringProbePointLeft) { continue }
            if meldProbePointsContains(ringProbePoint: bucketProbeSegment.ringProbePointRight) { continue }
            if bucketProbeSegment.ringProbePointRight === meldProbePointBeforeFirst { continue }
            if bucketProbeSegment.ringProbePointLeft === meldProbePointAfterLast { continue }
            addMeldLocalDisjointProbeSegment(bucketProbeSegment)
        }
        
        var centerX = Float(0.0)
        var centerY = Float(0.0)
        for meldProbePointIndex in 0..<meldProbePointCount {
            let meldProbePoint = meldProbePoints[meldProbePointIndex]
            centerX += meldProbePoint.x
            centerY += meldProbePoint.y
        }
        
        let countf = Float(meldProbePointCount)
        centerX /= countf
        centerY /= countf
        
        for notchIndex in 0..<PolyMeshConstants.meldNotchX.count {
            let possibleMeld = PolyMeshPartsFactory.shared.withdrawPossibleMeld()
            possibleMeld.x = centerX + PolyMeshConstants.meldNotchX[notchIndex]
            possibleMeld.y = centerY + PolyMeshConstants.meldNotchY[notchIndex]
            addPossibleMeld(possibleMeld)
        }
        
        if calculateMeldsFromPossibleMelds(ringProbePointIndex: ringProbePointIndex,
                                           numberOfPointsToMeld: numberOfPointsToMeld) {
            return true
        } else {
            return false
        }
    }
}
