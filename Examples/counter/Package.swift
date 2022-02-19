// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CounterPlugin",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "counter-plugin", targets: ["counter"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "StreamDeck", url: "https://github.com/emorydunn/StreamDeckPlugin.git", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "counter",
            dependencies: [
                .product(name: "StreamDeck", package: "StreamDeck")
            ]),
    ]
)
