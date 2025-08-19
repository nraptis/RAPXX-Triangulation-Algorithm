//
//  Device.swift
//  TypeKit
//
//  Created by Nicholas Raptis on 5/10/25.
//

import Foundation

public class Device {
    public nonisolated(unsafe) static var widthPortrait = Float(0.0)
    public nonisolated(unsafe) static var heightPortrait = Float(0.0)
    public nonisolated(unsafe) static var widthLandscape = Float(0.0)
    public nonisolated(unsafe) static var heightLandscape = Float(0.0)
    public nonisolated(unsafe) static var isPad = false
    public nonisolated(unsafe) static var isPhone = false
    public nonisolated(unsafe) static var scale = Float(1.0)
}
