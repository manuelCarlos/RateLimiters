// swift-tools-version:5.8

import PackageDescription

let package = Package(name: "RateLimiters",

                      products: [
                        .library(name: "Throttler", targets: ["Throttler"]),
                        .library(name: "Debouncer", targets: ["Debouncer"])
                      ],

                      targets: [
                        .target(name: "Throttler",
                                resources: [.process("PrivacyInfo.xcprivacy")]
                               ),
                        .target(name: "Debouncer",
                                resources: [.process("PrivacyInfo.xcprivacy")]
                               ),

                        .testTarget(name: "ThrottlerTests", dependencies: ["Throttler"]),
                        .testTarget(name: "DebouncerTests", dependencies: ["Debouncer"])
                      ])
