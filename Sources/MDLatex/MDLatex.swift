import SwiftUI

/// `MDLatex` provides a SwiftUI interface for rendering Markdown and LaTeX content with customizable themes and animations.
public struct MDLatex {
    
    /// Renders Markdown and LaTeX content within a SwiftUI view.
    /// - Parameters:
    ///   - markdown: The Markdown content to render.
    ///   - theme: The theme configuration for customizing the appearance. Defaults to `ThemeConfiguration()`.
    ///   - animation: The animation configuration for controlling chunk rendering. Defaults to `AnimationConfiguration()`.
    ///   - width: The width of the rendered view. Defaults to the full screen width.
    ///   - onComplete: A callback executed when the rendering completes.
    ///   - onChunkRendered: A callback executed after each chunk of Markdown content is rendered.
    /// - Returns: A SwiftUI `View` displaying the rendered content.
    public static func render(
        markdown: String,
        theme: ThemeConfiguration = ThemeConfiguration(),
        animation: AnimationConfiguration = AnimationConfiguration(),
        width: CGFloat = UIScreen.main.bounds.width,
        onComplete: ((String) -> Void)? = nil,
        onChunkRendered: ((String, Int) -> Void)? = nil
    ) -> some View {
        MarkdownLatexView(
            markdownContent: markdown,
            width: width,
            viewModel: .init()
        )
        .themeConfiguration(
            backgroundColor: theme.backgroundColor,
            fontColor: theme.fontColor,
            fontSize: theme.fontSize,
            fontFamily: theme.fontFamily,
            userInteractionEnabled: theme.userInteractionEnabled
        )
        .animationEnabled(
            animation.isEnabled,
            chunkRenderingDuration: animation.chunkRenderingDuration
        )
        .onComplete(onComplete ?? { _ in })
        .onChunkRendered(onChunkRendered ?? { _, _ in })
    }
}
