//
//  ApplicationController.swift
//  Jiggle III
//
//  Created by Nick Raptis on 11/8/23.
//

import Foundation

final class ApplicationController {
    
    static var rootViewModel: RootViewModel?
    static var rootViewController: RootViewController?
    
    weak var demoViewController: DemoViewController?
    
    nonisolated(unsafe) static let shared = ApplicationController()
    
}
