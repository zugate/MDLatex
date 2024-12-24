//
//  MarkdownLatexView+WithAnimation.swift
//  MDLatex
//
//  Created by Kumar Shubham on 23/12/24.
//

import SwiftUI
import Down
import WebKit

// MARK: - Animated (Chunk) Rendering
extension MarkdownLatexView {
    /// Splits the Markdown on "\n\n" to produce chunk-based sections
    func splitMarkdownIntoChunks(_ markdown: String) -> [String] {
        markdown.components(separatedBy: "\n\n")
    }
    
    /// Initialize chunk-based flow
    func initializeForAnimation(
        chunkCompletion: @escaping (String, Int) -> Void,
        completion: @escaping () -> Void
    ) {
        startChunkRendering(
            chunkCompletion: chunkCompletion,
            completion: completion
        )
    }
    
    /// Start chunk-based rendering from the first chunk
    func startChunkRendering(
        chunkCompletion: @escaping (String, Int) -> Void,
        completion: @escaping () -> Void
    ) {
        guard !markdownChunks.isEmpty else {
            completion()
            return
        }
        currentChunkIndex = 0
        processChunk(
            at: currentChunkIndex,
            chunkCompletion: chunkCompletion,
            completion: completion
        )
    }
    
    /// Process a single chunk, inject it, then schedule the next
    private func processChunk(
        at index: Int,
        chunkCompletion: @escaping (String, Int) -> Void,
        completion: @escaping () -> Void
    ) {
        guard index < markdownChunks.count else {
            debugPrint("All chunks rendered.")
            completion()
            return
        }
        
        let chunk = markdownChunks[index]
        debugPrint("Rendering chunk \(index): \(chunk)")
        
        // Convert chunk to final HTML, then inject
        DispatchQueue.main.async {
            self.appendChunkToWebView(self.viewModel.webViewRef, chunk) { success in
                if success {
                    chunkCompletion(chunk, index)
                    self.scheduleNext(
                        index: index + 1,
                        chunkCompletion: chunkCompletion,
                        completion: completion
                    )
                } else {
                    debugPrint("Retrying chunk \(index)")
                    self.scheduleRetry(
                        index: index,
                        chunkCompletion: chunkCompletion,
                        completion: completion
                    )
                }
            }
        }
    }
    
    /// Wait chunkRenderingDuration, then process next chunk
    private func scheduleNext(
        index: Int,
        chunkCompletion: @escaping (String, Int) -> Void,
        completion: @escaping () -> Void
    ) {
        scheduleAfterDelay {
            self.processChunk(at: index, chunkCompletion: chunkCompletion, completion: completion)
        }
    }
    
    /// Retry the same chunk after delay
    private func scheduleRetry(
        index: Int,
        chunkCompletion: @escaping (String, Int) -> Void,
        completion: @escaping () -> Void
    ) {
        scheduleAfterDelay {
            self.processChunk(at: index, chunkCompletion: chunkCompletion, completion: completion)
        }
    }
    
    private func scheduleAfterDelay(_ action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + viewModel.animationConfig.chunkRenderingDuration,
            execute: action
        )
    }
    
    /// Convert a chunk -> final HTML, then append it to #content in the skeleton
    func appendChunkToWebView(_ webView: WKWebView, _ chunk: String, completion: @escaping (Bool) -> Void) {
        // 1) Extract LaTeX from chunk
        let (processedMarkdown, latexSegments) = MarkdownLatexParser.extractLatexSegments(from: chunk)
        // 2) Convert to HTML
        let down = Down(markdownString: processedMarkdown)
        let htmlChunk: String
        do {
            htmlChunk = try down.toHTML()
        } catch {
            debugPrint("Failed to render Markdown chunk: \(error)")
            completion(false)
            return
        }
        // 3) Re-inject LaTeX
        let restoredHTML = MarkdownLatexParser.restoreLatexSegments(into: htmlChunk, latexSegments: latexSegments)
        // 4) Escape for JavaScript
        let escapedHTML = escapeForJavaScript(restoredHTML)
        
        // 5) Append chunk in #content and re-render
        let js = """
        (function() {
            try {
                const content = document.getElementById('content');
                if (!content) throw new Error('Content element not found');
                
                const div = document.createElement('div');
                div.innerHTML = `\(escapedHTML)`;
                content.appendChild(div);
                
                renderMathInElement(div, {
                    delimiters: [
                        { left: "\\\\(", right: "\\\\)", display: false },
                        { left: "\\\\[", right: "\\\\]", display: true }
                    ],
                    throwOnError: false
                });
                
                updateHeight();
                return true;
            } catch (error) {
                console.error("Error appending chunk:", error);
                return false;
            }
        })();
        """
        
        webView.evaluateJavaScript(js) { result, error in
            if let error = error {
                debugPrint("JavaScript Execution Error: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
