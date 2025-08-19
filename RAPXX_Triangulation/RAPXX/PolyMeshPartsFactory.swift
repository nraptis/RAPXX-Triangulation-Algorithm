//
//  PolyMeshPartsFactory.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/15/23.
//

import Foundation

public class PolyMeshPartsFactory {
    
    public nonisolated(unsafe) static let shared = PolyMeshPartsFactory()
    
    public func dispose() {
        
        rings.removeAll(keepingCapacity: false)
        ringCount = 0
        
        ringPoints.removeAll(keepingCapacity: false)
        ringPointCount = 0
        
        ringLineSegments.removeAll(keepingCapacity: false)
        ringLineSegmentCount = 0
        
        ringProbePoints.removeAll(keepingCapacity: false)
        ringProbePointCount = 0
        
        ringProbeSegments.removeAll(keepingCapacity: false)
        ringProbeSegmentCount = 0
        
        ringProbeSpokes.removeAll(keepingCapacity: false)
        ringProbeSpokeCount = 0
        
        lineSegmentContentions.removeAll(keepingCapacity: false)
        lineSegmentContentionCount = 0
        
        ringSplits.removeAll(keepingCapacity: false)
        ringSplitCount = 0
        
        possibleSplits.removeAll(keepingCapacity: false)
        possibleSplitCount = 0
        
        possibleSplitPairs.removeAll(keepingCapacity: false)
        possibleSplitPairCount = 0
        
        possibleMelds.removeAll(keepingCapacity: false)
        possibleMeldCount = 0
        
        ringMelds.removeAll(keepingCapacity: false)
        ringMeldCount = 0
        
        ringCapOffs.removeAll(keepingCapacity: false)
        ringCapOffCount = 0
        
        ringSweepLines.removeAll(keepingCapacity: false)
        ringSweepLineCount = 0
        
        ringSweepSegments.removeAll(keepingCapacity: false)
        ringSweepSegmentCount = 0
        
        ringSweepCollisions.removeAll(keepingCapacity: false)
        ringSweepCollisionCount = 0
        
        ringSweepPoints.removeAll(keepingCapacity: false)
        ringSweepPointCount = 0
    }
    
    private init() {
        
    }
    
    ////////////////
    ///
    ///
    private var rings = [Ring]()
    var ringCount = 0
    func depositRing(_ ring: Ring) {
        depositRingContent(ring)
        
        while rings.count <= ringCount {
            rings.append(ring)
        }
        
        rings[ringCount] = ring
        ringCount += 1
    }
    
    public func depositRingContent(_ ring: Ring) {
        
        ring.isBroken = false
        ring.purgeSubrings()
        
        ring.purgeRingPoints()
        ring.purgeRingLineSegments()
        ring.purgeProbePoints()
        ring.purgeProbeSegments()
        
        
        ring.ringPointInsidePolygonBucket.reset()
        ring.ringLineSegmentBucket.reset()
        ring.ringProbeSegmentBucket.reset()
        
        ring.purgePossibleSplitPairs()
        ring.purgeRingSplits()
        
        ring.purgeRingSweepLines()
        ring.purgeRingSweepPoints()
        
        ring.purgeRingCapOffs()
        
        ring.purgeMeldProbeSpokes()
        ring.purgePossibleMelds()
        ring.purgeRingMelds()
        
        ring.meldProbePointCount = 0
        ring.meldLocalLineSegmentCount = 0
        ring.meldLocalDisjointProbeSegmentCount = 0
    }
    
