//
//  Color+Extension.swift
//  MDLatex
//
//  Created by Kumar shubham on 23/12/24.
//

import SwiftUI
import UIKit

extension Color {
    
    /// Converts a SwiftUI `Color` to a hex string.
    /// - Parameters:
    ///   - includeAlpha: Whether to include the alpha channel in the hex. Defaults to `false`.
    /// - Returns: A hex string like `#RRGGBB` or `#RRGGBBAA`. If alpha == 0, returns `"transparent"`.
    ///   If color conversion fails, returns `"#000000"`.
    func toHexString(includeAlpha: Bool = false) -> String {
        // Convert SwiftUI.Color -> UIColor
        let uiColor = UIColor(self)
        
        // Attempt to extract RGBA components
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // If not in sRGB or an unsupported color space, return fallback
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return "#000000" // fallback to black
        }
        
        // If the color is fully transparent, return "transparent"
        if a == 0 {
            return "transparent"
        }
        
        // Convert each component to [0..255] and format
        if includeAlpha {
            let redInt   = Int(r * 255)
            let greenInt = Int(g * 255)
            let blueInt  = Int(b * 255)
            let alphaInt = Int(a * 255)
            return String(format: "#%02X%02X%02X%02X", redInt, greenInt, blueInt, alphaInt)
        } else {
            let redInt   = Int(r * 255)
            let greenInt = Int(g * 255)
            let blueInt  = Int(b * 255)
            return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
        }
    }
    
    /// Converts a SwiftUI `Color` to a native `UIColor`.
    /// - Returns: The corresponding `UIColor`.
    func toUIColor() -> UIColor {
        UIColor(self)
    }
}
