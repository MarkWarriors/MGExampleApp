// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HomeModule",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "HomeModule",
      targets: ["HomeModule"]
    ),
  ],
  dependencies: [
    .package(path: "../CommonUI"),
    .package(path: "../Networking"),
    .package(path: "../CommonDomain"),
    .package(path: "../CommonComponents"),
    .package(path: "../CommonStrings"),
    .package(path: "../CommonTests"),
    .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
  ],
  targets: [
    .target(
      name: "HomeModule",
      dependencies: [
        "Networking",
        "CommonDomain",
        "CommonUI",
        "CommonComponents",
        "CommonStrings",
        "CommonTests"
      ]
    ),
    .testTarget(
      name: "HomeModuleTests",
      dependencies: [
        "HomeModule",
        "SnapshotTesting"
      ]
    ),
  ]
)
