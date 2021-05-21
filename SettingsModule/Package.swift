// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
  name: "SettingsModule",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "SettingsModule",
      targets: ["SettingsModule"]
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
      name: "SettingsModule",
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
      name: "SettingsModuleTests",
      dependencies: [
        "SettingsModule",
        "SnapshotTesting"
      ],
      exclude: ["SettingsView/__Snapshots__/SettingsViewSnapshotTests"]
    ),
  ]
)
