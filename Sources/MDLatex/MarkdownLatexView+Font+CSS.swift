//
//  MarkdownLatexView+Font+CSS.swift
//  MDLatex
//
//  Created by Kumar shubham on 24/12/24.
//

import SwiftUI

// MARK: - Font & CSS Helpers
extension MarkdownLatexView {
    /// Tries to embed a custom TTF font in the KaTeX template
    func loadCustomFont() -> String {
        if let fontURL = Bundle.main.url(forResource: viewModel.themeConfig.fontFamily, withExtension: "ttf"),
           let fontData = try? Data(contentsOf: fontURL) {
            let base64Font = fontData.base64EncodedString()
            return """
            @font-face {
                font-family: '\(viewModel.themeConfig.fontFamily)';
                font-color: 
                src: url(data:font/truetype;charset=utf-8;base64,\(base64Font)) format('truetype');
                font-weight: normal;
                font-style: normal;
            }
            """
        } else {
            debugPrint("Warning: Unable to load font \(viewModel.themeConfig.fontFamily). Using system fonts.")
            return """
            @font-face {
                font-family: '\(viewModel.themeConfig.fontFamily)';
                src: local('-apple-system'), local('BlinkMacSystemFont'), local('Arial');
            }
            """
        }
    }
    
    /// Generates CSS <style> for body color, background, font-size, etc.
    func generateStyles(fontFace: String) -> String {
        let fontColor = viewModel.themeConfig.fontColor.toHexString()
        let backgroundColor = viewModel.themeConfig.backgroundColor == .clear
            ? "transparent"
            : viewModel.themeConfig.backgroundColor.toHexString()
        let fontSize = viewModel.themeConfig.fontSize
        let fontFamily = viewModel.themeConfig.fontFamily
        
        return """
        \(fontFace)
        body {
            color: \(fontColor);
            background-color: \(backgroundColor);
            font-size: \(fontSize)px;
            font-family: '\(fontFamily)';
            margin: 0;
            box-sizing: border-box;
            word-wrap: break-word;
            overflow-wrap: break-word;
        }
        """
    }
    
    /// Escapes special characters for JavaScript injection
    func escapeForJavaScript(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
    }
}
