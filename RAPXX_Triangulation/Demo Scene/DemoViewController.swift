//
//  DemoViewController.swift
//  RAPXX_Triangulation
//
//  Created by Nick on 8/19/25.
//

import Foundation

class DemoViewController: MetalViewController {
    
    let demoScene: DemoScene
    
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
    
}
