//
//  Ring+SweepLine.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/4/23.
//

import Foundation

extension Ring {
    
    
    func calculateSweepLinesHorizontal(count: Int, minY: Float, maxY: Float, rangeY: Float) {
        
        purgeRingSweepLines()
        
        isHorizontalSweepLines = true
        
        let count1f = Float(count + 1)
        var yIndex = 0
        while yIndex < count {
            let percent = Float(yIndex + 1) / count1f
            let y = minY + rangeY * percent
            let ringSweepLine = PolyMeshPartsFactory.shared.withdrawRingSweepLine()
            ringSweepLine.position = y
            addRingSweepLine(ringSweepLine)
            
            yIndex += 1
        }
    }
    
    func calculateSweepLinesVertical(count: Int, minX: Float, maxX: Float, rangeX: Float) {
        
        purgeRingSweepLines()
        
        isHorizontalSweepLines = false
        
        let count1f = Float(count + 1)
        var xIndex = 0
        while xIndex < count {
            let percent = Float(xIndex + 1) / count1f
            
            let ringSweepLine = PolyMeshPartsFactory.shared.withdrawRingSweepLine()
            ringSweepLine.position = minX + rangeX * percent
            addRingSweepLine(ringSweepLine)
            
            xIndex += 1
        }
    }
}
