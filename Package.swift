// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "WrapKit",
    products: [
        .library(
            name: "WrapKitStatic",
            type: .static,
            targets: ["WrapKit"]),
        .library(
            name: "WrapKitRealm",
            type: .static,
            targets: ["WrapKitRealm"]),
        .library(
            name: "WrapKitDynamic",
            type: .dynamic,
            targets: ["WrapKit"])
    ],
    dependencies: [.package(url: "https://github.com/realm/realm-swift.git", exact: "10.44.0")],
    targets: [
        .target(
            name: "WrapKit",
            path: "WrapKitCore/Sources"
        ),
        .target(
            name: "WrapKitRealm",
            dependencies: [
                .product(name: "Realm", package: "realm-swift"),
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            path: "WrapKitRealm/Sources"
        ),
        .testTarget(
            name: "WrapKitTests",
            dependencies: ["WrapKit"],
            path: "WrapKitCore/Tests"
        ),
    ]
)
