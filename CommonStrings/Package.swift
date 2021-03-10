// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonStrings",
  defaultLocalization: "en",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "CommonStrings",
      targets: ["CommonStrings"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "CommonStrings",
      dependencies: [],
      resources: [.process("Resources")]),
    .testTarget(
      name: "CommonStringsTests",
      dependencies: ["CommonStrings"]),
  ]
)
