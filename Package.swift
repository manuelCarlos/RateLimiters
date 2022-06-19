// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "RateLimiters",
                      platforms: [
                        .iOS("16.0")
                      ],

                      products: [
                        .library(name: "Throttler", targets: ["Throttler"]),
                        .library(name: "Debouncer", targets: ["Debouncer"])
                      ],

                      targets: [
                        .target(name: "Throttler"),
                        .target(name: "Debouncer"),

                        .testTarget(name: "ThrottlerTests", dependencies: ["Throttler"]),
                        .testTarget(name: "DebouncerTests", dependencies: ["Debouncer"])
                      ],

                      swiftLanguageVersions: [
                        .v5
                      ])
