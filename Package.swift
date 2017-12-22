// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftThanks",
    dependencies: [
        .package(url: "https://github.com/vapor/console.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(name: "SwiftThanks", dependencies: ["Console"]),
    ]
)
