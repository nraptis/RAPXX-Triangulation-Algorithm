//
//  DemoViewController.swift
//  RAPXX_Triangulation
//
//  Created by Nick on 8/19/25.
//

import Foundation
import UIKit

class DemoViewController: MetalViewController {
    
    let demoScene: DemoScene
    
    var selectedPointIndex = -1
    var selectedPointTouch: UITouch?
    var selectedStartTouchX = Float(0.0)
    var selectedStartTouchY = Float(0.0)
    var selectedStartPointX = Float(0.0)
    var selectedStartPointY = Float(0.0)
    
    required init(demoScene: DemoScene,
                  width: Float,
                  height: Float) {
        self.demoScene = demoScene
        super.init(delegate: demoScene,
                   width: width,
                   height: height)
        ApplicationController.shared.demoViewController = self
    }
    
    deinit {
        print("[--] DemoViewController")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: Float,
                         stereoSpreadBase: Float,
                         stereoSpreadMax: Float) {
        super.update(deltaTime: deltaTime,
                     stereoSpreadBase: stereoSpreadBase,
                     stereoSpreadMax: stereoSpreadMax)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func drawloop() {
        super.drawloop()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if selectedPointTouch != nil { return }
        
        let distance = Float(Device.isPad ? 80 : 56)
        var bestDistanceSquared = distance * distance
        
        for touch in touches {
            let location = touch.location(in: self.view)
            for pointIndex in demoScene.polypoints.indices {
                let point = demoScene.polypoints[pointIndex]
                let diffX = point.x - Float(location.x)
                let diffY = point.y - Float(location.y)
                let distanceSquared = diffX * diffX + diffY * diffY
                if distanceSquared < bestDistanceSquared {
                    bestDistanceSquared = distanceSquared
                    selectedPointTouch = touch
                    selectedPointIndex = pointIndex
                    selectedStartTouchX = Float(location.x)
                    selectedStartTouchY = Float(location.y)
                    selectedStartPointX = point.x
                    selectedStartPointY = point.y
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let selectedPointTouch = selectedPointTouch else { return }
        
        for touch in touches {
            if touch === selectedPointTouch {
                let location = touch.location(in: self.view)
                let diffX = selectedStartTouchX - Float(location.x)
                let diffY = selectedStartTouchY - Float(location.y)
                let newX = selectedStartPointX - diffX
                let newY = selectedStartPointY - diffY
                demoScene.polypoints[selectedPointIndex].x = newX
                demoScene.polypoints[selectedPointIndex].y = newY
                demoScene.triangulate()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch === selectedPointTouch {
                selectedPointTouch = nil
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch === selectedPointTouch {
                selectedPointTouch = nil
            }
        }
    }
    
    
}
