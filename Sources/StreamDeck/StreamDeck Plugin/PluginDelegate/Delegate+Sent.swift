//
//  Delegate+Sent.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation
import AppKit

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
