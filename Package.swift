// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CombineWaiting",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "CombineWaiting", targets: ["CombineWaiting"]),
    ],
    targets: [
        .target(name: "CombineWaiting"),
        .testTarget(name: "CombineWaitingTests", dependencies: ["CombineWaiting"]),
    ]
)
