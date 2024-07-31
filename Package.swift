// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDataDao",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "SwiftDataDao",
            targets: ["SwiftDataDao"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftDataDao"
        ),
        .testTarget(
            name: "SwiftDataDaoTests",
            dependencies: ["SwiftDataDao"]
        ),
    ],
    swiftLanguageVersions: [
        .v6
    ]
)
