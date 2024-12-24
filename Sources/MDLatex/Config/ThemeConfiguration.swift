//
//  ThemeConfiguration.swift
//  MDLatex
//
//  Created by Kumar Shubham on 23/12/24.
//

import SwiftUI

/// A configuration structure for defining theme properties.
public struct ThemeConfiguration {
    /// The background color of the theme.
    public let backgroundColor: Color

    /// The font color of the theme.
    public let fontColor: Color

    /// The size of the font.
    /// Must be greater than zero.
    public let fontSize: CGFloat

    /// The custom font family name used in the theme.
    /// Defaults to "Arial".
    public let fontFamily: String

    /// Indicates whether user interaction is enabled.
    public let userInteractionEnabled: Bool

    /// The `Font` generated from `fontFamily` and `fontSize`.
    public var font: Font {
        Font.custom(fontFamily, size: fontSize)
    }

    /// Creates a new `ThemeConfiguration`.
    /// - Parameters:
    ///   - backgroundColor: The background color of the theme. Defaults to `.black`.
    ///   - fontColor: The font color of the theme. Defaults to `.white`.
    ///   - fontSize: The size of the font. Must be greater than zero. Defaults to `16`.
    ///   - fontFamily: The custom font family name. Defaults to "Arial".
    ///   - userInteractionEnabled: A Boolean indicating whether user interaction is enabled. Defaults to `true`.
    public init(
        backgroundColor: Color = .black,
        fontColor: Color = .white,
        fontSize: CGFloat = 16,
        fontFamily: String = "Arial",
        userInteractionEnabled: Bool = true
    ) {
        self.backgroundColor = backgroundColor
        self.fontColor = fontColor
        self.fontSize = fontSize
        self.fontFamily = fontFamily
        self.userInteractionEnabled = userInteractionEnabled
    }
}
