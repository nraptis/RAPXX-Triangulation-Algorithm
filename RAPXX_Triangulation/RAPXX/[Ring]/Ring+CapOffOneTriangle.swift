//
//  Ring+CapOffOneTriangle.swift
//  RAPXX
//
//  Created by Nick Raptis on 2/15/24.
//

import Foundation

extension Ring {
    func attemptCapOffWithOneTriangle() -> Bool {
        guard ringPointCount == 3 else {
            return false
        }
        if let triangleData {
            triangleData.add(x1: ringPoints[0].x, y1: ringPoints[0].y,
                             x2: ringPoints[1].x, y2: ringPoints[1].y,
                             x3: ringPoints[2].x, y3: ringPoints[2].y)
        }
        PolyMeshPartsFactory.shared.depositRingContent(self)
        return true
    }
}
