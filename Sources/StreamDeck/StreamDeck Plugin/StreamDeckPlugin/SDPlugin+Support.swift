//
//  Delegate+Support.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

public extension Plugin {
	
	/// The default implementation of `static PluginDelegate.pluginWasCreated()`
	static func pluginWasCreated() { }
	
	/// The default `main` function.
	///
	/// This method configures the plugin, calls `pluginWasCreated()`, and then registers the plugin.
	static func main() {
		pluginWasCreated()
		
		PluginCommand.plugin = self
		PluginCommand.configuration.version = version
		PluginCommand.configuration.abstract = description
		PluginCommand.configuration.discussion = """
  \(name) by \(author)
  
  Version \(version)
  """
		PluginCommand.main()
	}
	
	/// Determine the CodePath for the plugin based on the bundles executable's name.
	static var executableName: String {
		Bundle.main.executableURL!.lastPathComponent
	}

	static var category: String? { nil }

	static var categoryIcon: String? { nil }

	static var applicationsToMonitor: StreamDeck.ApplicationsToMonitor? { nil }

	static var url: URL? { nil }

	static var sdkVersion: Int { 2 }
	
	static var software: StreamDeck.PluginSoftware { .minimumVersion("5.0") }

	static var os: [PluginOS] { [.mac(minimumVersion: .v11)] }

	static var codePath: String { executableName }
	
	static var codePathMac: String? { nil }
	
	static var codePathWin: String? { nil }
	
}

extension Plugin {

	@available(*, deprecated, message: "Use the @GlobalSetting")
	func decodeGlobalSettings(_ data: Data, using decoder: JSONDecoder) throws {
//		let settings = try decoder.decode(GlobalSettingsEvent<Settings>.self, from: data)
//		
//		didReceiveGlobalSettings(settings.payload.settings)
	}
}
