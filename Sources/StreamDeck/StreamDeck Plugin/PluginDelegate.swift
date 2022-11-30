//
//  PluginDelegate.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation
import AppKit

/// The `PluginDelegate` represents the entry point to to your plugin and is used to generate the manifest.
///
/// Your plugin's `@main` type should conform to `PluginDelegate` in order for the framework to handle plugin
/// lifecycle and command line events.
public protocol PluginDelegate {

	/// Settings returned by the Stream Deck application.
	///
	/// If your plugin does not use global settings, simply use `NoSettings`.
	associatedtype Settings: Codable

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
    
    /// Event received after calling the `getSettings` API to retrieve the persistent data stored for the action.
    func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent.Payload)

	@available(*, deprecated, message: "Please declare a Settings type")
    /// Event received after calling the `getGlobalSettings` API to retrieve the global persistent data.
    func didReceiveGlobalSettings(_ settings: [String: String])

	/// Event received after calling the `getGlobalSettings` API to retrieve the global persistent data.
	func didReceiveGlobalSettings(_ settings: Settings)
    
    /// When an instance of an action is displayed on the Stream Deck, for example when the hardware is first plugged in, or when a folder containing that action is entered, the plugin will receive a `willAppear` event.
    ///
    /// You will see such an event when:
    /// - the Stream Deck application is started
    /// - the user switches between profiles
    /// - the user sets a key to use your action
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func willAppear(action: String, context: String, device: String, payload: AppearEvent)
    
    /// When an instance of an action ceases to be displayed on Stream Deck, for example when switching profiles or folders, the plugin will receive a `willDisappear` event.
    ///
    /// You will see such an event when:
    /// - the user switches between profiles
    /// - the user deletes an action
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func willDisappear(action: String, context: String, device: String, payload: AppearEvent)
    
    /// When the user presses a key, the plugin will receive the `keyDown` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func keyDown(action: String, context: String, device: String, payload: KeyEvent)
    
    /// When the user releases a key, the plugin will receive the `keyUp` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func keyUp(action: String, context: String, device: String, payload: KeyEvent)
    
    /// When the user changes the title or title parameters of the instance of an action, the plugin will receive a `titleParametersDidChange` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo)
    
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
    
    /// The plugin will receive a `sendToPlugin` event when the Property Inspector sends a `sendToPlugin` event.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - action: The action unique identifier. If your plugin supports multiple actions, you should use this value to find out which action was triggered.
    ///   - payload: A json object that will be received by the plugin.
    func sentToPlugin(context: String, action: String, payload: [String: String])
    
    /// Called immediately after `main()`. 
    static func pluginWasCreated()
}

public extension PluginDelegate {
    
    /// The default implementation of `static PluginDelegate.pluginWasCreated()`
    static func pluginWasCreated() { }
    
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

	static var applicationsToMonitor: StreamDeck.ApplicationsToMonitor? { nil }

	static var sdkVersion: Int { 2 }

	static var software: StreamDeck.PluginSoftware { .minimumVersion("5.0") }

	static var codePath: String { executableName }

	static var codePathMac: String? { nil }

	static var codePathWin: String? { nil }

	func decodeGlobalSettings(_ data: Data, using decoder: JSONDecoder) throws {
		let settings = try decoder.decode(GlobalSettingsEvent<Settings>.self, from: data)

		didReceiveGlobalSettings(settings.payload.settings)
	}

//	func decodeGlobalSetting
    
}

public extension PluginDelegate {
    
    // MARK: - Events Received
    
    func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent.Payload) { }
    
    func didReceiveGlobalSettings(_ settings: [String: String]) { }

	func didReceiveGlobalSettings(_ settings: Settings) { }
    
    func willAppear(action: String, context: String, device: String, payload: AppearEvent) { }
    
    func willDisappear(action: String, context: String, device: String, payload: AppearEvent) { }
    
    func keyDown(action: String, context: String, device: String, payload: KeyEvent) { }
    
    func keyUp(action: String, context: String, device: String, payload: KeyEvent) { }
    
    func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo) { }
    
    func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) { }
    
    func deviceDidDisconnect(_ device: String) { }
    
    func applicationDidLaunch(_ application: String) { }
    
    func applicationDidTerminate(_ application: String) { }
    
    func systemDidWakeUp() { }
    
    func propertyInspectorDidAppear(action: String, context: String, device: String) { }
    
    func propertyInspectorDidDisappear(action: String, context: String, device: String) { }
    
    func sentToPlugin(context: String, action: String, payload: [String: String]) { }

}


public extension PluginDelegate {
    
    // MARK: Sent
    
    /// Save data persistently for the action's instance.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - settings: A json object which is persistently saved for the action's instance.
    func setSettings(in context: String, to settings: [String: Any]) {
        
        StreamDeckPlugin.shared.sendEvent(.setSettings,
                      context: context,
                      payload: settings)
    }
    
