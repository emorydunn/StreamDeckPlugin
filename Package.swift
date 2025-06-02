// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

var package = Package(
	name: "StreamDeck",
	platforms: [.macOS(.v12)],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "StreamDeck",
			targets: ["StreamDeck"])
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),

		// Depend on the latest Swift 5.9 prerelease of SwiftSyntax
		.package(url: "https://github.com/swiftlang/swift-syntax.git", "509.0.0"..<"602.0.0"),

		// Documentation
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.

		// MARK: Plugin
		.target(
			name: "StreamDeck",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				"StreamDeckMacros",
				"SDPlusLayout"
			]),
		.testTarget(
			name: "StreamDeckPluginTests",
			dependencies: ["StreamDeck"],
			resources: [.copy("Support/Test Events")]),

		// MARK: Components

		.target(name: "SDPlusLayout"),
		.testTarget(name: "SDPlusLayoutTests", dependencies: ["SDPlusLayout"]),

		// MARK: Macros
		.macro(
			name: "StreamDeckMacros",
			dependencies: [
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax")
			]
		),

		// A test target used to develop the macro implementation.
		.testTarget(
			name: "StreamDeckMacrosTests",
			dependencies: [
				"StreamDeckMacros",
				.product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
			]
		),

	]
)

