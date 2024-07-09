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
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.44.0"),
        .package(url: "https://github.com/joomcode/BottomSheet", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "WrapKit",
            dependencies: [
                .product(name: "BottomSheet", package: "BottomSheet", condition: .when(platforms: [.iOS]))
            ],
            path: "WrapKitCore/Sources"
        ),
        .target(
            name: "WrapKitRealm",
            dependencies: [
                .targetItem(name: "WrapKit", condition: nil),
                .product(name: "Realm", package: "realm-swift"),
                .product(name: "RealmSwift", package: "realm-swift"),
            ],
            path: "WrapKitRealm/Sources"
        ),
        .testTarget(
            name: "WrapKitTests",
            dependencies: ["WrapKit", .product(name: "BottomSheet", package: "BottomSheet", condition: .when(platforms: [.iOS]))],
            path: "WrapKitCore/Tests"
        ),
    ]
)
