//
//  PluginDelegate.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation
import AppKit

@available(*, deprecated, renamed: "StreamDeckPlugin")
public typealias PluginDelegate = Plugin
/// The `PluginDelegate` represents the entry point to to your plugin and is used to generate the manifest.
///
/// Your plugin's `@main` type should conform to `PluginDelegate` in order for the framework to handle plugin
/// lifecycle and command line events.
public protocol Plugin {

	// MARK: Manifest
	
	/// The name of the plugin.
	///
	/// This string is displayed to the user in the Stream Deck store.
	static var name: String { get }
	
	/// Provides a general description of what the plugin does.
	///
	/// This string is displayed to the user in the Stream Deck store.
	static var description: String { get }
	
	/// The name of the custom category in which the actions should be listed.
	///
	/// This string is visible to the user in the actions list. If you don't provide a category, the actions will appear inside a "Custom" category.
	static var category: String? { get }
	
	/// The relative path to a PNG image without the .png extension.
	///
	/// This image is used in the actions list. The PNG image should be a 28pt x 28pt image.
	/// You should provide @1x and @2x versions of the image.
	/// The Stream Deck application takes care of loading the appropriate version of the image.
	static var categoryIcon: String? { get }
	
	/// The author of the plugin.
	///
	/// This string is displayed to the user in the Stream Deck store.
	static var author: String { get }
	
	/// The relative path to a PNG image without the .png extension.
	///
	/// This image is displayed in the Plugin Store window. The PNG image should be a 72pt x 72pt image.
	/// You should provide @1x and @2x versions of the image.
	/// The Stream Deck application takes care of loading the appropriate version of the image.
	static var icon: String { get }
	
	/// A URL displayed to the user if he wants to get more info about the plugin.
	static var url: URL? { get }
	
	/// The version of the plugin which can only contain digits and periods.
	///
	/// This is used for the software update mechanism.
	static var version: String { get }
	
	/// The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
	static var os: [PluginOS] { get }
	
	/// List of application identifiers to monitor (applications launched or terminated).
	///
	/// See the [applicationDidLaunch][launch] and [applicationDidTerminate][term] events.
	///
	/// [launch]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidlaunch
	/// [term]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidterminate
	static var applicationsToMonitor: ApplicationsToMonitor? { get }
	
	/// Indicates which version of the Stream Deck application is required to install the plugin.
	static var software: PluginSoftware { get }
	
	/// This value should be set to 2.
	static var sdkVersion: Int { get }
	
	/// The relative path to the HTML/binary file containing the code of the plugin.
	static var codePath: String { get }
	
	/// Override CodePath for macOS.
	static var codePathMac: String? { get }
	
	/// Override CodePath for Windows.
	static var codePathWin: String? { get }
	
	/// The actions defined by your plugin.
	static var actions: [any Action.Type] { get }
	
	init()
	
	// MARK: Events Received
	
	func didReceiveGlobalSettings()

	/// When a device is plugged to the computer, the plugin will receive a `deviceDidConnect` event.
	/// - Parameters:
	///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo)
	
	/// When a device is unplugged from the computer, the plugin will receive a `deviceDidDisconnect` event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	func deviceDidDisconnect(_ device: String)
	
	/// A plugin can request in its manifest.json to be notified when some applications are launched or terminated.
	///
	/// In order to do so, the manifest.json should contain an `ApplicationsToMonitor` object specifying the list of application identifiers to monitor.
	/// On macOS the application bundle identifier is used while the exe filename is used on Windows.
	/// - Parameter application: The identifier of the application that has been launched.
	func applicationDidLaunch(_ application: String)
	
	/// A plugin can request in its manifest.json to be notified when some applications are launched or terminated.
	///
	/// In order to do so, the manifest.json should contain an `ApplicationsToMonitor` object specifying the list of application identifiers to monitor.
	/// On macOS the application bundle identifier is used while the exe filename is used on Windows.
	/// - Parameter application: The identifier of the application that has been launched.
	func applicationDidTerminate(_ application: String)
	
	/// When the computer is wake up, the plugin will receive the `systemDidWakeUp` event.
	func systemDidWakeUp()
	
	/// The plugin will receive a `propertyInspectorDidAppear` event when the Property Inspector appears.
	/// - Parameters:
	///   - action: The action unique identifier.
	///   - context: An opaque value identifying the instance's action.
	///   - device: An opaque value identifying the device.
	func propertyInspectorDidAppear(action: String, context: String, device: String)
	
	/// The plugin will receive a `propertyInspectorDidDisappear` event when the Property Inspector appears.
	/// - Parameters:
	///   - action: The action unique identifier.
	///   - context: An opaque value identifying the instance's action.
	///   - device: An opaque value identifying the device.
	func propertyInspectorDidDisappear(action: String, context: String, device: String)

	/// Called immediately after `main()`. 
	static func pluginWasCreated()
}

