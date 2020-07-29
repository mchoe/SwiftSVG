// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftSVG",
    platforms: [.macOS(.v10_14), .iOS(.v8), .tvOS(.v9)],
    products: [
        .library(
            name: "SwiftSVG",
            targets: ["SwiftSVG"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftSVG",
            dependencies: [],
            path: "SwiftSVG"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
