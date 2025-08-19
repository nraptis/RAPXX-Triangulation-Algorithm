//
//  GameView.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/9/23.
//

import UIKit

public class MetalView: UIView {
    
    public required init(width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    
}
