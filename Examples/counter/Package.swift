// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CounterPlugin",
	platforms: [.macOS(.v12)],
	products: [
		.executable(name: "counter-plugin", targets: ["counter"])
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(path: "../../"), // For local development
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.executableTarget(
			name: "counter",
			dependencies: [
				.product(name: "StreamDeck", package: "StreamDeckPlugin"),
			]),
	]
)
