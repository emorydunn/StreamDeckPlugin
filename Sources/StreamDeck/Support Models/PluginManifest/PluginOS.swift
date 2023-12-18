//
//  PluginOS.swift
//  
//
//  Created by Emory Dunn on 12/18/23.
//

import Foundation

/// Supported operating systems of a plugin.
///
/// See the [OS section](https://developer.elgato.com/documentation/stream-deck/sdk/manifest/#os) for more information
public struct PluginOS: Codable {

	/// The name of the platform, `mac` or `windows`.
	public let platform: PluginPlatform

	/// The minimum version of the operating system that the plugin requires.
	public let minimumVersion: PlatformMinimumVersion

	/// Initialize a new OS.
	public init(_ platform: PluginPlatform, minimumVersion: PlatformMinimumVersion) {
		self.platform = platform
		self.minimumVersion = minimumVersion
	}

	@available(*, deprecated, renamed: "PluginOS.macOS(_:)")
	/// Initialize a `mac` OS with the specified minimum version
	public static func mac(minimumVersion: PlatformMinimumVersion) -> PluginOS {
		PluginOS(.mac, minimumVersion: minimumVersion)
	}

	/// Initialize a `mac` OS with the specified minimum version
	public static func macOS(_ minimumVersion: PlatformMinimumVersion) -> PluginOS {
		PluginOS(.mac, minimumVersion: minimumVersion)
	}

	@available(*, deprecated, renamed: "PluginOS.windows(_:)")
	/// Initialize a `windows` OS with the specified minimum version
	public static func win(minimumVersion: PlatformMinimumVersion) -> PluginOS {
		PluginOS(.windows, minimumVersion: minimumVersion)
	}

	/// Initialize a `windows` OS with the specified minimum version
	public static func windows(_ minimumVersion: PlatformMinimumVersion) -> PluginOS {
		PluginOS(.windows, minimumVersion: minimumVersion)
	}
}

/// Supported operating systems.
public enum PluginPlatform: String, Codable {
	case mac
	case windows
}

public struct PlatformMinimumVersion: ExpressibleByStringLiteral, Codable {
	let version: String

	public init(stringLiteral value: StringLiteralType) {
		self.version = value
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self.version)
	}

	public static let v11: PlatformMinimumVersion = "10.11"
	public static let v12: PlatformMinimumVersion = "10.12"
	public static let v13: PlatformMinimumVersion = "10.13"
	public static let v14: PlatformMinimumVersion = "10.14"
}
