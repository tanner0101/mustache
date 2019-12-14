// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Mustache",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "Mustache", targets: ["Mustache"]),
    ],
    dependencies: [ ],
    targets: [
        .target(name: "CMustache"),
        .target(name: "Mustache", dependencies: ["CMustache"]),
        .testTarget(name: "MustacheTests", dependencies: ["Mustache"]),
    ]
)
