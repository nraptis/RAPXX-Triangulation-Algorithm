//
//  Ring.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/6/24.
//

import Foundation

public class Ring {
    
    static let maxPointCount = 256
    
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    
    public var ringPoints = [RingPoint]()
    public var ringPointCount = 0
    func addRingPoint(_ ringPoint: RingPoint) {
        while ringPoints.count <= ringPointCount {
            ringPoints.append(ringPoint)
        }
        ringPoints[ringPointCount] = ringPoint
        ringPointCount += 1
    }
    
    func removeRingPoint(_ index: Int) {
        if index >= 0 && index < ringPointCount {
            PolyMeshPartsFactory.shared.depositRingPoint(ringPoints[index])
            let ringPointCount1 = ringPointCount - 1
            var ringPointIndex = index
            while ringPointIndex < ringPointCount1 {
                ringPoints[ringPointIndex] = ringPoints[ringPointIndex + 1]
                ringPointIndex += 1
            }
            ringPointCount -= 1
        }
    }
    
    public var ringLineSegments = [RingLineSegment]()
    public var ringLineSegmentCount = 0
    func addRingLineSegment() {
        let ringLineSegment = PolyMeshPartsFactory.shared.withdrawRingLineSegment()
        while ringLineSegments.count <= ringLineSegmentCount {
            ringLineSegments.append(ringLineSegment)
        }
        ringLineSegments[ringLineSegmentCount] = ringLineSegment
        ringLineSegmentCount += 1
    }

    func addRingLineSegment(_ ringLineSegment: RingLineSegment) {
        while ringLineSegments.count <= ringLineSegmentCount {
            ringLineSegments.append(ringLineSegment)
        }
        ringLineSegments[ringLineSegmentCount] = ringLineSegment
        ringLineSegmentCount += 1
    }
    
    var ringProbePoints = [RingProbePoint]()
    var ringProbePointCount = 0
    func addRingProbePoint(_ ringProbePoint: RingProbePoint) {
        while ringProbePoints.count <= ringProbePointCount {
            ringProbePoints.append(ringProbePoint)
        }
        ringProbePoints[ringProbePointCount] = ringProbePoint
        ringProbePointCount += 1
    }
    
    var ringProbeSegments = [RingProbeSegment]()
    var ringProbeSegmentCount = 0
    func addRingProbeSegment(_ ringProbeSegment: RingProbeSegment) {
        while ringProbeSegments.count <= ringProbeSegmentCount {
            ringProbeSegments.append(ringProbeSegment)
        }
        ringProbeSegments[ringProbeSegmentCount] = ringProbeSegment
        ringProbeSegmentCount += 1
    }
    
    let ringPointInsidePolygonBucket = RingPointInsidePolygonBucket()
    
    let ringLineSegmentBucket = RingLineSegmentBucket()
    let ringProbeSegmentBucket = RingProbeSegmentBucket()
    
    weak var triangleData: PolyMeshTriangleData?
    init(triangleData: PolyMeshTriangleData) {
        self.triangleData = triangleData
    }
    
    func buildRingPointInsidePolygonBucket() {
        ringPointInsidePolygonBucket.build(ringLineSegments: ringLineSegments, ringLineSegmentCount: ringLineSegmentCount)
    }
    
    //@Precondition: calculateLineSegments
    func buildLineSegmentBucket() {
        ringLineSegmentBucket.build(ringLineSegments: ringLineSegments, ringLineSegmentCount: ringLineSegmentCount)
    }
    
    //@Precondition: calculateProbeSegmentsUsingProbePoints
    func buildRingProbeSegmentBucket() {
        ringProbeSegmentBucket.build(ringProbeSegments: ringProbeSegments, ringProbeSegmentCount: ringProbeSegmentCount)
    }
    
