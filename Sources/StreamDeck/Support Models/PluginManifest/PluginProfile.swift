//
//  PluginProfile.swift
//  
//
//  Created by Emory Dunn on 12/18/23.
//

import Foundation

/// Preconfigured plugin profiles.
public struct PluginProfile: Codable {

	/// The filename of the profile.
	public let name: String

	/// Type of device.
	public let deviceType: DeviceType

	/// Boolean to mark the profile as read-only. False by default.
	public let readOnly: Bool?

	/// Boolean to prevent Stream Deck from automatically switching to this profile when installed. False by default.
	public let dontAutoSwitchWhenInstalled: Bool?
	
	/// Determines whether the profile should be automatically installed when the plugin is installed.
	///
	/// When `false`, the profile will be installed the first time the plugin attempts to switch to it. Default is `true`.
	public let autoInstall: Bool?

	public init(name: String,
				deviceType: DeviceType,
				readOnly: Bool? = nil,
				autoInstall: Bool? = nil,
				autoSwitchWhenInstalled: Bool? = nil) {
		self.name = name
		self.deviceType = deviceType
		self.readOnly = readOnly
		self.autoInstall = autoInstall

		if let autoSwitchWhenInstalled {
			self.dontAutoSwitchWhenInstalled = !autoSwitchWhenInstalled
		} else {
			self.dontAutoSwitchWhenInstalled = nil
		}

	}
}
