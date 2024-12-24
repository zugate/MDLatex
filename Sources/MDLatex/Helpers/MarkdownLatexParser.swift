//
//  MarkdownLatexParser.swift
//  MDLatex
//
//  Created by Kumar Shubham on 23/12/24.
//  Enhanced by <Your Name Here>
//

import Foundation

/// A utility for extracting LaTeX expressions from Markdown,
/// temporarily replacing them with placeholders,
/// and then restoring them back into HTML content.
struct MarkdownLatexParser {
    
    /// Regex that captures both inline math (\\(...)\\) and display math (\\[ ... \\]).
    /// - Inline pattern: `\\( ... \\)`
    /// - Display pattern: `\\[ ... \\]`
    private static let latexRegex: NSRegularExpression = {
        // swiftlint:disable:next force_try
        return try! NSRegularExpression(
            pattern: #"\\\([\s\S]*?\\\)|\\\[\s*[\s\S]*?\s*\\\]"#,
            options: []
        )
    }()
    
    // MARK: - Extracting LaTeX
    /// Extracts LaTeX segments from the input Markdown and replaces them with placeholders.
    /// - Parameter text: The raw Markdown string containing possible LaTeX expressions.
    /// - Returns: A tuple containing:
    ///   1. A `String` with all LaTeX replaced by placeholders like `<<<LATEX_0>>>`.
    ///   2. An ordered `[String]` array of extracted LaTeX expressions.
    static func extractLatexSegments(from text: String) -> (strippedMarkdown: String, latexSegments: [String]) {
        let nsString = text as NSString
        let matches = latexRegex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        
        // We collect the found LaTeX segments in the order they appear in the text
        // (but we will handle replacements in reverse to keep indices stable).
        var latexSegments: [String] = []
        
        // We'll build a mutable copy for the stripped version
        var strippedMarkdown = text
        
        // Loop in reversed order so that earlier replacements won't affect the range offsets of later matches
        for (index, match) in matches.enumerated().reversed() {
            let matchedString = nsString.substring(with: match.range)
            
            latexSegments.insert(matchedString, at: 0)
            
            // Create a unique placeholder for this LaTeX expression
            let placeholder = "<<<LATEX_\(index)>>>"
            
            // Replace the matched range with the placeholder in the stripped string
            if let range = Range(match.range, in: strippedMarkdown) {
                strippedMarkdown.replaceSubrange(range, with: placeholder)
            }
        }
        
        return (strippedMarkdown, latexSegments)
    }

    // MARK: - Restoring LaTeX
    /// Restores previously extracted LaTeX segments (with placeholders like `<<<LATEX_0>>>`)
    /// back into a final HTML (or other) string.
    /// - Parameters:
    ///   - html: The post-processed content (e.g. Markdown -> HTML) that still contains placeholders.
    ///   - latexSegments: The array of LaTeX expressions extracted earlier via `extractLatexSegments`.
    /// - Returns: The final string with the placeholders replaced by the original LaTeX.
    static func restoreLatexSegments(into html: String, latexSegments: [String]) -> String {
        var result = html
        
        for (index, segment) in latexSegments.enumerated() {
            let placeholder = "<<<LATEX_\(index)>>>".replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of:">", with: "&gt;")
            result = result.replacingOccurrences(of: placeholder, with: segment)
        }
        
        return result
    }
}
