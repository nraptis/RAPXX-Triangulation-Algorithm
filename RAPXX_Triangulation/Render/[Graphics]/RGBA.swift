//
//  Color.swift
//  RAPXX
//
//  Created by Nick Raptis on 3/14/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import UIKit

public struct RGBA: Sendable {
    
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
    
    public init() {
        red = Float(1.0)
        green = Float(1.0)
        blue = Float(1.0)
        alpha = Float(1.0)
    }
    
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = 1.0
    }
    
    public init(gray: Float, alpha: Float) {
        self.red = gray
        self.green = gray
        self.blue = gray
        self.alpha = alpha
    }
    
    public init(gray: Float) {
        self.red = gray
        self.green = gray
        self.blue = gray
        self.alpha = 1.0
    }
    
    /*
    public init(color: Color) {
        let uiColor = UIColor(color)
        self.init(uiColor: uiColor)
    }
    */
    
    public init(uiColor: UIColor) {
        var red = CGFloat(0.0)
        var green = CGFloat(0.0)
        var blue = CGFloat(0.0)
        var alpha = CGFloat(0.0)
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if red > 1.0 { red = 1.0 }
        if red < 0.0 { red = 0.0 }
        if green > 1.0 { green = 1.0 }
        if green < 0.0 { green = 0.0 }
        if blue > 1.0 { blue = 1.0 }
        if blue < 0.0 { blue = 0.0 }
        if alpha > 1.0 { alpha = 1.0 }
        if alpha < 0.0 { alpha = 0.0 }
        self.red = Float(red)
        self.green = Float(green)
        self.blue = Float(blue)
        self.alpha = Float(alpha)
    }
    
}
