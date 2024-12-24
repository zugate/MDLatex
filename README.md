# MDLatex

A powerful Swift package for seamlessly rendering Markdown with LaTeX support. Features include customizable themes, smooth animations, fluent API modifiers, and compatibility with iOS and macOS, designed for effortless integration into your apps.

---

## Features
- **Markdown and LaTeX Rendering:** Combines the power of Markdown and LaTeX to deliver beautifully rendered content.
- **Customizable Themes:** Modify background color, font size, font family, and more to suit your app’s design.
- **Chunk-based Animations:** Render content in chunks for a smooth and dynamic user experience.
- **Fluent Modifiers:** Easily configure the rendering behavior with a fluent API.
- **Caching for Optimized Performance:** Non-animated rendering supports caching for repeated content.
- **Cross-platform Support:** Compatible with iOS 14.0+ and macOS 11.0+.

---

## Installation

### Swift Package Manager
Add the following to your `Package.swift`:

```swift
.package(url: "https://github.com/zugate/MDLatex.git", from: "1.0.0")
```

Include `MDLatex` as a dependency for your target:

```swift
.target(name: "YourTarget", dependencies: ["MDLatex"]),
```

Or add it via Xcode:
1. Navigate to `File > Add Packages`.
2. Enter the repository URL: `https://github.com/zugate/MDLatex.git`.
3. Choose the latest version and integrate it into your project.

---

## Usage

### Basic Usage
Render Markdown with embedded LaTeX expressions:

```swift
import MDLatex

struct ContentView: View {
    var body: some View {
        MarkdownLatexView(markdownContent: """
        # Title
        This is some inline math: \(x^2 + y^2 = z^2\).

        And a display equation:
        \[
        E = mc^2
        \]
        """)
        .themeConfiguration(
            backgroundColor: .white,
            fontColor: .black,
            fontSize: 16,
            fontFamily: "Arial",
            userInteractionEnabled: true
        )
        .animationEnabled(true, chunkRenderingDuration: 0.5)
    }
}
```

---

### Customizing the Theme
Configure the theme using the fluent API:

```swift
MarkdownLatexView(markdownContent: "# Custom Theme")
    .themeConfiguration(
        backgroundColor: .blue,
        fontColor: .white,
        fontSize: 20,
        fontFamily: "Helvetica",
        userInteractionEnabled: true
    )
```

---

### Animating Content
Enable chunk-based animations for rendering large content:

```swift
MarkdownLatexView(markdownContent: """
# Animated Content
Chunk 1...

Chunk 2...

Chunk 3...
""")
.animationEnabled(true, chunkRenderingDuration: 0.3)
```

Use `onChunkRendered` and `onComplete` for callbacks:

```swift
MarkdownLatexView(markdownContent: "Large Document")
    .onChunkRendered { chunk, index in
        print("Rendered chunk \(index): \(chunk)")
    }
    .onComplete { finalHTML in
        print("Rendering complete: \(finalHTML)")
    }
```

---

### Caching Content
Take advantage of caching in non-animated mode:

```swift
MarkdownLatexView(markdownContent: "Repeated Content")
.renderAllContentAtOnceCached()
```

---

## How It Works

1. **Markdown Parsing:** Uses [Down](https://github.com/johnxnguyen/Down) to convert Markdown into HTML.
2. **LaTeX Handling:** Extracts LaTeX expressions with a custom parser and injects them into the HTML using KaTeX.
3. **Dynamic Rendering:** Supports chunk-based or one-go rendering, depending on the animation configuration.
4. **WebView Integration:** Leverages `WKWebView` for rendering HTML and JavaScript for KaTeX rendering.

---

## Architecture

- **`AnimationConfiguration`:** Defines animation settings like duration and toggle for enabling animations.
- **`ThemeConfiguration`:** Handles theme properties like colors, font size, and font family.
- **`MarkdownLatexView`:** The main SwiftUI view for rendering Markdown and LaTeX.
- **`MarkdownLatexParser`:** A utility for extracting and reinjecting LaTeX expressions into HTML.
- **`katex_template.html`:** A prebuilt HTML template for KaTeX rendering.

---

## Example Project
Check out the example project in the `Examples` folder for a hands-on demonstration of integrating **MDLatex** into your app.

---

## Contributions

We welcome contributions! To get started:
1. Fork the repository.
2. Create a feature branch.
3. Submit a pull request.

For bugs or feature requests, open an issue in the repository.

---

## License

**MDLatex** is available under the MIT license. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

This package is built on:
- [Down](https://github.com/johnxnguyen/Down) for Markdown rendering.
- [KaTeX](https://katex.org) for LaTeX rendering.

