//
//  MarkdownLatex+WithoutAnimation.swift
//  MDLatex
//
//  Created by Kumar shubham on 23/12/24.
//

import SwiftUI
import Down

// MARK: - One-Go Rendering
extension MarkdownLatexView {
    /// Loads the KaTeX skeleton from bundle if not already loaded,
    /// injecting the custom font & style.
    func loadKatexTemplateIfNeeded() {
        guard katexTemplate.isEmpty else { return }
        
        guard let templatePath = Bundle.module.url(forResource: "katex_template", withExtension: "html"),
              let htmlTemplate = try? String(contentsOf: templatePath) else {
            fatalError("Unable to load KaTeX template.")
        }
        
        // Insert custom font & style
        let fontFace = loadCustomFont()
        let styles = generateStyles(fontFace: fontFace)
        
        // Replace </head> with <style>...</style></head>
        let finalTemplate = htmlTemplate.replacingOccurrences(
            of: "</head>",
            with: "<style>\(styles)</style></head>"
        )
        self.katexTemplate = finalTemplate
    }
    
    /// One-go rendering with caching
    func renderAllContentAtOnceCached() {
        if let cachedHTML = viewModel.renderedHTMLCache[markdownContent] {
            // If we already generated final HTML for this Markdown, reuse it
            print("Using cached HTML for non-animated flow")
            injectAllContentIntoWebView(cachedHTML)
        } else {
            // Convert from Markdown -> final HTML, store in cache, then inject
            let finalHTML = convertMarkdownToHTML(markdownContent)
            viewModel.renderedHTMLCache[markdownContent] = finalHTML
            injectAllContentIntoWebView(finalHTML)
        }
    }
    
    /// Convert from Markdown & LaTeX -> final HTML
    private func convertMarkdownToHTML(_ markdown: String) -> String {
        // 1) Extract LaTeX
        let (strippedMarkdown, latexSegments) = MarkdownLatexParser.extractLatexSegments(from: markdown)
        // 2) Convert stripped Markdown -> HTML
        let down = Down(markdownString: strippedMarkdown)
        let markdownHTML: String
        do {
            markdownHTML = try down.toHTML()
        } catch {
            print("Failed to render Markdown:", error)
            return ""
        }
        // 3) Re-inject LaTeX into the HTML
        let final = MarkdownLatexParser.restoreLatexSegments(into: markdownHTML, latexSegments: latexSegments)
        return final
    }
    
    /// Calls `renderAllContent(html)` in the KaTeX skeleton to replace <div id="content"> with final HTML
    private func injectAllContentIntoWebView(_ html: String) {
        guard !html.isEmpty else { return }
        
        let escapedHTML = escapeForJavaScript(html)
        let js = "renderAllContent(`\(escapedHTML)`);"
        
        viewModel.webViewRef.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("Error injecting HTML in one-go:", error)
            } else {
                self.onLoadingComplete?(html)
            }
        }
    }
}

