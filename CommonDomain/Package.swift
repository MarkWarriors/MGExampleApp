// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "CommonDomain",
  platforms: [
    .macOS(.v10_12),
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "CommonDomain",
      targets: ["CommonDomain"]),
  ],
  dependencies: [
    .package(path: "../Networking"),
  ],
  targets: [
    .target(
      name: "CommonDomain",
      dependencies: [
        "Networking"
      ]),
    .testTarget(
      name: "CommonDomainTests",
      dependencies: ["CommonDomain"]),
  ]
)
