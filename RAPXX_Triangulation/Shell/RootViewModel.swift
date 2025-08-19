//
//  RootViewModel.swift
//  Jiggle III
//
//  Created by Nick Raptis on 11/8/23.
//

import UIKit

final class RootViewModel: NSObject, @unchecked Sendable {
    
    var orientation: Orientation
    let window: UIWindow!
    let windowScene: UIWindowScene!
    
    @MainActor init(orientation: Orientation,
                    window: UIWindow!,
                    windowScene: UIWindowScene!) {
        self.orientation = orientation
        self.window = window
        self.windowScene = windowScene
    }
    
    
    @MainActor func pushToDemo(animated: Bool,
                                 reversed: Bool,
                               width: Float,
                               height: Float) {
        
        let demoScene = DemoScene()
        let demoViewController = DemoViewController(demoScene: demoScene,
                                                    width: width,
                                                    height: height)
        let appWidth = Device.widthPortrait
        let appHeight = Device.heightPortrait
        
        let graphics = demoViewController.graphics
        
        demoViewController.load()
        demoViewController.loadComplete()
        
        if let rootViewController = ApplicationController.rootViewController {
            rootViewController.push(viewController: demoViewController,
                                    fromOrientation: .portrait,
                                    toOrientation: .portrait,
                                    fixedOrientation: true,
                                    animated: animated,
                                    reversed: reversed) {
                
            }
        }
        
    }
    
    
    /*
    @MainActor func pushToJiggle(jiggleDocument: JiggleDocument,
                                 animated: Bool,
                                 reversed: Bool) {

        let jiggleScene = JiggleScene(jiggleDocument: jiggleDocument)
        let jiggleViewModel = JiggleViewModel(jiggleScene: jiggleScene,
                                              jiggleDocument: jiggleDocument,
                                              rootViewModel: self)
        
        let jiggleContainerViewController = JiggleContainerViewController(jiggleViewModel: jiggleViewModel,
                                                                          jiggleScene: jiggleScene,
                                                                          jiggleDocument: jiggleDocument)
        
        let appWidth: Float
        let appHeight: Float
        switch jiggleDocument.orientation {
        case .landscape:
            appWidth = Device.widthLandscape
            appHeight = Device.heightLandscape
        case .portrait:
            appWidth = Device.widthPortrait
            appHeight = Device.heightPortrait
        }
        let graphics = jiggleContainerViewController.jiggleViewController.graphics
        jiggleScene.awake(appWidth: appWidth,
                          appHeight: appHeight,
                          graphicsWidth: graphics.width,
                          graphicsHeight: graphics.height)
        jiggleContainerViewController.awake(jiggleViewModel: jiggleViewModel,
                                            jiggleScene: jiggleScene)
        
        let fromOrientation = Orientation(interfaceOrientation: windowScene.interfaceOrientation)
        let toOrientation = jiggleDocument.orientation
        
        if let rootViewController = ApplicationController.rootViewController {
            rootViewController.push(viewController: jiggleContainerViewController,
                                                           fromOrientation: fromOrientation,
                                                           toOrientation: toOrientation,
                                                           fixedOrientation: true,
                                                           animated: animated,
                                                           reversed: reversed) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    jiggleViewModel.handleWakeUpComplete_PartA()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        jiggleViewModel.handleWakeUpComplete_PartB()
                    }
                }
            }
        }
    }
    
    */
     
}

