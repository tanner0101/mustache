// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "mustache",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "Mustache", targets: ["Mustache"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "CMustache"),
        .target(
            name: "Mustache",
            dependencies: [
                .target(name: "CMustache"),
            ]
        ),
        .testTarget(
            name: "MustacheTests",
            dependencies: [
                .target(name: "Mustache"),
            ]
        ),
    ]
)
