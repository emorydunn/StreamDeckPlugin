//
//  PluginSoftware.swift
//  
//
//  Created by Emory Dunn on 12/18/23.
//

import Foundation

/// The minimum version of the Stream Deck application supported.
public struct PluginSoftware: Codable, ExpressibleByStringLiteral {

	/// The minimum version of the Stream deck application that the plugin requires.
	///
	/// - Important: This value should be set to only support Stream Deck 4.1 or later.
	public let minimumVersion: String

	/// Initialize a new software version.
	/// - Parameter minimumVersion: This value should be set to only support Stream Deck 4.1 or later.
	public init(minimumVersion: String) {
		self.minimumVersion = minimumVersion
	}

	public init(stringLiteral value: StringLiteralType) {
		self.minimumVersion = value
	}

	/// Convenience method for setting the software version in a manifest.
	public static func minimumVersion(_ minimumVersion: String) -> PluginSoftware {
		PluginSoftware(minimumVersion: minimumVersion)
	}

}