    public func withdrawRing(triangleData: PolyMeshTriangleData) -> Ring {
        if ringCount > 0 {
            ringCount -= 1
            let result = rings[ringCount]
            result.triangleData = triangleData
            return result
        }
        return Ring(triangleData: triangleData)
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var ringPoints = [RingPoint]()
    var ringPointCount = 0
    public func depositRingPoint(_ ringPoint: RingPoint) {
        
        ringPoint.isIllegal = false
        
        ringPoint.isCornerOutlier = false
        
        ringPoint.threatLevel = .none
        
        ringPoint.purgeRingLineSegmentContentions()
        ringPoint.purgePossibleSplits()
        
        ringPoint.pinchGateLeftIndex = -1
        ringPoint.pinchGateRightIndex = -1
        ringPoint.pinchGateSpan = 0
        
        while ringPoints.count <= ringPointCount {
            ringPoints.append(ringPoint)
        }
        
        ringPoints[ringPointCount] = ringPoint
        ringPointCount += 1
    }
    
    public func withdrawRingPoint() -> RingPoint {
        if ringPointCount > 0 {
            ringPointCount -= 1
            return ringPoints[ringPointCount]
        }
        return RingPoint()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var ringLineSegments = [RingLineSegment]()
    var ringLineSegmentCount = 0
    
    func depositRingLineSegment(_ ringLineSegment: RingLineSegment) {
        
        ringLineSegment.isIllegal = false
        ringLineSegment.isBucketed = false // This may well have been the midding nugget
        
        while ringLineSegments.count <= ringLineSegmentCount {
            ringLineSegments.append(ringLineSegment)
        }
        ringLineSegments[ringLineSegmentCount] = ringLineSegment
        ringLineSegmentCount += 1
    }
    
    func withdrawRingLineSegment() -> RingLineSegment {
        if ringLineSegmentCount > 0 {
            ringLineSegmentCount -= 1
            return ringLineSegments[ringLineSegmentCount]
        }
        return RingLineSegment()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var ringProbePoints = [RingProbePoint]()
    var ringProbePointCount = 0
    func depositRingProbePoint(_ ringProbePoint: RingProbePoint) {
        
        ringProbePoint.isIllegal = false
        
        ringProbePoint.isMelded = false
        
        ringProbePoint.isButtressCenter = false
        
        ringProbePoint.isRelaxable = false
        ringProbePoint.isRelaxDirectionComputed = false
        
        ringProbePoint.meldContentionCount = 0
        
        ringProbePoint.connectionCount = 0
        
        while ringProbePoints.count <= ringProbePointCount {
            ringProbePoints.append(ringProbePoint)
        }
        
        ringProbePoints[ringProbePointCount] = ringProbePoint
        ringProbePointCount += 1
    }
    
    func withdrawRingProbePoint() -> RingProbePoint {
        if ringProbePointCount > 0 {
            ringProbePointCount -= 1
            return ringProbePoints[ringProbePointCount]
        }
        return RingProbePoint()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var ringProbeSegments = [RingProbeSegment]()
    var ringProbeSegmentCount = 0
    
    func depositRingProbeSegment(_ ringProbeSegment: RingProbeSegment) {
        
        ringProbeSegment.isIllegal = false
        
        while ringProbeSegments.count <= ringProbeSegmentCount {
            ringProbeSegments.append(ringProbeSegment)
        }
        
        ringProbeSegments[ringProbeSegmentCount] = ringProbeSegment
        ringProbeSegmentCount += 1
    }
    
    func withdrawProbeSegment() -> RingProbeSegment {
        if ringProbeSegmentCount > 0 {
            ringProbeSegmentCount -= 1
            return ringProbeSegments[ringProbeSegmentCount]
        }
        return RingProbeSegment()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var lineSegmentContentions = [RingLineSegmentContention]()
    var lineSegmentContentionCount = 0
    func depositRingLineSegmentContention(_ lineSegmentContention: RingLineSegmentContention) {
        while lineSegmentContentions.count <= lineSegmentContentionCount {
            lineSegmentContentions.append(lineSegmentContention)
        }
        
        lineSegmentContentions[lineSegmentContentionCount] = lineSegmentContention
        lineSegmentContentionCount += 1
    }
    func withdrawRingLineSegmentContention() -> RingLineSegmentContention {
        if lineSegmentContentionCount > 0 {
            lineSegmentContentionCount -= 1
            return lineSegmentContentions[lineSegmentContentionCount]
        }
        return RingLineSegmentContention()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var possibleSplits = [PossibleSplit]()
    var possibleSplitCount = 0
    
    func depositPossibleSplit(_ possibleSplit: PossibleSplit) {
        while possibleSplits.count <= possibleSplitCount {
            possibleSplits.append(possibleSplit)
        }
        
        possibleSplits[possibleSplitCount] = possibleSplit
        possibleSplitCount += 1
    }
    
    func withdrawPossibleSplit() -> PossibleSplit {
        if possibleSplitCount > 0 {
            possibleSplitCount -= 1
            return possibleSplits[possibleSplitCount]
        }
        return PossibleSplit()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var possibleSplitPairs = [PossibleSplitPair]()
    var possibleSplitPairCount = 0
    func depositPossibleSplitPair(_ possibleSplitPair: PossibleSplitPair) {
        while possibleSplitPairs.count <= possibleSplitPairCount {
            possibleSplitPairs.append(possibleSplitPair)
        }
        possibleSplitPairs[possibleSplitPairCount] = possibleSplitPair
        possibleSplitPairCount += 1
    }
    func withdrawPossibleSplitPair() -> PossibleSplitPair {
        if possibleSplitPairCount > 0 {
            possibleSplitPairCount -= 1
            return possibleSplitPairs[possibleSplitPairCount]
        }
        return PossibleSplitPair()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var ringSplits = [RingSplit]()
    var ringSplitCount = 0
    func depositRingSplit(_ ringSplit: RingSplit) {
        while ringSplits.count <= ringSplitCount {
            ringSplits.append(ringSplit)
        }
        ringSplits[ringSplitCount] = ringSplit
        ringSplitCount += 1
    }
    func withdrawRingSplit() -> RingSplit {
        if ringSplitCount > 0 {
            ringSplitCount -= 1
            return ringSplits[ringSplitCount]
        }
        return RingSplit()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var ringProbeSpokes = [RingProbeSpoke]()
    var ringProbeSpokeCount = 0
    func depositRingProbeSpoke(_ ringProbeSpoke: RingProbeSpoke) {
        
        while ringProbeSpokes.count <= ringProbeSpokeCount {
            ringProbeSpokes.append(ringProbeSpoke)
        }
        ringProbeSpokes[ringProbeSpokeCount] = ringProbeSpoke
        ringProbeSpokeCount += 1
        
    }
    func withdrawRingProbeSpoke() -> RingProbeSpoke {
        if ringProbeSpokeCount > 0 {
            ringProbeSpokeCount -= 1
            return ringProbeSpokes[ringProbeSpokeCount]
        }
        return RingProbeSpoke()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var possibleMelds = [PossibleMeld]()
    var possibleMeldCount = 0
    func depositPossibleMeld(_ possibleMeld: PossibleMeld) {
        
        while possibleMelds.count <= possibleMeldCount {
            possibleMelds.append(possibleMeld)
        }
        possibleMelds[possibleMeldCount] = possibleMeld
        possibleMeldCount += 1
    }
    func withdrawPossibleMeld() -> PossibleMeld {
        if possibleMeldCount > 0 {
            possibleMeldCount -= 1
            return possibleMelds[possibleMeldCount]
        }
        return PossibleMeld()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var ringMelds = [RingMeld]()
    var ringMeldCount = 0
    
    func depositRingMeld(_ ringMeld: RingMeld) {
        ringMeld.ringProbePointCount = 0
        
        while ringMelds.count <= ringMeldCount {
            ringMelds.append(ringMeld)
        }
        ringMelds[ringMeldCount] = ringMeld
        ringMeldCount += 1
    }
    
    func withdrawRingMeld() -> RingMeld {
        if ringMeldCount > 0 {
            ringMeldCount -= 1
            return ringMelds[ringMeldCount]
        }
        return RingMeld()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var ringCapOffs = [RingCapOff]()
    var ringCapOffCount = 0
    
    func depositRingCapOff(_ ringCapOff: RingCapOff) {
        while ringCapOffs.count <= ringCapOffCount {
            ringCapOffs.append(ringCapOff)
        }
        ringCapOffs[ringCapOffCount] = ringCapOff
        ringCapOffCount += 1
    }
    
    func withdrawRingCapOff() -> RingCapOff {
        if ringCapOffCount > 0 {
            ringCapOffCount -= 1
            return ringCapOffs[ringCapOffCount]
        }
        return RingCapOff()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var ringSweepLines = [RingSweepLine]()
    var ringSweepLineCount = 0
    func depositRingSweepLine(_ ringSweepLine: RingSweepLine) {
        ringSweepLine.purgeRingSweepSegments()
        ringSweepLine.purgeRingSweepCollisions()
        
        while ringSweepLines.count <= ringSweepLineCount {
            ringSweepLines.append(ringSweepLine)
        }
        ringSweepLines[ringSweepLineCount] = ringSweepLine
        ringSweepLineCount += 1
    }
    
    func withdrawRingSweepLine() -> RingSweepLine {
        if ringSweepLineCount > 0 {
            ringSweepLineCount -= 1
            return ringSweepLines[ringSweepLineCount]
        }
        return RingSweepLine()
    }
    ///
    ///
    ////////////////
    
    ////////////////
    ///
    ///
    private var ringSweepSegments = [RingSweepSegment]()
    var ringSweepSegmentCount = 0
    func depositRingSweepSegment(_ ringSweepSegment: RingSweepSegment) {
        while ringSweepSegments.count <= ringSweepSegmentCount {
            ringSweepSegments.append(ringSweepSegment)
        }
        ringSweepSegments[ringSweepSegmentCount] = ringSweepSegment
        ringSweepSegmentCount += 1
    }
    
    func withdrawRingSweepSegment() -> RingSweepSegment {
        if ringSweepSegmentCount > 0 {
            ringSweepSegmentCount -= 1
            return ringSweepSegments[ringSweepSegmentCount]
        }
        return RingSweepSegment()
    }
    ///
    ///
    ////////////////
    
    
    
    ////////////////
    ///
    ///
    private var ringSweepCollisions = [RingSweepCollision]()
    var ringSweepCollisionCount = 0
    
    func depositRingSweepCollision(_ ringSweepCollision: RingSweepCollision) {
        
        while ringSweepCollisions.count <= ringSweepCollisionCount {
            ringSweepCollisions.append(ringSweepCollision)
        }
        ringSweepCollisions[ringSweepCollisionCount] = ringSweepCollision
        ringSweepCollisionCount += 1
    }
    
    func withdrawRingSweepCollision() -> RingSweepCollision {
        if ringSweepCollisionCount > 0 {
            ringSweepCollisionCount -= 1
            return ringSweepCollisions[ringSweepCollisionCount]
        }
        return RingSweepCollision()
    }
    ///
    ///
    ////////////////
    
    
    ////////////////
    ///
    ///
    private var ringSweepPoints = [RingSweepPoint]()
    var ringSweepPointCount = 0
    
    func depositRingSweepPoint(_ ringSweepPoint: RingSweepPoint) {
        while ringSweepPoints.count <= ringSweepPointCount {
            ringSweepPoints.append(ringSweepPoint)
        }
        ringSweepPoints[ringSweepPointCount] = ringSweepPoint
        ringSweepPointCount += 1
    }
    
    func withdrawRingSweepPoint() -> RingSweepPoint {
        if ringSweepPointCount > 0 {
            ringSweepPointCount -= 1
            return ringSweepPoints[ringSweepPointCount]
        }
        return RingSweepPoint()
    }
    ///
    ///
    ////////////////
    
}
