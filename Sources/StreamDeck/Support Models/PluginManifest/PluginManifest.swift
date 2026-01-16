//
//  PluginManifest.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation

/// The manifest file providing plugin details.
///
/// See the [SDK documentation](https://docs.elgato.com/streamdeck/sdk/references/manifest) for more information.
struct PluginManifest: Codable {

	/// The name of the plugin.
	///
	/// This string is displayed to the user in the Stream Deck store.
	var name: String

	/// Provides a general description of what the plugin does.
	///
	/// This string is displayed to the user in the Stream Deck store.
	var description: String

	/// The name of the custom category in which the actions should be listed.
	///
	/// This string is visible to the user in the actions list. If you don't provide a category, the actions will appear inside a "Custom" category.
	var category: String?

	/// The relative path to a PNG image without the .png extension.
	///
	/// This image is used in the actions list. The PNG image should be a 28pt x 28pt image.
	/// You should provide @1x and @2x versions of the image.
	/// The Stream Deck application takes care of loading the appropriate version of the image.
	var categoryIcon: String?

	/// The author of the plugin.
	///
	/// This string is displayed to the user in the Stream Deck store.
	var author: String

	/// The relative path to a PNG image without the .png extension.
	///
	/// This image is displayed in the Plugin Store window. The PNG image should be a 72pt x 72pt image.
	/// You should provide @1x and @2x versions of the image.
	/// The Stream Deck application takes care of loading the appropriate version of the image.
	var icon: String

	/// A URL displayed to the user if he wants to get more info about the plugin.
	var url: URL?

	/// The version of the plugin which can only contain digits and periods.
	///
	/// This is used for the software update mechanism.
	var version: String

	/// The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
	var os: [PluginOS]

	/// List of application identifiers to monitor (applications launched or terminated).
	///
	/// See the [applicationDidLaunch][launch] and [applicationDidTerminate][term] events.
	///
	/// [launch]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidlaunch
	/// [term]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidterminate
	var applicationsToMonitor: ApplicationsToMonitor?

	/// Indicates which version of the Stream Deck application is required to install the plugin.
	var software: PluginSoftware

	/// This value should be set to 2.
	var sdkVersion: Int

	/// The relative path to the HTML/binary file containing the code of the plugin.
	var codePath: String

	/// Override CodePath for macOS.
	var codePathMac: String?

	/// Override CodePath for Windows.
	var codePathWin: String?

	/// Specifies an array of actions.
	///
	/// A plugin can indeed have one or multiple actions.
	///
	/// For example the Game Capture plugin has 6 actions: Scene, Record, Screenshot, Flashback Recording, Stream, Live Commentary.
	var actions: [PluginAction]

	var profiles: [PluginProfile]

	/// Initialize a new manifest.
	/// - Parameters:
	///   - name: The name of the plugin.
	///   - description: Provides a general description of what the plugin does.
	///   - category: The name of the custom category in which the actions should be listed.
	///   - categoryIcon: The relative path to a PNG image without the .png extension.
	///   - author: The author of the plugin.
	///   - icon: The relative path to a PNG image without the .png extension.
	///   - url: A URL displayed to the user if he wants to get more info about the plugin.
	///   - version: The version of the plugin which can only contain digits and periods.
	///   - os: The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
	///   - applicationsToMonitor: List of application identifiers to monitor (applications launched or terminated).
	///   - software: Indicates which version of the Stream Deck application is required to install the plugin.
	///   - sdkVersion: This value should be set to 2.
	///   - codePath: The relative path to the HTML/binary file containing the code of the plugin. Defaults to the executable name.
	///   - codePathMac: Override CodePath for macOS.
	///   - codePathWin: Override CodePath for Windows.
	///   - actions: Specifies an array of actions.
	init(name: String,
		 description: String,
		 category: String? = nil,
		 categoryIcon: String? = nil,
		 author: String,
		 icon: String,
		 url: URL? = nil,
		 version: String,
		 os: [PluginOS],
		 applicationsToMonitor: ApplicationsToMonitor? = nil,
		 software: PluginSoftware,
		 sdkVersion: Int = 2,
		 codePath: String = PluginManifest.executableName,
		 codePathMac: String? = nil,
		 codePathWin: String? = nil,
		 actions: [PluginAction],
		 profiles: [PluginProfile]) {
		self.name = name
		self.description = description
		self.category = category
		self.categoryIcon = categoryIcon
		self.author = author
		self.icon = icon
		self.url = url
		self.version = version
		self.os = os
		self.applicationsToMonitor = applicationsToMonitor
		self.software = software
		self.sdkVersion = sdkVersion
		self.codePath = codePath
		self.codePathMac = codePathMac
		self.codePathWin = codePathWin
		self.actions = actions
		self.profiles = profiles
	}

