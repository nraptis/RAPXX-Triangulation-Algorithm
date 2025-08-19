//
//  Ring+PinchGates.swift
//  RAPXX
//
//  Created by Nick Raptis on 12/27/23.
//

import Foundation

extension Ring {
    
    static let pinchGateAngularThreshold = Math.pi_2
    
    func calculateRingPointPinchGates() {
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            calculateRingPointPinchGates(ringPoint: ringPoint)
        }
    }
    
    func calculateRingPointPinchGates(ringPoint: RingPoint) {
        
        ringPoint.pinchGateLeftIndex = -1
        ringPoint.pinchGateRightIndex = -1
        ringPoint.pinchGateSpan = 0
        
        if ringLineSegmentCount <= 3 {
            return
        }
        
        let rightLineSegmentIndex = ringPoint.ringLineSegmentRight.ringIndex
        let leftLineSegmentIndex = ringPoint.ringLineSegmentLeft.ringIndex
        
        var seekIndex = 0
        var checkLineSegment = ringLineSegments[0]
        
        let considerationAngle1 = ringPoint.normalAngle
        var considerationAngle2 = Float(0.0)
        
        seekIndex = rightLineSegmentIndex + 1
        if seekIndex == ringLineSegmentCount {
            seekIndex = 0
        }
        considerationAngle2 = ringPoint.ringLineSegmentRight.normalAngle
        
        while seekIndex != leftLineSegmentIndex {
            
            checkLineSegment = ringLineSegments[seekIndex]
            
            let checkAngle1 = checkLineSegment.normalAngle
            let checkAngle2 = checkLineSegment.ringPointLeft.normalAngle
            
            let angleDiff1 = Math.distanceBetweenAnglesAbsolute(considerationAngle1, checkAngle1)
            let angleDiff2 = Math.distanceBetweenAnglesAbsolute(considerationAngle1, checkAngle2)
            let angleDiff3 = Math.distanceBetweenAnglesAbsolute(considerationAngle2, checkAngle1)
            let angleDiff4 = Math.distanceBetweenAnglesAbsolute(considerationAngle2, checkAngle2)
            
            if angleDiff1 > Self.pinchGateAngularThreshold ||
                angleDiff2 > Self.pinchGateAngularThreshold ||
                angleDiff3 > Self.pinchGateAngularThreshold ||
                angleDiff4 > Self.pinchGateAngularThreshold {
                
                ringPoint.pinchGateRightIndex = seekIndex
                break
            }
            
            seekIndex += 1
            if seekIndex == ringLineSegmentCount {
                seekIndex = 0
            }
        }
        
        seekIndex = leftLineSegmentIndex - 1
        if seekIndex == -1 {
            seekIndex = ringLineSegmentCount - 1
        }
        considerationAngle2 = ringPoint.ringLineSegmentLeft.normalAngle
        
        while seekIndex != rightLineSegmentIndex {
            
            checkLineSegment = ringLineSegments[seekIndex]
            
            let checkAngle1 = checkLineSegment.normalAngle
            let checkAngle2 = checkLineSegment.ringPointRight.normalAngle
            
            let angleDiff1 = Math.distanceBetweenAnglesAbsoluteUnsafe(considerationAngle1, checkAngle1)
            let angleDiff2 = Math.distanceBetweenAnglesAbsoluteUnsafe(considerationAngle1, checkAngle2)
            let angleDiff3 = Math.distanceBetweenAnglesAbsoluteUnsafe(considerationAngle2, checkAngle1)
            let angleDiff4 = Math.distanceBetweenAnglesAbsoluteUnsafe(considerationAngle2, checkAngle2)
            
            if angleDiff1 > Self.pinchGateAngularThreshold ||
                angleDiff2 > Self.pinchGateAngularThreshold ||
                angleDiff3 > Self.pinchGateAngularThreshold ||
                angleDiff4 > Self.pinchGateAngularThreshold {
                
                ringPoint.pinchGateLeftIndex = seekIndex
                break
            }
            
            seekIndex -= 1
            if seekIndex == -1 {
                seekIndex = ringLineSegmentCount - 1
            }
        }
        
        
        let pinchGateLeftIndex = ringPoint.pinchGateLeftIndex
        let pinchGateRightIndex = ringPoint.pinchGateRightIndex
        if pinchGateLeftIndex != -1 && pinchGateRightIndex != -1 {
            
            if Math.polygonTourCrosses(index: Int(ringPoint.ringIndex),
                                       startIndex: pinchGateRightIndex,
                                       endIndex: pinchGateLeftIndex) {
                ringPoint.pinchGateLeftIndex = -1
                ringPoint.pinchGateRightIndex = -1
                ringPoint.pinchGateSpan = 0
            } else {
                ringPoint.pinchGateSpan = Math.polygonTourLength(startIndex: pinchGateRightIndex,
                                                                 endIndex: pinchGateLeftIndex,
                                                                 count: ringPointCount)
            }
        } else {
            ringPoint.pinchGateLeftIndex = -1
            ringPoint.pinchGateRightIndex = -1
            ringPoint.pinchGateSpan = 0
        }
    }
}
