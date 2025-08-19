//
//  CapOffQuality.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/14/24.
//

import Foundation

struct RingCapOffQuality: Hashable {
    static func == (lhs: RingCapOffQuality, rhs: RingCapOffQuality) -> Bool {
        if lhs.maxDistanceToLineSegment != rhs.maxDistanceToLineSegment { return false }
        if lhs.minDistanceToLineSegment != rhs.minDistanceToLineSegment { return false }
        if lhs.maxSpokeLength != rhs.maxSpokeLength { return false }
        if lhs.minSpokeAngle != rhs.minSpokeAngle { return false }
        return true
    }
    
    var maxDistanceToLineSegment = QualityGrade.great
    var minDistanceToLineSegment = QualityGrade.great
    var maxSpokeLength = QualityGrade.great
    var minSpokeAngle = QualityGrade.great
    
    private(set) var weight = 0
    mutating func calculateWeight() {
        weight = Self.calculateWeight(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(maxDistanceToLineSegment)
        hasher.combine(minDistanceToLineSegment)
        hasher.combine(maxSpokeLength)
        hasher.combine(minSpokeAngle)
    }
    
    static let capOffQualityMaxDistanceToLineSegmentBroken = Float(23.0) * PolyMeshConstants.SCALE
    static let capOffQualityMaxDistanceToLineSegmentLow = Float(21.5) * PolyMeshConstants.SCALE
    static let capOffQualityMaxDistanceToLineSegmentNormal = Float(20.0) * PolyMeshConstants.SCALE
    static let capOffQualityMaxDistanceToLineSegmentGood = Float(18.5) * PolyMeshConstants.SCALE
    static let capOffQualityMaxDistanceToLineSegmentGreat = Float(17.0) * PolyMeshConstants.SCALE
    
    static let capOffQualityMinDistanceToLineSegmentBroken = Float(4.0) * PolyMeshConstants.SCALE
    static let capOffQualityMinDistanceToLineSegmentLow = Float(5.0) * PolyMeshConstants.SCALE
    static let capOffQualityMinDistanceToLineSegmentNormal = Float(6.0) * PolyMeshConstants.SCALE
    static let capOffQualityMinDistanceToLineSegmentGood = Float(7.0) * PolyMeshConstants.SCALE
    static let capOffQualityMinDistanceToLineSegmentGreat = Float(8.0) * PolyMeshConstants.SCALE
    
    static let capOffQualityMaxSpokeLengthBroken = Float(24.0) * PolyMeshConstants.SCALE
    static let capOffQualityMaxSpokeLengthLow = Float(22.5) * PolyMeshConstants.SCALE
    static let capOffQualityMaxSpokeLengthNormal = Float(21.0) * PolyMeshConstants.SCALE
    static let capOffQualityMaxSpokeLengthGood = Float(19.5) * PolyMeshConstants.SCALE
    static let capOffQualityMaxSpokeLengthGreat = Float(18.0) * PolyMeshConstants.SCALE

    static let capOffQualityMinSpokeAngleThresholdGreat = Math.pi_6
    static let capOffQualityMinSpokeAngleThresholdGood = Math.pi_8
    static let capOffQualityMinSpokeAngleThresholdNormal = Math.pi_10
    static let capOffQualityMinSpokeAngleThresholdLow = Math.pi_12
    static let capOffQualityMinSpokeAngleThresholdBroken = Math.pi_14
    
    static func classifyMaxDistanceToLineSegment(_ distanceSquared: Float) -> QualityGrade {
        if distanceSquared < (Self.capOffQualityMaxDistanceToLineSegmentGreat * Self.capOffQualityMaxDistanceToLineSegmentGreat) {
            return .excellent
        } else if distanceSquared < (Self.capOffQualityMaxDistanceToLineSegmentGood * Self.capOffQualityMaxDistanceToLineSegmentGood) {
            return .great
        } else if distanceSquared < (Self.capOffQualityMaxDistanceToLineSegmentNormal * Self.capOffQualityMaxDistanceToLineSegmentNormal) {
            return .good
        } else if distanceSquared < (Self.capOffQualityMaxDistanceToLineSegmentLow * Self.capOffQualityMaxDistanceToLineSegmentLow) {
            return .normal
        } else if distanceSquared < (Self.capOffQualityMaxDistanceToLineSegmentBroken * Self.capOffQualityMaxDistanceToLineSegmentBroken) {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyMinDistanceToLineSegment(_ distanceSquared: Float) -> QualityGrade {
        if distanceSquared > (Self.capOffQualityMinDistanceToLineSegmentGreat * Self.capOffQualityMinDistanceToLineSegmentGreat) {
            return .excellent
        } else if distanceSquared > (Self.capOffQualityMinDistanceToLineSegmentGood * Self.capOffQualityMinDistanceToLineSegmentGood) {
            return .great
        } else if distanceSquared > (Self.capOffQualityMinDistanceToLineSegmentNormal * Self.capOffQualityMinDistanceToLineSegmentNormal) {
            return .good
        } else if distanceSquared > (Self.capOffQualityMinDistanceToLineSegmentLow * Self.capOffQualityMinDistanceToLineSegmentLow) {
            return .normal
        } else if distanceSquared > (Self.capOffQualityMinDistanceToLineSegmentBroken * Self.capOffQualityMinDistanceToLineSegmentBroken) {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyMaxSpokeLength(_ distanceSquared: Float) -> QualityGrade {
        if distanceSquared < capOffQualityMaxSpokeLengthGreat {
            return .excellent
        } else if distanceSquared < capOffQualityMaxSpokeLengthGood {
            return .great
        } else if distanceSquared < capOffQualityMaxSpokeLengthNormal {
            return .good
        } else if distanceSquared < capOffQualityMaxSpokeLengthLow {
            return .normal
        } else if distanceSquared < capOffQualityMaxSpokeLengthBroken {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyMinSpokeAngle(_ radians: Float) -> QualityGrade {
        if radians < Self.capOffQualityMinSpokeAngleThresholdBroken {
            return .broken
        } else if radians < Self.capOffQualityMinSpokeAngleThresholdLow {
            return .low
        } else if radians < Self.capOffQualityMinSpokeAngleThresholdNormal {
            return .normal
        } else if radians < Self.capOffQualityMinSpokeAngleThresholdGood {
            return .good
        } else if radians < capOffQualityMinSpokeAngleThresholdGreat {
            return .great
        } else {
            return .excellent
        }
    }
}

extension RingCapOffQuality: Comparable {
    
    static func weightMinDistanceToLineSegment(_ capOffQuality: QualityGrade) -> Int {
        switch capOffQuality {
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
    
    static func weightMaxDistanceToLineSegment(_ capOffQuality: QualityGrade) -> Int {
        switch capOffQuality {
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
    
    static func weightMaxSpokeLength(_ capOffQuality: QualityGrade) -> Int {
        switch capOffQuality {
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
    
    static func weightMinSpokeAngle(_ capOffQuality: QualityGrade) -> Int {
        switch capOffQuality {
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
    
    fileprivate static func calculateWeight(_ ringMeldOffQuality: RingCapOffQuality) -> Int {
        let weightA = Self.weightMinDistanceToLineSegment(ringMeldOffQuality.minDistanceToLineSegment)
        let weightB = Self.weightMaxDistanceToLineSegment(ringMeldOffQuality.maxDistanceToLineSegment)
        let weightC = Self.weightMaxSpokeLength(ringMeldOffQuality.maxSpokeLength)
        let weightD = Self.weightMinSpokeAngle(ringMeldOffQuality.minSpokeAngle)
        return weightA + weightB + weightC + weightD
    }
    
    static func < (lhs: RingCapOffQuality, rhs: RingCapOffQuality) -> Bool {
        lhs.weight < rhs.weight
    }
}
