// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TFYSwiftSegmentedKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TFYSwiftSegmentedKit",
            targets: ["TFYSwiftSegmentedKit"]
        )
    ],
    targets: [
        .target(
            name: "TFYSwiftSegmentedKit",
            path: "TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit",
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ]
        ),
        .testTarget(
            name: "TFYSwiftSegmentedKitTests",
            dependencies: ["TFYSwiftSegmentedKit"],
            path: "Tests/TFYSwiftSegmentedKitTests"
        )
    ]
)
