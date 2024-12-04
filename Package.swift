// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-zsv",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "SwiftZSV", targets: ["SwiftZSV"])
    ],
    targets: [
        .binaryTarget(
            name: "libzsv",
            path: "Libraries/libzsv.xcframework"
        ),
        .target(
            name: "CLibzsv",
            dependencies: [.target(name: "libzsv")],
            path: "Sources/C/CLibzsv",
            cSettings: [.headerSearchPath("../../../Libraries/**")]
        ),
        .target(
            name: "SwiftZSV",
            dependencies: [.target(name: "CLibzsv")],
            path: "Sources/Swift",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SwiftZSVTests",
            dependencies: [.target(name: "SwiftZSV")],
            path: "Tests",
            resources: [.copy("Resources")]
        )
    ]
)
