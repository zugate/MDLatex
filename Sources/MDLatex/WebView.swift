//
//  WebView.swift
//  MDLatex
//
//  Created by Kumar shubham on 23/12/24.
//

import SwiftUI
import WebKit

/// A simple, injection-based WKWebView for KaTeX/Markdown rendering.
struct WebView: UIViewRepresentable {
    
    /// The initial HTML (typically the KaTeX skeleton).
    let htmlContent: String
    
    /// Whether chunk-based animation is enabled (affects how contentHeight changes).
    let isAnimationEnabled: Bool
    
    /// The theme configuration (if needed for userInteraction).
    let themeConfig: ThemeConfiguration
    
    /// A binding to the WKWebView, so the parent can refer to the same instance.
    @Binding var webViewRef: WKWebView
    
    /// A binding to store the content height, updated via JavaScript message handler.
    @Binding var contentHeight: CGFloat
    
    /// Called once the WebView finishes loading the initial skeleton.
    var onWebViewReady: (() -> Void)?
    
    // This remains empty because we use JavaScript injection to update content,
    // not SwiftUI's update cycle.
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Create and configure WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        // Register the coordinator for "contentHeight" messages from JS
        contentController.add(context.coordinator, name: "contentHeight")
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = context.coordinator
        // Decide whether user can interact with the content:
        webView.isUserInteractionEnabled = themeConfig.userInteractionEnabled
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        
        // Sync the reference back to the parent
        DispatchQueue.main.async {
            webViewRef = webView
        }
        
        // Load the initial KaTeX skeleton or HTML content
        webView.loadHTMLString(htmlContent, baseURL: nil)
        return webView
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        
        var parent: WebView
        var isWebViewReady = false
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Called when WebView finishes loading the initial skeleton
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !isWebViewReady {
                isWebViewReady = true
                parent.onWebViewReady?()  // Let the parent start injecting content
            }
            // Update height once skeleton is loaded (in case it's not empty)
            webView.evaluateJavaScript("updateHeight();")
        }
        
        // This handles messages from JS like {name: "contentHeight", body: <some CGFloat>}
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "contentHeight", let height = message.body as? CGFloat {
                print("Received WebView height:", height)
                DispatchQueue.main.async {
                    // Animate height changes if chunk rendering
                    if self.parent.isAnimationEnabled {
                        withAnimation {
                            self.parent.contentHeight = height
                        }
                    } else {
                        self.parent.contentHeight = height
                    }
                }
            }
        }
    }
}
