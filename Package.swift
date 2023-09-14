// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "FlexiblePageControl",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "FlexiblePageControl",
            targets: ["FlexiblePageControl"])
    ],
    targets: [
        .target(
            name: "FlexiblePageControl",
            path: "FlexiblePageControl"
        )
    ]
)
