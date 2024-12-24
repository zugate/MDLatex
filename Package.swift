// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MDLatex",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "MDLatex",
            targets: ["MDLatex"]
        ),
    ],
    dependencies: [
        // Add any dependencies your package requires
        .package(url: "https://github.com/johnxnguyen/Down.git", from: "0.11.0") // Markdown parsing
    ],
    targets: [
        .target(
            name: "MDLatex",
            dependencies: ["Down"],
            resources: [
                .process("Resources") // Include HTML templates or other assets
            ]
        ),
        .testTarget(
            name: "MDLatexTests",
            dependencies: ["MDLatex"]
        ),
    ]
)
