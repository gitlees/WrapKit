// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "WrapKit",
    products: [
        .library(
            name: "WrapKit",
            type: .static,
            targets: ["WrapKit"]),
        .library(
            name: "WrapKitRealm",
            type: .static,
            targets: ["WrapKitRealm"]),
    ],
    targets: [
        .target(
            name: "WrapKit",
            dependencies: [],
            path: "WrapKitCore/Sources"
        ),
        .target(
            name: "WrapKitRealm",
            dependencies: [
                "WrapKit",
            ],
            path: "WrapKitRealm/Sources"
        ),
        .testTarget(
            name: "WrapKitRealmTests",
            dependencies: ["WrapKit"],
            path: "WrapKitRealm/Tests"
        ),
        .testTarget(
            name: "WrapKitTests",
            dependencies: ["WrapKit"],
            path: "WrapKitCore/Tests"
        ),
    ]
)
