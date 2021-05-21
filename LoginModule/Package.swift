// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LoginModule",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "LoginModule",
      targets: ["LoginModule"]
    ),
  ],
  dependencies: [
    .package(path: "../CommonUI"),
    .package(path: "../Networking"),
    .package(path: "../CommonDomain"),
    .package(path: "../CommonComponents"),
    .package(path: "../CommonStrings"),
    .package(path: "../CommonInstances"),
    .package(path: "../CommonTests"),
    .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
  ],
  targets: [
    .target(
      name: "LoginModule",
      dependencies: [
        "Networking",
        "CommonDomain",
        "CommonUI",
        "CommonComponents",
        "CommonStrings",
        "CommonInstances",
        "CommonTests"
      ]
    ),
    .testTarget(
      name: "LoginModuleTests",
      dependencies: [
        "LoginModule",
        "SnapshotTesting"
      ],
      exclude: [
        "Scenes/Login/__Snapshots__",
        "Scenes/RegisterAccount/__Snapshots__"
      ]
    ),
  ]
)
