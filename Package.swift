// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Throttler",

                      // Products define the executables and libraries produced by a package, and make them visible to other packages.
                      products: [
                        .library(name: "Throttler", targets: ["Throttler"])
                      ],

                      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
                      // Targets can depend on other targets in this package, and on products in packages which this package depends on.
                      // MARK: - Public API
                      targets: [
                        .target(name: "Throttler"),
                        .testTarget(name: "ThrottlerTests", dependencies: ["Throttler"])
                      ],
                      swiftLanguageVersions: [
                        .v5
                      ])
