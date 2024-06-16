// swift-tools-version:5.8

import PackageDescription

let swiftSettings: [SwiftSetting] = [
   .enableUpcomingFeature("BareSlashRegexLiterals"),
   .enableUpcomingFeature("ConciseMagicFile"),
   .enableUpcomingFeature("ExistentialAny"),
   .enableUpcomingFeature("ForwardTrailingClosures"),
   .enableUpcomingFeature("ImplicitOpenExistentials"),
   .enableUpcomingFeature("StrictConcurrency"),
   .enableUpcomingFeature("ImportObjcForwardDeclarations"),
   .enableUpcomingFeature("DisableOutwardActorInference"),
   .enableUpcomingFeature("InternalImportsByDefault"),
   .enableUpcomingFeature("IsolatedDefaultValues"),
   .enableUpcomingFeature("GlobalConcurrency"),
   .enableExperimentalFeature("StrictConcurrency"),
   .unsafeFlags([
    "-warn-concurrency",
    "-enable-actor-data-race-checks",
    "-Xfrontend",
    "-warn-long-function-bodies=50",
    "-Xfrontend",
    "-warn-long-expression-type-checking=100"
   ])
]

let package = Package(name: "RateLimiters",

                      products: [
                        .library(name: "Throttler", targets: ["Throttler"]),
                        .library(name: "Debouncer", targets: ["Debouncer"])
                      ],

                      targets: [
                        .target(name: "Throttler",
                                resources: [.process("PrivacyInfo.xcprivacy")],
                                swiftSettings: swiftSettings
                               ),
                        .target(name: "Debouncer",
                                resources: [.process("PrivacyInfo.xcprivacy")],
                                swiftSettings: swiftSettings
                               ),

                        .testTarget(name: "ThrottlerTests", dependencies: ["Throttler"]),
                        .testTarget(name: "DebouncerTests", dependencies: ["Debouncer"])
                      ])
