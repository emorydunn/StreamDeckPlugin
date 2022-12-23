//
//  Action+Sent.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation
import AppKit

public extension Action {

	// MARK: Sent

	/// Save data persistently for the action's instance.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - settings: A json object which is persistently saved for the action's instance.
	func setSettings(to settings: [String: Any]) {
		// TODO: Adopt Settings
		StreamDeckPlugin.shared.sendEvent(.setSettings,
					  context: context,
					  payload: settings)
	}

	/// Request the persistent data for the action's instance.
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	func getSettings() {
		StreamDeckPlugin.shared.sendEvent(.getSettings,
					  context: context,
					  payload: nil)
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
	func setTitle(to title: String?, target: Target? = nil, state: Int? = nil) {
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
	func setImage(to image: NSImage?, target: Target? = nil, state: Int? = nil) {
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
	func setImage(toImage image: String?, withExtension ext: String, subdirectory subpath: String?, target: Target? = nil, state: Int? = nil) {
		guard
			let imageURL = Bundle.main.url(forResource: image, withExtension: ext, subdirectory: subpath)
		else {
			logMessage("Could not find \(image ?? "unnamed").\(ext)")
			setImage(to: nil, target: target, state: state)
			return
		}

		let image = NSImage(contentsOf: imageURL)

		setImage(to: image, target: target, state: state)
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
	func setImage(toSVG svg: String?, target: Target? = nil, state: Int? = nil) {
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

	/// Temporarily show an alert icon on the image displayed by an instance of an action.
	/// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
	func showAlert() {
		StreamDeckPlugin.shared.sendEvent(.showAlert, context: context, payload: nil)
	}

	/// Temporarily show an OK checkmark icon on the image displayed by an instance of an action.
	/// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
	func showOk() {
		StreamDeckPlugin.shared.sendEvent(.showOK, context: context, payload: nil)
	}

	/// Change the state of the action's instance supporting multiple states.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
	func setState(to state: Int) {
		let payload: [String: Any] = ["state": state]

		StreamDeckPlugin.shared.sendEvent(.setState,
					  context: context,
					  payload: payload)
	}

	/// Send a payload to the Property Inspector.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - action: The action unique identifier.
	///   - payload: A json object that will be received by the Property Inspector.
	func sendToPropertyInspector(payload: [String: Any]) {
		StreamDeckPlugin.shared.sendEvent(.sendToPropertyInspector,
										  action: uuid,
										  context: context,
										  payload: payload)
	}
}
