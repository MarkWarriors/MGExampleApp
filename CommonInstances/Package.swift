// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonInstances",
  platforms: [
    .macOS(.v10_12),
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "CommonInstances",
      targets: ["CommonInstances"]),
  ],
  dependencies: [
    .package(path: "../Networking"),
  ],
  targets: [
    .target(
      name: "CommonInstances",
      dependencies: [
        "Networking"
      ]),
    .testTarget(
      name: "CommonInstancesTests",
      dependencies: ["CommonInstances"]),
  ]
)
