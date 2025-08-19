//
//  Orientation.swift
//  Jiggle III
//
//  Created by Nick Raptis on 11/8/23.
//

import UIKit

@frozen public enum Orientation: UInt8 {
    case landscape
    case portrait
    
    public init(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait, .portraitUpsideDown:
            self = .portrait
        case .landscapeLeft, .landscapeRight:
            self = .landscape
        default:
            self = .portrait
        }
    }
    
    /*
     init(deviceOrientation: UIDeviceOrientation) {
     switch deviceOrientation {
     case .portrait, .portraitUpsideDown:
     self = .portrait
     case .landscapeLeft, .landscapeRight:
     self = .landscape
     default:
     self = .portrait
     }
     }
     */
    
    
    public var isPortrait: Bool {
        switch self {
        case .landscape:
            return false
        case .portrait:
            return true
        }
    }
    
    public var isLandscape: Bool {
        switch self {
        case .landscape:
            return true
        case .portrait:
            return false
        }
    }
    
}
