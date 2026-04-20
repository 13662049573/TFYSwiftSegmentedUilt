// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TFYSwiftSegmentedKit",
    defaultLocalization: "en",
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
