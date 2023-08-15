// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

var package = Package(
	name: "StreamDeck",
	platforms: [.macOS(.v11)],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "StreamDeck",
			targets: ["StreamDeck"])
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.4.3"),

		// Depend on the latest Swift 5.9 prerelease of SwiftSyntax
		.package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "StreamDeck",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			]),
		.testTarget(
			name: "StreamDeckPluginTests",
			dependencies: ["StreamDeck"],
			resources: [.copy("Support/Test Events")]),

	]
)

