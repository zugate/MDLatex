//
//  AnimationConfiguration.swift
//  MDLatex
//
//  Created by Kumar Shubham on 23/12/24.
//

import SwiftUI

/// A configuration structure for handling animation settings.
public struct AnimationConfiguration {
    /// Determines if animations are enabled.
    public let isEnabled: Bool
    
    /// The duration for chunk rendering animations, in seconds.
    /// Must be a non-negative value.
    public let chunkRenderingDuration: TimeInterval
    
    /// Creates a new `AnimationConfiguration`.
    /// - Parameters:
    ///   - isEnabled: A Boolean indicating whether animations are enabled. Defaults to `false`.
    ///   - chunkRenderingDuration: The duration for chunk rendering animations, in seconds. Defaults to `0`.
    ///                             Must be a non-negative value.
    public init(isEnabled: Bool = false, chunkRenderingDuration: TimeInterval = 0) {
        precondition(chunkRenderingDuration >= 0, "chunkRenderingDuration must be non-negative")
        self.isEnabled = isEnabled
        self.chunkRenderingDuration = chunkRenderingDuration
    }
}
