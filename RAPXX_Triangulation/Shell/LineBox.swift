//
//  LineBox.swift
//  MathKit
//
//  Created by Nicholas Raptis on 5/15/25.
//

import Foundation

struct LineBox {
    public let x1: Float
    public let y1: Float
    public let x2: Float
    public let y2: Float
    public let x3: Float
    public let y3: Float
    public let x4: Float
    public let y4: Float
    
    static func getLineBox(x1: Float, y1: Float,
                                  x2: Float, y2: Float,
                                  normalX: Float, normalY: Float,
                                  thickness: Float) -> LineBox {
        
        let _x1 = x1 - thickness * normalX; let _y1 = y1 - thickness * normalY
        let _x2 = x1 + thickness * normalX; let _y2 = y1 + thickness * normalY
        let _x3 = x2 - thickness * normalX; let _y3 = y2 - thickness * normalY
        let _x4 = x2 + thickness * normalX; let _y4 = y2 + thickness * normalY
        
        return LineBox(x1: _x1, y1: _y1, x2: _x2, y2: _y2,
                       x3: _x3, y3: _y3, x4: _x4, y4: _y4)
        
    }
}
