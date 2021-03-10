// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonTests",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "CommonTests",
      targets: ["CommonTests"]),
  ],
  dependencies: [
    .package(path: "../CommonComponents"),
    .package(path: "../CommonDomain")
  ],
  targets: [
    .target(
      name: "CommonTests",
      dependencies: [
        "CommonComponents",
        "CommonDomain"
      ]),
    .testTarget(
      name: "CommonTestsTests",
      dependencies: ["CommonTests"]),
  ]
)
