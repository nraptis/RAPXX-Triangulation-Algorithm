//
//  RingSplitQuality.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/2/23.
//

import Foundation

struct RingSplitQuality: Hashable {
    var earAngle = QualityGrade.great
    var pointClosenessNeighbor = QualityGrade.great
    var pointClosenessDistant = QualityGrade.great
    var numberOfPoints = QualityGrade.great
    var splitLengthMax = QualityGrade.great
    var splitLengthMin = QualityGrade.great
    
    static func == (lhs: RingSplitQuality, rhs: RingSplitQuality) -> Bool {
        if lhs.earAngle != rhs.earAngle { return false }
        if lhs.pointClosenessNeighbor != rhs.pointClosenessNeighbor { return false }
        if lhs.pointClosenessDistant != rhs.pointClosenessDistant { return false }
        if lhs.numberOfPoints != rhs.numberOfPoints { return false }
        if lhs.splitLengthMax != rhs.splitLengthMax { return false }
        if lhs.splitLengthMin != rhs.splitLengthMin { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(earAngle)
        hasher.combine(pointClosenessNeighbor)
        hasher.combine(pointClosenessDistant)
        hasher.combine(numberOfPoints)
        hasher.combine(splitLengthMax)
        hasher.combine(splitLengthMin)
    }
    
    private(set) var weight = 0
    mutating func calculateWeight() {
        weight = Self.calculateWeight(self)
    }
    
    var isInstantSplit: Bool {
        if earAngle >= .excellent && pointClosenessNeighbor >= .great && pointClosenessDistant >= .excellent && numberOfPoints >= .excellent && splitLengthMax >= .great {
            return true
        } else {
            return false
        }
    }
    
    static let splitQualityEarAngleThresholdGreat = Math.radians(degrees: 70.0)
    static let splitQualityEarAngleThresholdGood = Math.radians(degrees: 60.0)
    static let splitQualityEarAngleThresholdNormal = Math.radians(degrees: 50.0)
    static let splitQualityEarAngleThresholdLow = Math.radians(degrees: 40.0)
    static let splitQualityEarAngleThresholdBroken = Math.radians(degrees: 30.0)
    
    static let splitQualityNumberOfPointsThresholdGreat = 8
    static let splitQualityNumberOfPointsThresholdGood = 7
    static let splitQualityNumberOfPointsThresholdNormal = 6
    static let splitQualityNumberOfPointsThresholdLow = 5
    static let splitQualityNumberOfPointsThresholdBroken = 4
    
    static let splitQualityPointClosenessNeighborThresholdGreat = Float(14.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessNeighborThresholdGood = Float(12.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessNeighborThresholdNormal = Float(10.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessNeighborThresholdLow = Float(8.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessNeighborThresholdBroken = Float(6.0) * PolyMeshConstants.SCALE
    
    //static let splitQualityPointClosenessNeighborThresholdGreatSquared = splitQualityPointClosenessNeighborThresholdGreat * splitQualityPointClosenessNeighborThresholdGreat
    //static let splitQualityPointClosenessNeighborThresholdGoodSquared = splitQualityPointClosenessNeighborThresholdGood * splitQualityPointClosenessNeighborThresholdGood
    //static let splitQualityPointClosenessNeighborThresholdNormalSquared = splitQualityPointClosenessNeighborThresholdNormal * splitQualityPointClosenessNeighborThresholdNormal
    //static let splitQualityPointClosenessNeighborThresholdLowSquared = splitQualityPointClosenessNeighborThresholdLow * splitQualityPointClosenessNeighborThresholdLow
    //static let splitQualityPointClosenessNeighborThresholdBrokenSquared = splitQualityPointClosenessNeighborThresholdBroken * splitQualityPointClosenessNeighborThresholdBroken
    
    static let splitQualityPointClosenessDistantThresholdGreat = Float(20.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessDistantThresholdGood = Float(18.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessDistantThresholdNormal = Float(16.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessDistantThresholdLow = Float(14.0) * PolyMeshConstants.SCALE
    static let splitQualityPointClosenessDistantThresholdBroken = Float(12.0) * PolyMeshConstants.SCALE
    
    static let splitQualityPointClosenessDistantThresholdGreatSquared = splitQualityPointClosenessDistantThresholdGreat * splitQualityPointClosenessDistantThresholdGreat
    static let splitQualityPointClosenessDistantThresholdGoodSquared = splitQualityPointClosenessDistantThresholdGood * splitQualityPointClosenessDistantThresholdGood
    static let splitQualityPointClosenessDistantThresholdNormalSquared = splitQualityPointClosenessDistantThresholdNormal * splitQualityPointClosenessDistantThresholdNormal
    static let splitQualityPointClosenessDistantThresholdLowSquared = splitQualityPointClosenessDistantThresholdLow * splitQualityPointClosenessDistantThresholdLow
    static let splitQualityPointClosenessDistantThresholdBrokenSquared = splitQualityPointClosenessDistantThresholdBroken * splitQualityPointClosenessDistantThresholdBroken
    
    static let splitQualityLengthMaxThresholdGreat = PolyMeshConstants.ringSplitDistance + 4.0 * PolyMeshConstants.SCALE
    static let splitQualityLengthMaxThresholdGood = PolyMeshConstants.ringSplitDistance + 7.0 * PolyMeshConstants.SCALE
    static let splitQualityLengthMaxThresholdNormal = PolyMeshConstants.ringSplitDistance + 10.0 * PolyMeshConstants.SCALE
    static let splitQualityLengthMaxThresholdLow = PolyMeshConstants.ringSplitDistance + 13.0 * PolyMeshConstants.SCALE
    static let splitQualityLengthMaxThresholdBroken = PolyMeshConstants.ringSplitDistance + 16.0 * PolyMeshConstants.SCALE
    
    static let splitQualityLengthMinThresholdGreat = Float(16.0) * PolyMeshConstants.SCALE
    static let splitQualityLengthMinThresholdGood = Float(14.0) * PolyMeshConstants.SCALE
    static let splitQualityLengthMinThresholdNormal = Float(12.0) * PolyMeshConstants.SCALE
    static let splitQualityLengthMinThresholdLow = Float(10.0) * PolyMeshConstants.SCALE
    static let splitQualityLengthMinThresholdBroken = Float(8.0) * PolyMeshConstants.SCALE
    
    static func classifyMinEarAngle(_ minEarAngle: Float) -> QualityGrade {
        if minEarAngle > Self.splitQualityEarAngleThresholdGreat {
            return .excellent
        } else if minEarAngle > Self.splitQualityEarAngleThresholdGood {
            return .great
        } else if minEarAngle > Self.splitQualityEarAngleThresholdNormal {
            return .good
        } else if minEarAngle > Self.splitQualityEarAngleThresholdLow {
            return .normal
        } else if minEarAngle > Self.splitQualityEarAngleThresholdBroken {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyPointClosenessNeighbor(_ pointCloseness: Float) -> QualityGrade {
        if pointCloseness > Self.splitQualityPointClosenessNeighborThresholdGreat {
            return .excellent
        } else if pointCloseness > Self.splitQualityPointClosenessNeighborThresholdGood {
            return .great
        } else if pointCloseness > Self.splitQualityPointClosenessNeighborThresholdNormal {
            return .good
        } else if pointCloseness > Self.splitQualityPointClosenessNeighborThresholdLow {
            return .normal
        } else if pointCloseness > Self.splitQualityPointClosenessNeighborThresholdBroken {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyPointClosenessDistant(_ pointClosenessSquared: Float) -> QualityGrade {
        if pointClosenessSquared > Self.splitQualityPointClosenessDistantThresholdGreatSquared {
            return .excellent
        } else if pointClosenessSquared > Self.splitQualityPointClosenessDistantThresholdGoodSquared {
            return .great
        } else if pointClosenessSquared > Self.splitQualityPointClosenessDistantThresholdNormalSquared {
            return .good
        } else if pointClosenessSquared > Self.splitQualityPointClosenessDistantThresholdLowSquared {
            return .normal
        } else if pointClosenessSquared > Self.splitQualityPointClosenessDistantThresholdBrokenSquared {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifySplitLengthMax(_ splitLength: Float) -> QualityGrade {
        if splitLength < Self.splitQualityLengthMaxThresholdGreat {
            return .excellent
        } else if splitLength < Self.splitQualityLengthMaxThresholdGood {
            return .great
        } else if splitLength < Self.splitQualityLengthMaxThresholdNormal {
            return .good
        } else if splitLength < Self.splitQualityLengthMaxThresholdLow {
            return .normal
        } else if splitLength < Self.splitQualityLengthMaxThresholdBroken {
            return .low
        } else  {
            return .broken
        }
    }
    
    static func classifySplitLengthMin(_ splitLength: Float) -> QualityGrade {
        if splitLength > Self.splitQualityLengthMinThresholdGreat {
            return .excellent
        } else if splitLength > Self.splitQualityLengthMinThresholdGood {
            return .great
        } else if splitLength > Self.splitQualityLengthMinThresholdNormal {
            return .good
        } else if splitLength > Self.splitQualityLengthMinThresholdLow {
            return .normal
        } else if splitLength > Self.splitQualityLengthMinThresholdBroken {
            return .low
        } else {
            return .broken
        }
    }
    
    static func classifyNumberOfPoints(_ numberOfPoints: Int) -> QualityGrade {
        if numberOfPoints > Self.splitQualityNumberOfPointsThresholdGreat {
            return .excellent
        } else if numberOfPoints > Self.splitQualityNumberOfPointsThresholdGood {
            return .great
        } else if numberOfPoints > Self.splitQualityNumberOfPointsThresholdNormal {
            return .good
        } else if numberOfPoints > Self.splitQualityNumberOfPointsThresholdLow {
            return .normal
        } else if numberOfPoints > Self.splitQualityNumberOfPointsThresholdBroken {
            return .low
        } else {
            return .broken
        }
    }
    
    static func weightMinEarAngle(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 9_000_000
        case .great:
            return 8_999_000
        case .good:
            return -899_997_000
        case .normal:
            return -899_998_000
        case .low:
            return -899_999_000
        case .broken:
            return -900_000_000
        }
    }
    
    static func weightPointClosenessNeighbor(_ meldQuality: QualityGrade) -> Int {
        switch meldQuality {
        case .excellent:
            return 9_000_000
        case .great:
            return 8_999_000
        case .good:
            return -899_997_000
        case .normal:
            return -899_998_000
        case .low:
            return -899_999_000
        case .broken:
            return -900_000_000
        }
    }
    
    static func weightPointClosenessDistant(_ meldQuality: QualityGrade) -> Int {
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
    
    static func weightNumberOfPoints(_ meldQuality: QualityGrade) -> Int {
        
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
    
    static func weightSplitLengthMax(_ meldQuality: QualityGrade) -> Int {
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
    
    static func weightSplitLengthMin(_ meldQuality: QualityGrade) -> Int {
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
    
}

extension RingSplitQuality: Comparable {
    static func < (lhs: RingSplitQuality, rhs: RingSplitQuality) -> Bool {
        
        return lhs.weight < rhs.weight
        
        
        /*
        ccc += 1
        if ccc == 1000000 {
            ccc = 0
        }
        
        if (ccc % 5000) < 2500 {
            
            
        
        }
        
        // Main priorities are both earAngle and pointCloseness combined
        
        
        
        
        let lhsMin = min(lhs.earAngle, lhs.pointCloseness)
        let rhsMin = min(rhs.earAngle, rhs.pointCloseness)
        
        if lhsMin < rhsMin {
            return true
        } else if lhsMin > rhsMin {
            return false
        } else {
            if lhs.earAngle < rhs.earAngle {
                return true
            } else if lhs.earAngle > rhs.earAngle {
                return false
            } else {
                
                if lhs.pointCloseness < rhs.pointCloseness {
                    return true
                } else if lhs.pointCloseness > rhs.pointCloseness {
                    return false
                } else {
                    
                    if lhs.numberOfPoints < rhs.numberOfPoints {
                        return true
                    } else if lhs.numberOfPoints > rhs.numberOfPoints {
                        return false
                    } else {
                        if lhs.splitLength < rhs.splitLength {
                            return true
                        } else {
                            return false
                        }
                    }
                    
                }
            }
        }
        */
    }
    
    fileprivate static func calculateWeight(_ ringSplitQuality: RingSplitQuality) -> Int {
        let weightA = Self.weightMinEarAngle(ringSplitQuality.earAngle)
        let weightB = Self.weightPointClosenessNeighbor(ringSplitQuality.pointClosenessNeighbor)
        let weightC = Self.weightPointClosenessDistant(ringSplitQuality.pointClosenessDistant)
        let weightD = Self.weightNumberOfPoints(ringSplitQuality.numberOfPoints)
        let weightE = Self.weightSplitLengthMax(ringSplitQuality.splitLengthMax)
        let weightF = Self.weightSplitLengthMax(ringSplitQuality.splitLengthMin)
        return weightA + weightB + weightC + weightD + weightE + weightF
    }
}
