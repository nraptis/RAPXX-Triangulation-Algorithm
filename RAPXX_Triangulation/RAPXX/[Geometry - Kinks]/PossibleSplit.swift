//
//  PossibleSplitPair.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/29/23.
//

import Foundation

class PossibleSplit {
    unowned var ringPoint: RingPoint!
    var distanceSquared: Float = 0.0
}

class PossibleSplitPair {
    unowned var ringPoint1: RingPoint!
    unowned var ringPoint2: RingPoint!
    var distanceSquared: Float = 0.0
}
