// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonUI",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "CommonUI",
      targets: ["CommonUI"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "CommonUI",
      dependencies: [],
      resources: [
        .process("Assets"),
        .process("Fonts")
      ]),
    .testTarget(
      name: "CommonUITests",
      dependencies: ["CommonUI"]),
  ]
)