	/// Initialize a new manifest.
	/// - Parameters:
	///   - name: The name of the plugin.
	///   - description: Provides a general description of what the plugin does.
	///   - category: The name of the custom category in which the actions should be listed.
	///   - categoryIcon: The relative path to a PNG image without the .png extension.
	///   - author: The author of the plugin.
	///   - icon: The relative path to a PNG image without the .png extension.
	///   - url: A URL displayed to the user if he wants to get more info about the plugin.
	///   - version: The version of the plugin which can only contain digits and periods.
	///   - os: The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
	///   - applicationsToMonitor: List of application identifiers to monitor (applications launched or terminated).
	///   - software: Indicates which version of the Stream Deck application is required to install the plugin.
	///   - sdkVersion: This value should be set to 2.
	///   - codePath: The relative path to the HTML/binary file containing the code of the plugin. Defaults to the executable name.
	///   - codePathMac: Override CodePath for macOS.
	///   - codePathWin: Override CodePath for Windows.
	///   - actions: Specifies an array of actions.
	init(name: String,
		 description: String,
		 category: String? = nil,
		 categoryIcon: String? = nil,
		 author: String,
		 icon: String,
		 url: URL? = nil,
		 version: String,
		 os: [PluginOS],
		 applicationsToMonitor: ApplicationsToMonitor? = nil,
		 software: PluginSoftware,
		 sdkVersion: Int = 2,
		 codePath: String = PluginManifest.executableName,
		 codePathMac: String? = nil,
		 codePathWin: String? = nil,
		 actions: PluginAction...,
		 profiles: PluginProfile...) {
		self.name = name
		self.description = description
		self.category = category
		self.categoryIcon = categoryIcon
		self.author = author
		self.icon = icon
		self.url = url
		self.version = version
		self.os = os
		self.applicationsToMonitor = applicationsToMonitor
		self.software = software
		self.sdkVersion = sdkVersion
		self.codePath = codePath
		self.codePathMac = codePathMac
		self.codePathWin = codePathWin
		self.actions = actions
		self.profiles = profiles
	}

	init(plugin: any Plugin.Type) {
		self.name = plugin.name
		self.description = plugin.description
		self.category = plugin.category
		self.categoryIcon = plugin.categoryIcon
		self.author = plugin.author
		self.icon = plugin.icon
		self.url = plugin.url
		self.version = plugin.version
		self.os = plugin.os
		self.applicationsToMonitor = plugin.applicationsToMonitor
		self.software = plugin.software
		self.sdkVersion = plugin.sdkVersion
		self.codePath = plugin.codePath
		self.codePathMac = plugin.codePathMac
		self.codePathWin = plugin.codePathWin
		self.actions = plugin.actions.map { PluginAction(action: $0) }
		self.profiles = plugin.profiles
	}

}

extension PluginManifest {

	/// Determine the CodePath for the plugin based on the bundles executable's name.
	public static var executableName: String {
		Bundle.main.executableURL!.lastPathComponent
	}
}
