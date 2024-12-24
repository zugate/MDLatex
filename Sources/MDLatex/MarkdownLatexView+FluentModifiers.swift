//
//  MarkdownLatexView+FluentModifiers.swift
//  MDLatex
//
//  Created by Kumar shubham on 24/12/24.
//

import SwiftUI

// MARK: - Fluent Modifiers
extension MarkdownLatexView {
    /// Toggles animation config for chunk-based rendering
    @discardableResult
    func animationEnabled(_ value: Bool, chunkRenderingDuration: TimeInterval = 0.3) -> Self {
        let view = self
        view.viewModel.animationConfig = AnimationConfiguration(isEnabled: value, chunkRenderingDuration: chunkRenderingDuration)
        return view
    }
    
    /// Sets the desired content width
    @discardableResult
    func contentWidth(_ value: CGFloat) -> Self {
        var view = self
        view.width = value
        return view
    }
    
    /// Called when the entire content is done rendering (one-go) or last chunk
    @discardableResult
    func onComplete(_ handler: @escaping (String) -> Void) -> Self {
        var view = self
        view.onLoadingComplete = handler
        return view
    }
    
    /// Called after each chunk for chunk-based animations
    @discardableResult
    func onChunkRendered(_ handler: @escaping (String,Int) -> Void) -> Self {
        var view = self
        view.onChunkRendered = handler
        return view
    }
    
    /// Customizes the theme configuration
    @discardableResult
    func themeConfiguration(backgroundColor: Color,
                            fontColor: Color,
                            fontSize: CGFloat,
                            fontFamily: String,
                            userInteractionEnabled: Bool) -> Self {
        let view = self
        view.viewModel.themeConfig = ThemeConfiguration(
            backgroundColor: backgroundColor,
            fontColor: fontColor,
            fontSize: fontSize,
            fontFamily: fontFamily,
            userInteractionEnabled: userInteractionEnabled
        )
        return view
    }
}
