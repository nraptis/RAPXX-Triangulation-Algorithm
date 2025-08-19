//
//  SceneDelegate.swift
//  Jiggle III
//
//  Created by Nick Raptis on 11/8/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        
        let _isPhone = (UIDevice.current.userInterfaceIdiom == .phone)
        let _isPad = !_isPhone
        let _screenScale = UIScreen.main.scale
        let _screenWidth = Float(Int(UIScreen.main.bounds.size.width + 0.5))
        let _screenHeight = Float(Int(UIScreen.main.bounds.size.height + 0.5))
        
        Device.isPhone = _isPhone
        Device.isPad = _isPad
        Device.scale = Float(_screenScale)
        
        Device.widthPortrait = _screenWidth < _screenHeight ? _screenWidth : _screenHeight
        Device.heightPortrait = _screenWidth < _screenHeight ? _screenHeight : _screenWidth
        Device.widthLandscape = Device.heightPortrait
        Device.heightLandscape = Device.widthPortrait
        
        let orientation = Orientation(interfaceOrientation: windowScene.interfaceOrientation)
        let _rootViewModel = RootViewModel(orientation: orientation,
                                           window: window,
                                           windowScene: windowScene)
        ApplicationController.rootViewModel = _rootViewModel
        ApplicationController.rootViewController = RootViewController(rootViewModel: _rootViewModel)
        
        window.rootViewController = ApplicationController.rootViewController
        window.makeKeyAndVisible()
        
        DispatchQueue.main.async {
            if let rootViewModel = ApplicationController.rootViewModel {
                rootViewModel.pushToDemo(animated: false,
                                         reversed: false,
                                         width: Device.widthPortrait,
                                         height: Device.heightPortrait)
            }
        }
    }
}