    /// Request the persistent data for the action's instance.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    func getSettings(in context: String) {
        StreamDeckPlugin.shared.sendEvent(.getSettings,
                      context: context,
                      payload: nil)
    }
    
    /// Save data securely and globally for the plugin.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - settings: A json object which is persistently saved globally.
    func setGlobalSettings(_ settings: [String: Any]) {
        StreamDeckPlugin.shared.sendEvent(.setGlobalSettings,
                                          context: StreamDeckPlugin.shared.uuid,
                      payload: settings)
    }
    
    /// Request the global persistent data.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    func getGlobalSettings() {
        StreamDeckPlugin.shared.sendEvent(.getGlobalSettings,
                                          context: StreamDeckPlugin.shared.uuid,
                      payload: nil)
    }
    
    /// Open an URL in the default browser.
    /// - Parameter url: The URL to open
    func openURL(_ url: URL) {
        StreamDeckPlugin.shared.sendEvent(.openURL,
                      context: nil,
                      payload: ["url": url.path])
    }
    
    /// Write a debug log to the logs file.
    /// - Parameter message: A string to write to the logs file.
    func logMessage(_ message: String) {
        NSLog("EVENT: Sending log message: \(message)")
        StreamDeckPlugin.shared.sendEvent(.logMessage, context: nil, payload: ["message": message])
    }
    
    /// Write a debug log to the logs file.
    /// - Parameters:
    ///   - items: Zero or more items to print.
    ///   - separator: A string to print between each item. The default is a single space (" ").
    func logMessage(_ items: Any..., separator: String = " ") {
        let message = items.map {
            String(describing: $0)
        }.joined(separator: separator)
        
        logMessage(message)
    }
    
    /// Dynamically change the title of an instance of an action.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - title: The title to display. If there is no title parameter, the title is reset to the title set by the user.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setTitle(in context: String, to title: String?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        payload["title"] = title
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        StreamDeckPlugin.shared.sendEvent(.setTitle,
                      context: context,
                      payload: payload)
    }
    
    /// Dynamically change the image displayed by an instance of an action.
    ///
    /// The image is automatically encoded to a prefixed base64 string.
    ///
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - image: An image to display.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setImage(in context: String, to image: NSImage?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        payload["image"] = image?.base64String
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        StreamDeckPlugin.shared.sendEvent(.setImage,
                      context: context,
                      payload: payload)
    }
    
    /// Dynamically change the image displayed by an instance of an action.
    ///
    /// The image is automatically encoded to a prefixed base64 string.
    ///
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - image: The name of an image to display.
    ///   - ext: The filename extension of the file to locate.
    ///   - subpath: The subdirectory in the plugin bundle in which to search for images.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setImage(in context: String, toImage image: String?, withExtension ext: String, subdirectory subpath: String?, target: Target? = nil, state: Int? = nil) {
        guard
            let imageURL = Bundle.main.url(forResource: image, withExtension: ext, subdirectory: subpath)
        else {
            logMessage("Could not find \(image ?? "unnamed").\(ext)")
            return
        }
        
        let image = NSImage(contentsOf: imageURL)
        
        setImage(in: context, to: image)
    }
    
    
    /// Dynamically change the image displayed by an instance of an action.
    ///
    /// The image is automatically encoded to a prefixed base64 string.
    ///
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - image: The SVG to display.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setImage(in context: String, toSVG svg: String?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        if let svg = svg {
            payload["image"] = "data:image/svg+xml;charset=utf8,\(svg)"
        }
        
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        StreamDeckPlugin.shared.sendEvent(.setImage,
                      context: context,
                      payload: payload)
    }
    
//    func setTitle(to string: String, target: Target? = nil, state: Int? = nil) throws {
//        try knownContexts.forEach { context in
//            try setTitle(to: string, in: context, target: target, state: state)
//        }
//    }
    
    /// Temporarily show an alert icon on the image displayed by an instance of an action.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    func showAlert(in context: String) {
        StreamDeckPlugin.shared.sendEvent(.showAlert, context: context, payload: nil)
    }
    
    /// Temporarily show an OK checkmark icon on the image displayed by an instance of an action.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    func showOk(in context: String) {
        StreamDeckPlugin.shared.sendEvent(.showOK, context: context, payload: nil)
    }
    
    /// Change the state of the action's instance supporting multiple states.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setState(in context: String, to state: Int) {
        let payload: [String: Any] = ["state": state]

        StreamDeckPlugin.shared.sendEvent(.setState,
                      context: context,
                      payload: payload)
    }
    
    /// Switch to one of the preconfigured read-only profiles.
    /// - Parameter name: The name of the profile to switch to. The name should be identical to the name provided in the manifest.json file.
    func switchToProfile(named name: String) {
        let payload: [String: Any] = ["profile": name]
        // FIXME: Add Device

        StreamDeckPlugin.shared.sendEvent(.switchToProfile,
                                          context: StreamDeckPlugin.shared.uuid,
                      payload: payload)
    }
    
    /// Send a payload to the Property Inspector.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - action: The action unique identifier.
    ///   - payload: A json object that will be received by the Property Inspector.
    func sendToPropertyInspector(in context: String, action: String, payload: [String: Any]) {
        StreamDeckPlugin.shared.sendEvent(.sendToPropertyInspector,
                                          action: action,
                                          context: context,
                                          payload: payload)
    }
}
