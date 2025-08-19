//
//  QualityGrade.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/14/24.
//

import Foundation

enum QualityGrade: UInt8, Comparable, CaseIterable, Hashable {
    case excellent = 6
    case great = 5
    case good = 4
    case normal = 3
    case low = 2
    case broken = 1
    
    static var random: QualityGrade {
        let number = Int.random(in: 0...5)
        switch number {
        case 0:
            return .excellent
        case 1:
            return .great
        case 2:
            return .good
        case 3:
            return .normal
        case 4:
            return .low
        default:
            return .broken
        }
    }
    
    static func < (lhs: QualityGrade, rhs: QualityGrade) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
