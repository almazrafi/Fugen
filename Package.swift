// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Fugen",
    platforms: [
       .macOS(.v10_12)
    ],
    products: [
        .executable(name: "fugen", targets: ["Fugen"]),
        .library(name: "FugenTools", targets: ["FugenTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.2"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.7.2"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.8.0")
    ],
    targets: [
        .target(
            name: "Fugen",
            dependencies: [
                "SwiftCLI",
                "Rainbow",
                "Yams",
                "PathKit",
                "Stencil",
                "StencilSwiftKit",
                "PromiseKit",
                "FugenTools"
            ],
            path: "Sources/Fugen"
        ),
        .target(
            name: "FugenTools",
            dependencies: [
                "SwiftCLI",
                "PathKit",
                "PromiseKit"
            ],
            path: "Sources/FugenTools"
        ),
        .testTarget(
            name: "FugenTests",
            dependencies: ["Fugen"],
            path: "Tests/FugenTests"
        ),
        .testTarget(
            name: "FugenToolsTests",
            dependencies: ["FugenTools"],
            path: "Tests/FugenToolsTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
