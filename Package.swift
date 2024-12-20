// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LaTeXSwiftUI",
  platforms: [
    .iOS(.v14), // SVGView requires min v14
    .macOS(.v13),
    .macCatalyst(.v13)
  ],
  products: [
    .library(
      name: "LaTeXSwiftUI",
      targets: ["LaTeXSwiftUI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/colinc86/MathJaxSwift", from: "3.4.0"),
    .package(url: "https://github.com/exyte/SVGView", from: "1.0.6"),
    .package(url: "https://github.com/Kitura/swift-html-entities", from: "4.0.1"),
    .package(url: "https://github.com/SDWebImage/SDWebImageSVGCoder.git", from: "1.4.0")
  ],
  targets: [
    .target(
      name: "LaTeXSwiftUI",
      dependencies: [
        "MathJaxSwift",
        "SVGView",
        .product(name: "HTMLEntities", package: "swift-html-entities"),
        .product(name: "SDWebImageSVGCoder", package: "SDWebImageSVGCoder")
      ]),
    .testTarget(
      name: "LaTeXSwiftUITests",
      dependencies: ["LaTeXSwiftUI"]),
  ]
)
