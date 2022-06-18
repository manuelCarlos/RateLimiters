// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "RateLimiters",
                      platforms: [
                        .iOS("16.0")
                      ],
                      // Products define the executables and libraries produced by a package, and make them visible to other packages.
                      products: [
                        .library(name: "Throttler", targets: ["Throttler"]),
                        .library(name: "Debouncer", targets: ["Debouncer"])
                      ],

                      dependencies: [
                        .package(url: "https://github.com/apple/swift-async-algorithms.git", .branch("main"))
                      ],

                      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
                      // Targets can depend on other targets in this package, and on products in packages which this package depends on.
                      // MARK: - Public API
                      targets: [
                        .target(name: "Throttler",
                                dependencies: [.product(name: "AsyncAlgorithms", package: "swift-async-algorithms")]),

                        .target(name: "Debouncer",
                                dependencies: [.product(name: "AsyncAlgorithms", package: "swift-async-algorithms")]),

                        .testTarget(name: "ThrottlerTests", dependencies: ["Throttler"]),
                        .testTarget(name: "DebouncerTests", dependencies: ["Debouncer"])
                      ],
                      swiftLanguageVersions: [
                        .v5
                      ])
