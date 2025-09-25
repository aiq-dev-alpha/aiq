// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "iOSApp",
            targets: ["App"]
        )
    ],
    dependencies: [
        // Add your package dependencies here
        // Example:
        // .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        // .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                // Add your target dependencies here
            ],
            path: "Sources/App",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"],
            path: "Tests/AppTests"
        )
    ]
)