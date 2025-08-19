//
//  PolyMeshPoint.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/15/23.
//

import Foundation

public class RingPoint: PointProtocol {
    
    typealias ThreatLevel = RingLineSegment.ThreatLevel
    
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    
    public var x = Float(0.0)
    public var y = Float(0.0)
    public var controlIndex = 0
    
    var isIllegal = false
    var isChecked = false
    
    var isCornerOutlier = false
    
    var baseProbeX = Float(0.0)
    var baseProbeY = Float(0.0)
    var baseProbeLength = Float(0.0)
    
    var triangleIndex = UInt32(0)
    
    var ringIndex: Int = 0
    
    var angularSpan = Float(0.0)
    
    var threatLevel = ThreatLevel.none
    
    unowned var ringLineSegmentLeft: RingLineSegment!
    unowned var ringLineSegmentRight: RingLineSegment!
    
    unowned var probeSegmentForCollider: RingProbeSegment!
    
    unowned var neighborLeft: RingPoint!
    unowned var neighborRight: RingPoint!
    
    var lineSegmentContentions = [RingLineSegmentContention]()
    var lineSegmentContentionCount = 0
    func addRingLineSegmentContention(_ lineSegmentContention: RingLineSegmentContention) {
        while lineSegmentContentions.count <= lineSegmentContentionCount {
            lineSegmentContentions.append(lineSegmentContention)
        }
        lineSegmentContentions[lineSegmentContentionCount] = lineSegmentContention
        lineSegmentContentionCount += 1
    }
    func purgeRingLineSegmentContentions() {
        for lineSegmentContentionIndex in 0..<lineSegmentContentionCount {
            let lineSegmentContention = lineSegmentContentions[lineSegmentContentionIndex]
            PolyMeshPartsFactory.shared.depositRingLineSegmentContention(lineSegmentContention)
        }
        lineSegmentContentionCount = 0
    }
    
    var possibleSplits = [PossibleSplit]()
    var possibleSplitCount = 0
    func addPossibleSplit(_ possibleSplit: PossibleSplit) {
        while possibleSplits.count <= possibleSplitCount {
            possibleSplits.append(possibleSplit)
        }
        possibleSplits[possibleSplitCount] = possibleSplit
        possibleSplitCount += 1
    }
    
    func possibleSplitsContains(ringPoint: RingPoint) -> Bool {
        for possibleSplitIndex in 0..<possibleSplitCount {
            if possibleSplits[possibleSplitIndex].ringPoint === ringPoint {
                return true
            }
        }
        return false
    }
    
    func purgePossibleSplits() {
        for possibleSplitIndex in 0..<possibleSplitCount {
            let possibleSplit = possibleSplits[possibleSplitIndex]
            PolyMeshPartsFactory.shared.depositPossibleSplit(possibleSplit)
        }
        possibleSplitCount = 0
    }
    
    var pinchGateLeftIndex = -1
    var pinchGateRightIndex = -1
    var pinchGateSpan = 0
    
    var directionX = Float(0.0)
    var directionY = Float(-1.0)
    
    var normalX = Float(1.0)
    var normalY = Float(0.0)
    
    var normalAngle = Float(0.0)

    var point: Point {
        Point(x: x, y: y)
    }
    
    func distanceSquared(x: Float, y: Float) -> Float {
        let diffX = x - self.x
        let diffY = y - self.y
        return diffX * diffX + diffY * diffY
    }
    
    func distanceSquared(ringPoint: RingPoint) -> Float {
        let diffX = ringPoint.x - x
        let diffY = ringPoint.y - y
        return diffX * diffX + diffY * diffY
    }

    func writeToFastSplit(_ ringPoint: RingPoint) {
        ringPoint.x = x
        ringPoint.y = y
        ringPoint.angularSpan = angularSpan
        ringPoint.directionX = directionX
        ringPoint.directionY = directionY
        ringPoint.normalX = normalX
        ringPoint.normalY = normalY
        ringPoint.normalAngle = normalAngle
        ringPoint.isIllegal = isIllegal
    }
}
