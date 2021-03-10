// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonComponents",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "CommonComponents",
      targets: ["CommonComponents"]),
  ],
  dependencies: [
    .package(path: "../CommonUI"),
  ],
  targets: [
    .target(
      name: "CommonComponents",
      dependencies: [
        "CommonUI",
      ]),
    .testTarget(
      name: "CommonComponentsTests",
      dependencies: ["CommonComponents"]),
  ]
)
