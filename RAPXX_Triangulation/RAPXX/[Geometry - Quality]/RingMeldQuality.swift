//
//  RingMeldQuality.swift
//  RAPXX
//
//  Created by Nick Raptis on 1/17/24.
//

import Foundation

struct RingMeldQuality: Hashable {
    static func == (lhs: RingMeldQuality, rhs: RingMeldQuality) -> Bool {
        if lhs.maxDistanceToLineSegment != rhs.maxDistanceToLineSegment { return false }
        if lhs.maxSpokeLength != rhs.maxSpokeLength { return false }
        if lhs.minSpokeAngle != rhs.minSpokeAngle { return false }
        if lhs.minEdgeAngle != rhs.minEdgeAngle { return false }
        if lhs.wedgeAngle != rhs.wedgeAngle { return false }
        if lhs.maxEdgeLength != rhs.maxEdgeLength { return false }
        return true
    }
    
    var maxDistanceToLineSegment = QualityGrade.great
    var maxSpokeLength = QualityGrade.great
    var minSpokeAngle = QualityGrade.great
    var minEdgeAngle = QualityGrade.great
    var wedgeAngle = QualityGrade.great
    var maxEdgeLength = QualityGrade.great
    
    private(set) var weight = 0
    mutating func calculateWeight() {
        weight = Self.calculateWeight(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(maxDistanceToLineSegment)
        hasher.combine(maxSpokeLength)
        hasher.combine(minSpokeAngle)
        hasher.combine(minEdgeAngle)
        hasher.combine(wedgeAngle)
        hasher.combine(maxEdgeLength)
    }
    
    static let meldQualityMaxDistanceToLineSegmentBroken = Float(24.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxDistanceToLineSegmentLow = Float(22.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxDistanceToLineSegmentNormal = Float(20.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxDistanceToLineSegmentGood = Float(18.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxDistanceToLineSegmentGreat = Float(16.0) * PolyMeshConstants.SCALE
    
    static let meldQualityMaxSpokeLengthBroken = Float(36.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxSpokeLengthLow = Float(32.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxSpokeLengthNormal = Float(28.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxSpokeLengthGood = Float(24.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxSpokeLengthGreat = Float(20.0) * PolyMeshConstants.SCALE

    static let meldQualityMinSpokeAngleThresholdGreat = Math.pi_6
    static let meldQualityMinSpokeAngleThresholdGood = Math.pi_8
    static let meldQualityMinSpokeAngleThresholdNormal = Math.pi_10
    static let meldQualityMinSpokeAngleThresholdLow = Math.pi_12
    static let meldQualityMinSpokeAngleThresholdBroken = Math.pi_14
    
    static let meldQualityMinEdgeAngleThresholdGreat = Math.pi_6
    static let meldQualityMinEdgeAngleThresholdGood = Math.pi_8
    static let meldQualityMinEdgeAngleThresholdNormal = Math.pi_10
    static let meldQualityMinEdgeAngleThresholdLow = Math.pi_12
    static let meldQualityMinEdgeAngleThresholdBroken = Math.pi_14
    
    static let meldQualityWedgeAngleThresholdGreat = Math.pi_4
    static let meldQualityWedgeAngleThresholdGood = Math.pi_6
    static let meldQualityWedgeAngleThresholdNormal = Math.pi_8
    static let meldQualityWedgeAngleThresholdLow = Math.pi_10
    static let meldQualityWedgeAngleThresholdBroken = Math.pi_12
    
    static let meldQualityMaxEdgeLengthBroken = Float(24.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxEdgeLengthLow = Float(22.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxEdgeLengthNormal = Float(20.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxEdgeLengthGood = Float(18.0) * PolyMeshConstants.SCALE
    static let meldQualityMaxEdgeLengthGreat = Float(16.0) * PolyMeshConstants.SCALE
    
    static func classifyMaxDistanceToLineSegment(_ distanceSquared: Float) -> QualityGrade {
        if distanceSquared < (Self.meldQualityMaxDistanceToLineSegmentGreat * Self.meldQualityMaxDistanceToLineSegmentGreat) {
            return .excellent
        } else if distanceSquared < (Self.meldQualityMaxDistanceToLineSegmentGood * Self.meldQualityMaxDistanceToLineSegmentGood) {
            return .great
        } else if distanceSquared < (Self.meldQualityMaxDistanceToLineSegmentNormal * Self.meldQualityMaxDistanceToLineSegmentNormal) {
            return .good
        } else if distanceSquared < (Self.meldQualityMaxDistanceToLineSegmentLow * Self.meldQualityMaxDistanceToLineSegmentLow) {
            return .normal
        } else if distanceSquared < (Self.meldQualityMaxDistanceToLineSegmentBroken * Self.meldQualityMaxDistanceToLineSegmentBroken) {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyMaxSpokeLength(_ distanceSquared: Float) -> QualityGrade {
        if distanceSquared < meldQualityMaxSpokeLengthGreat {
            return .excellent
        } else if distanceSquared < meldQualityMaxSpokeLengthGood {
            return .great
        } else if distanceSquared < meldQualityMaxSpokeLengthNormal {
            return .good
        } else if distanceSquared < meldQualityMaxSpokeLengthLow {
            return .normal
        } else if distanceSquared < meldQualityMaxSpokeLengthBroken {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyMinEdgeAngle(_ radians: Float) -> QualityGrade {
        if radians < Self.meldQualityMinEdgeAngleThresholdBroken {
            return .broken
        } else if radians < Self.meldQualityMinEdgeAngleThresholdLow {
            return .low
        } else if radians < Self.meldQualityMinEdgeAngleThresholdNormal {
            return .normal
        } else if radians < Self.meldQualityMinEdgeAngleThresholdGood {
            return .good
        } else if radians < meldQualityMinEdgeAngleThresholdGreat {
            return .great
        } else {
            return .excellent
        }
    }
    
    static func classifyMinSpokeAngle(_ radians: Float) -> QualityGrade {
        if radians < Self.meldQualityMinSpokeAngleThresholdBroken {
            return .broken
        } else if radians < Self.meldQualityMinSpokeAngleThresholdLow {
            return .low
        } else if radians < Self.meldQualityMinSpokeAngleThresholdNormal {
            return .normal
        } else if radians < Self.meldQualityMinSpokeAngleThresholdGood {
            return .good
        } else if radians < meldQualityMinSpokeAngleThresholdGreat {
            return .great
        } else {
            return .excellent
        }
    }
    
    static func classifyWedgeAngle(_ radians: Float) -> QualityGrade {
        if radians < meldQualityWedgeAngleThresholdBroken {
            return .broken
        } else if radians < meldQualityWedgeAngleThresholdLow {
            return .low
        } else if radians < meldQualityWedgeAngleThresholdNormal {
            return .normal
        } else if radians < meldQualityWedgeAngleThresholdGood {
            return .good
        } else if radians < meldQualityWedgeAngleThresholdGreat {
            return .great
        } else {
            return .excellent
        }
    }
    
    static func classifyMaxEdgeLength(_ length: Float) -> QualityGrade {
        if length < (Self.meldQualityMaxEdgeLengthGreat) {
            return .excellent
        } else if length < (Self.meldQualityMaxEdgeLengthGood) {
            return .great
        } else if length < (Self.meldQualityMaxEdgeLengthNormal) {
            return .good
        } else if length < (Self.meldQualityMaxEdgeLengthLow) {
            return .normal
        } else if length < (Self.meldQualityMaxEdgeLengthBroken) {
            return .low
        } else {
            return .broken
        }
    }
    
}

extension RingMeldQuality: Comparable {
    
    static func weightMaxDistanceToLineSegment(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 80
        case .great:
            return 79
        case .good:
            return 78
        case .normal:
            return 77
        case .low:
            return -8_000
        case .broken:
            return -7_999
        }
    }
    
    static func weightMaxSpokeLength(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 80
        case .great:
            return 79
        case .good:
            return 78
        case .normal:
            return 77
        case .low:
            return -8_000
        case .broken:
            return -7_999
        }
    }
    
    static func weightWedgeAngle(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 800_000
        case .great:
            return 799_999
        case .good:
            return 799_998
        case .normal:
            return -79_999_998
        case .low:
            return -79_999_999
        case .broken:
            return -80_000_000
        }
    }
    
    static func weightMinSpokeAngle(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 70_000
        case .great:
            return 69_999
        case .good:
            return 69_998
        case .normal:
            return 69_997
        case .low:
            return -6_999_999
        case .broken:
            return -7_000_000
        }
    }
    
    static func weightMinEdgeAngle(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 6_000
        case .great:
            return 5_999
        case .good:
            return 5_998
        case .normal:
            return 5_997
        case .low:
            return -599_999
        case .broken:
            return -600_000
        }
    }
    
    static func weightMaxEdgeLength(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 500
        case .great:
            return 499
        case .good:
            return 498
        case .normal:
            return 497
        case .low:
            return -4_999
        case .broken:
            return -50_000
        }
    }
    
    static func weightMinEdgeLength(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 40
        case .great:
            return 39
        case .good:
            return 38
        case .normal:
            return 37
        case .low:
            return -299
        case .broken:
            return -300
        }
    }
    
    fileprivate static func calculateWeight(_ ringMeldQuality: RingMeldQuality) -> Int {
        let weightA = Self.weightMaxDistanceToLineSegment(ringMeldQuality.maxDistanceToLineSegment)
        let weightB = Self.weightMaxSpokeLength(ringMeldQuality.maxSpokeLength)
        let weightC = Self.weightMinSpokeAngle(ringMeldQuality.minSpokeAngle)
        let weightD = Self.weightWedgeAngle(ringMeldQuality.wedgeAngle)
        let weightE = Self.weightMinEdgeAngle(ringMeldQuality.minEdgeAngle)
        let weightF = Self.weightMaxEdgeLength(ringMeldQuality.maxEdgeLength)
        return weightA + weightB + weightC + weightD + weightE + weightF
    }
    
    static func < (lhs: RingMeldQuality, rhs: RingMeldQuality) -> Bool {
        lhs.weight < rhs.weight
    }
}