    func setAllProbePointsIllegalToFalse() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.isIllegal = false
        }
    }
    
    func setAllProbePointsMeldedToFalse() {
        for ringProbePointIndex in 0..<ringProbePointCount {
            let ringProbePoint = ringProbePoints[ringProbePointIndex]
            ringProbePoint.isMelded = false
        }
    }
    
    public var isBroken = false
    
    let preComputedLineSegment1 = AnyPrecomputedLineSegment()
    let preComputedLineSegment2 = AnyPrecomputedLineSegment()
    let preComputedLineSegment3 = AnyPrecomputedLineSegment()
    let preComputedLineSegment4 = AnyPrecomputedLineSegment()
    
    public var subrings = [Ring]()
    public var subringCount = 0
    func addSubring(_ subring: Ring) {
        while subrings.count <= subringCount {
            subrings.append(subring)
        }
        subrings[subringCount] = subring
        subringCount += 1
        
        //subring.parent = self
    }
    func purgeSubrings() {
        for subringIndex in 0..<subringCount {
            let subring = subrings[subringIndex]
            PolyMeshPartsFactory.shared.depositRing(subring)
        }
        subringCount = 0
    }
    
    //weak var parent: Ring?
    
    var temp_1_ringPoints = [RingPoint]()
    var temp_1_ringPointCount = 0
    func addTemp_1_RingPoint(_ ringPoint: RingPoint) {
        while temp_1_ringPoints.count <= temp_1_ringPointCount {
            temp_1_ringPoints.append(ringPoint)
        }
        temp_1_ringPoints[temp_1_ringPointCount] = ringPoint
        temp_1_ringPointCount += 1
    }
    
    var temp_1_ringLineSegments = [RingLineSegment]()
    var temp_1_ringLineSegmentCount = 0
    func addTemp_1_RingLineSegment(_ ringLineSegment: RingLineSegment) {
        while temp_1_ringLineSegments.count <= temp_1_ringLineSegmentCount {
            temp_1_ringLineSegments.append(ringLineSegment)
        }
        temp_1_ringLineSegments[temp_1_ringLineSegmentCount] = ringLineSegment
        temp_1_ringLineSegmentCount += 1
    }
    
    var temp_1_ringProbePoints = [RingProbePoint]()
    var temp_1_ringProbePointCount = 0
    func addTemp_1_RingProbePoint(_ ringProbePoint: RingProbePoint) {
        while temp_1_ringProbePoints.count <= temp_1_ringProbePointCount {
            temp_1_ringProbePoints.append(ringProbePoint)
        }
        temp_1_ringProbePoints[temp_1_ringProbePointCount] = ringProbePoint
        temp_1_ringProbePointCount += 1
    }
    
    var temp_2_ringProbePoints = [RingProbePoint]()
    var temp_2_ringProbePointCount = 0
    func addTemp_2_RingProbePoint(_ ringProbePoint: RingProbePoint) {
        while temp_2_ringProbePoints.count <= temp_2_ringProbePointCount {
            temp_2_ringProbePoints.append(ringProbePoint)
        }
        temp_2_ringProbePoints[temp_2_ringProbePointCount] = ringProbePoint
        temp_2_ringProbePointCount += 1
    }
    
    var temp_1_ringProbeSegments = [RingProbeSegment]()
    var temp_1_ringProbeSegmentCount = 0
    func addTemp_1_RingProbeSegment(_ ringProbeSegment: RingProbeSegment) {
        while temp_1_ringProbeSegments.count <= temp_1_ringProbeSegmentCount {
            temp_1_ringProbeSegments.append(ringProbeSegment)
        }
        temp_1_ringProbeSegments[temp_1_ringProbeSegmentCount] = ringProbeSegment
        temp_1_ringProbeSegmentCount += 1
    }
    
    var tempRingSplitQuality = RingSplitQuality()
    
    var possibleSplitPairs = [PossibleSplitPair]()
    var possibleSplitPairCount = 0
    
    func addPossibleSplitPair(_ possibleSplitPair: PossibleSplitPair) {
        while possibleSplitPairs.count <= possibleSplitPairCount {
            possibleSplitPairs.append(possibleSplitPair)
        }
        possibleSplitPairs[possibleSplitPairCount] = possibleSplitPair
        possibleSplitPairCount += 1
    }
    
    func possibleSplitPairsContains(ringPoint1: RingPoint,
                                    ringPoint2: RingPoint) -> Bool {
        for possibleSplitPairIndex in 0..<possibleSplitPairCount {
            let possibleSplitPair = possibleSplitPairs[possibleSplitPairIndex]
            if possibleSplitPair.ringPoint1 === ringPoint1 && possibleSplitPair.ringPoint2 === ringPoint2 {
                return true
            }
        }
        return false
    }
    
    var ringSplits = [RingSplit]()
    var ringSplitCount = 0
    func addRingSplit(_ ringSplit: RingSplit) {
        while ringSplits.count <= ringSplitCount {
            ringSplits.append(ringSplit)
        }
        ringSplits[ringSplitCount] = ringSplit
        ringSplitCount += 1
    }
    func removeRingSplit(_ ringSplit: RingSplit) {
        for checkIndex in 0..<ringSplitCount {
            if ringSplits[checkIndex] === ringSplit {
                removeRingSplit(checkIndex)
                return
            }
        }
    }
    func removeRingSplit(_ index: Int) {
        if index >= 0 && index < ringSplitCount {
            let ringSplitCount1 = ringSplitCount - 1
            var ringSplitIndex = index
            while ringSplitIndex < ringSplitCount1 {
                ringSplits[ringSplitIndex] = ringSplits[ringSplitIndex + 1]
                ringSplitIndex += 1
            }
            ringSplitCount -= 1
        }
    }
    
    var meldProbePoints = [RingProbePoint]()
    var meldProbePointCount = 0
    func addMeldProbePoint(_ ringProbePoint: RingProbePoint) {
        while meldProbePoints.count <= meldProbePointCount {
            meldProbePoints.append(ringProbePoint)
        }
        meldProbePoints[meldProbePointCount] = ringProbePoint
        meldProbePointCount += 1
    }
    
    var meldLocalLineSegments = [RingLineSegment]()
    var meldLocalLineSegmentCount = 0
    func addMeldLocalLineSegment(_ ringLineSegment: RingLineSegment) {
        while meldLocalLineSegments.count <= meldLocalLineSegmentCount {
            meldLocalLineSegments.append(ringLineSegment)
        }
        meldLocalLineSegments[meldLocalLineSegmentCount] = ringLineSegment
        meldLocalLineSegmentCount += 1
    }
    
    var meldLocalDisjointProbeSegments = [RingProbeSegment]()
    var meldLocalDisjointProbeSegmentCount = 0
    func addMeldLocalDisjointProbeSegment(_ ringProbeSegment: RingProbeSegment) {
        while meldLocalDisjointProbeSegments.count <= meldLocalDisjointProbeSegmentCount {
            meldLocalDisjointProbeSegments.append(ringProbeSegment)
        }
        meldLocalDisjointProbeSegments[meldLocalDisjointProbeSegmentCount] = ringProbeSegment
        meldLocalDisjointProbeSegmentCount += 1
    }
    
    var meldProbeSpokes = [RingProbeSpoke]()
    var meldProbeSpokeCount = 0
    func addMeldProbeSpoke(_ ringProbeSpoke: RingProbeSpoke) {
        while meldProbeSpokes.count <= meldProbeSpokeCount {
            meldProbeSpokes.append(ringProbeSpoke)
        }
        meldProbeSpokes[meldProbeSpokeCount] = ringProbeSpoke
        meldProbeSpokeCount += 1
    }
    
    func removeMeldProbeSpoke(_ connection: RingPoint) {
        for meldProbeSpokeIndex in 0..<meldProbeSpokeCount {
            let meldProbeSpoke = meldProbeSpokes[meldProbeSpokeIndex]
            if meldProbeSpoke.connection === connection {
                removeMeldProbeSpoke(meldProbeSpokeIndex)
                return
            }
        }
    }
    
    func removeMeldProbeSpoke(_ index: Int) {
        if index >= 0 && index < meldProbeSpokeCount {
            PolyMeshPartsFactory.shared.depositRingProbeSpoke(meldProbeSpokes[index])
            let meldProbeSpokeCount1 = meldProbeSpokeCount - 1
            var meldProbeSpokeIndex = index
            while meldProbeSpokeIndex < meldProbeSpokeCount1 {
                meldProbeSpokes[meldProbeSpokeIndex] = meldProbeSpokes[meldProbeSpokeIndex + 1]
                meldProbeSpokeIndex += 1
            }
            meldProbeSpokeCount -= 1
        }
    }
    
    var possibleMelds = [PossibleMeld]()
    var possibleMeldCount = 0
    func addPossibleMeld(_ possibleMeld: PossibleMeld) {
        while possibleMelds.count <= possibleMeldCount {
            possibleMelds.append(possibleMeld)
        }
        possibleMelds[possibleMeldCount] = possibleMeld
        possibleMeldCount += 1
    }
    
    var ringMelds = [RingMeld]()
    var ringMeldCount = 0
    func addRingMeld(_ ringMeld: RingMeld) {
        while ringMelds.count <= ringMeldCount {
            ringMelds.append(ringMeld)
        }
        ringMelds[ringMeldCount] = ringMeld
        ringMeldCount += 1
    }
    
    func meldProbePointsContains(ringProbePoint: RingProbePoint) -> Bool {
        var meldProbePointIndex = 0
        while meldProbePointIndex < meldProbePointCount {
            if meldProbePoints[meldProbePointIndex] === ringProbePoint {
                return true
            }
            meldProbePointIndex += 1
        }
        return false
    }
    
    func meldProbeSpokesContainsConnection(_ connection: RingPoint) -> Bool {
        var meldProbeSpokeIndex = 0
        while meldProbeSpokeIndex < meldProbeSpokeCount {
            if meldProbeSpokes[meldProbeSpokeIndex].connection === connection {
                return true
            }
            meldProbeSpokeIndex += 1
        }
        return false
    }
    
    var ringCapOffs = [RingCapOff]()
    var ringCapOffCount = 0
    func addRingCapOff(_ ringCapOff: RingCapOff) {
        while ringCapOffs.count <= ringCapOffCount {
            ringCapOffs.append(ringCapOff)
        }
        ringCapOffs[ringCapOffCount] = ringCapOff
        ringCapOffCount += 1
    }
    
    var isHorizontalSweepLines = false
    
    var ringSweepLines = [RingSweepLine]()
    var ringSweepLineCount = 0
    func addRingSweepLine(_ ringSweepLine: RingSweepLine) {
        while ringSweepLines.count <= ringSweepLineCount {
            ringSweepLines.append(ringSweepLine)
        }
        ringSweepLines[ringSweepLineCount] = ringSweepLine
        ringSweepLineCount += 1
    }
    
    
    var ringSweepPoints = [RingSweepPoint]()
    var ringSweepPointCount = 0
    func addRingSweepPoint(_ ringSweepPoint: RingSweepPoint) {
        while ringSweepPoints.count <= ringSweepPointCount {
            ringSweepPoints.append(ringSweepPoint)
        }
        ringSweepPoints[ringSweepPointCount] = ringSweepPoint
        ringSweepPointCount += 1
    }
    
    var splitQuality = RingSplitQuality()
    
    var depth: UInt32 = 0
    
    public func addPointsBegin(depth: UInt32) {
        self.depth = depth
        purgeRingPoints()
    }
    
    public func addPoint(x: Float,
                  y: Float,
                  controlIndex: Int) {
        let newRingPoint = PolyMeshPartsFactory.shared.withdrawRingPoint()
        newRingPoint.x = x
        newRingPoint.y = y
        newRingPoint.controlIndex = controlIndex
        newRingPoint.ringIndex = ringPointCount
        addRingPoint(newRingPoint)
    }
    
    func addPointFastSplit(_ ringPoint: RingPoint) {
        let newRingPoint = PolyMeshPartsFactory.shared.withdrawRingPoint()
        ringPoint.writeToFastSplit(newRingPoint)
        newRingPoint.ringIndex = ringPointCount
        addRingPoint(newRingPoint)
    }
    
    public func attemptToBeginBuildAndCheckIfBroken(needsPointInsidePolygonBucket: Bool,
                                             needsLineSegmentBucket: Bool,
                                             ignoreDuplicates: Bool) -> Bool {
        if ringPointCount < 3 {
            isBroken = true
            return false
        }
        
        if !ignoreDuplicates {
            if containsDuplicatePointsOuter() {
                isBroken = true
                return false
            }
        }
        
        if containsTooFewPoints() {
            isBroken = true
            return false
        }
        
        if isCounterClockwiseRingPoints() {
            isBroken = true
            return false
        }
        
        if !attemptCalculateBasicsAndDetermineSafetyPartA(test: false) {
            return false
        }
        
        if !attemptCalculateBasicsAndDetermineSafetyPartB(needsPointInsidePolygonBucket: needsPointInsidePolygonBucket,
                                                   needsLineSegmentBucket: needsLineSegmentBucket,
                                                   test: false) {
            return false
        }
        
        
        return true
    }
    
    func attemptCalculateBasicsAndDetermineSafetyPartA(test: Bool) -> Bool {
    
        if ringPointCount < 3 {
            isBroken = true
            return false
        }
        
        calculateRingPointNeighborsAndIndices()
        
        if !attemptCalculateLineSegments() {
            isBroken = true
            return false
        }
        
        if !attemptCalculateRingPointNormals() {
            isBroken = true
            return false
        }
        
        if !attemptCalculateRingPointAngularSpans() {
            isBroken = true
            return false
        }
        return true
    }
    
    func attemptCalculateBasicsAndDetermineSafetyPartB(needsPointInsidePolygonBucket: Bool, needsLineSegmentBucket: Bool, test: Bool) -> Bool {
        
        if needsPointInsidePolygonBucket {
            buildRingPointInsidePolygonBucket()
        }
        
        if needsLineSegmentBucket {
            buildLineSegmentBucket()
        }
        
        if isComplexLineSegments() {
            isBroken = true
            return false
        }
        
        if isCounterClockwiseRingPoints() {
            isBroken = true
            return false
        }
        
        return true
    }
    
    func calculatePointCornerOutliers() {
        let outlierDistanceThreshold = (PolyMeshConstants.ringInsetAmountThreatNone * 1.25)
        let outlierDistanceThresholdSquared = outlierDistanceThreshold * outlierDistanceThreshold
        
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            
            if ringPoint.angularSpan > Math.pi4_3 {
                ringPoint.isCornerOutlier = true
            } else {
                
                let cornerPointX = ringPoint.probeSegmentForCollider.colliderPointX
                let cornerPointY = ringPoint.probeSegmentForCollider.colliderPointY
                
                let distanceSquared = ringPoint.distanceSquared(x: cornerPointX, y: cornerPointY)
                
                if ringPoint.angularSpan > Math.pi {
                    if distanceSquared > outlierDistanceThresholdSquared {
                        ringPoint.isCornerOutlier = true
                    } else {
                        ringPoint.isCornerOutlier = false
                    }
                } else {
                    ringPoint.isCornerOutlier = false
                }
            }
        }
    }
    
    func indexOfProbePoint(_ ringProbePoint: RingProbePoint) -> Int? {
        for ringProbePointIndex in 0..<ringProbePointCount {
            if ringProbePoints[ringProbePointIndex] === ringProbePoint {
                return ringProbePointIndex
            }
        }
        return nil
    }
    
    func indexOfRingPoint(_ ringPoint: RingPoint) -> Int? {
        for ringPointIndex in 0..<ringPointCount {
            if ringPoints[ringPointIndex] === ringPoint {
                return ringPointIndex
            }
        }
        return nil
    }
    
    func getRingPoint(at index: UInt16) -> RingPoint? {
        if index >= 0 && index < ringPointCount {
            return ringPoints[Int(index)]
        }
        return nil
    }
    
    func getRingPoint(at index: Int) -> RingPoint? {
        if index >= 0 && index < ringPointCount {
            return ringPoints[index]
        }
        return nil
    }
    
    func getRingLineSegment(at index: UInt16) -> RingLineSegment? {
        if index >= 0 && index < ringLineSegmentCount {
            return ringLineSegments[Int(index)]
        }
        return nil
    }
    
    func getRingLineSegment(at index: Int) -> RingLineSegment? {
        if index >= 0 && index < ringLineSegmentCount {
            return ringLineSegments[index]
        }
        return nil
    }
    
    
    public func meshifyRecursively(needsSafetyCheckA: Bool, needsSafetyCheckB: Bool) {
        
        if needsSafetyCheckA {
            if !attemptCalculateBasicsAndDetermineSafetyPartA(test: false) {
                meshifyWithSafeAlgorithm()
                return
            }
        }
        
        var continueToClipEars = true
        var didClipEar = false
        var earClipCount = 0
        while continueToClipEars == true && ringPointCount >= 3 {
            earClipCount += 1
            continueToClipEars = attemptToClipEar()
            if continueToClipEars {
                didClipEar = true
            }
        }
        
        
        //Self.debugRing(self)
        
        
        if didClipEar {
            if !attemptCalculateBasicsAndDetermineSafetyPartA(test: false) {
                meshifyWithSafeAlgorithm()
                return
            }
        }
        
        if didClipEar || needsSafetyCheckB {
            
            //fixRingPointAndLineSegmentAdjacency()
            
            if !attemptCalculateBasicsAndDetermineSafetyPartB(needsPointInsidePolygonBucket: true,
                                                       needsLineSegmentBucket: true,
                                                       test: false) {
                meshifyWithSafeAlgorithm()
                return
            }
        }
        
        if attemptCapOffIfSmallEnough() {
            return
        }
        
        calculateRingPointPinchGates()
        
        buildRingPointInsidePolygonBucket()
        buildLineSegmentBucket()
        
        calculateRingLineSegmentContentions()
        
        calculatePossibleSplits()
        
        if calculateRingSplitsAndExecuteInstantSplitIfExists() {
            for subringIndex in 0..<subringCount {
                let subring = subrings[subringIndex]
                subring.meshifyRecursively(needsSafetyCheckA: false,
                                           needsSafetyCheckB: false)
            }
            return
        }
        
        if attemptInset(needsContentions: false) {
            for subringIndex in 0..<subringCount {
                let subring = subrings[subringIndex]
                subring.meshifyRecursively(needsSafetyCheckA: false,
                                           needsSafetyCheckB: false)
            }
            return
        } else {
            // We can try one of the remaining splits...
            
            //os_signpost(.begin, log: ringMeshifyLog, name: "best_split")
            if executeBestSplitPossible() {
                //os_signpost(.end, log: ringMeshifyLog, name: "best_split")
                
                for subringIndex in 0..<subringCount {
                    let subring = subrings[subringIndex]
                    subring.meshifyRecursively(needsSafetyCheckA: false,
                                               needsSafetyCheckB: false)
                }
                return
            } else {
                //os_signpost(.end, log: ringMeshifyLog, name: "best_split")
                
                meshifyWithSafeAlgorithm()
                
            }
        }
    }
    
}

