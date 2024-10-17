//
//  Action+Sent.swift
//
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation
import AppKit
import SDPlusLayout
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "Action")

public extension Action {

	// MARK: Sent

	/// Save data persistently for the action's instance.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - settings: A json object which is persistently saved for the action's instance.
	@available(*, deprecated, message: "Use the Settings API.")
	func setSettings(to settings: [String: Any]) {
		Task {
			await PluginCommunication.shared.sendEvent(.setSettings,
													   context: context,
													   payload: settings)
		}
	}

	/// Save data persistently for the action's instance.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - settings: A json object which is persistently saved for the action's instance.
	func setSettings(to settings: Settings) {
		Task {
			await PluginCommunication.shared.sendEvent(.setSettings,
													   context: context,
													   payload: settings)
		}
	}

	/// Request the persistent data for the action's instance.
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	func getSettings() {
		Task {
			await PluginCommunication.shared.sendEvent(.getSettings,
													   context: context,
													   payload: nil)
		}
	}

	/// Open an URL in the default browser.
	/// - Parameter url: The URL to open
	func openURL(_ url: URL) {
		Task {
			await PluginCommunication.shared.sendEvent(.openURL,
													   context: nil,
													   payload: ["url": url.path])
		}
	}

	/// Write a debug log to the logs file.
	/// - Parameter message: A string to write to the logs file.
	func logMessage(_ message: String) {
		log.log("\(message, privacy: .public)")
		Task {
			await PluginCommunication.shared.sendEvent(.logMessage, context: nil, payload: ["message": message])
		}
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
		Task {
			var payload: [String: Any] = [:]

			payload["title"] = title
			payload["target"] = target?.rawValue
			payload["state"] = state

			await PluginCommunication.shared.sendEvent(.setTitle,
													   context: context,
													   payload: payload)
		}
	}

	/// Dynamically change the image displayed by an instance of an action.
	///
	/// The image is automatically encoded to a prefixed base64 string.
	///
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - image: An image to display.
	///   - target: Specify if you want to display the title on hardware, software, or both.
	///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the image is set to all states.
	func setImage(to image: NSImage?, target: Target? = nil, state: Int? = nil) {
		Task {
			var payload: [String: Any] = [:]

			payload["image"] = image?.base64String
			payload["target"] = target?.rawValue
			payload["state"] = state


			await PluginCommunication.shared.sendEvent(.setImage,
													   context: context,
													   payload: payload)
		}
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
	///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the image is set to all states.
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
	///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the image is set to all states.
	func setImage(toSVG svg: String?, target: Target? = nil, state: Int? = nil) {
		Task {
			var payload: [String: Any] = [:]

			if let svg = svg {
				payload["image"] = "data:image/svg+xml;charset=utf8,\(svg)"
			}

			payload["target"] = target?.rawValue
			payload["state"] = state


			await PluginCommunication.shared.sendEvent(.setImage,
													   context: context,
													   payload: payload)
		}
	}

	/// Temporarily show an alert icon on the image displayed by an instance of an action.
	/// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
	func showAlert() {
		Task {
			await PluginCommunication.shared.sendEvent(.showAlert, context: context, payload: nil)
		}
	}

	/// Temporarily show an OK checkmark icon on the image displayed by an instance of an action.
	/// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
	func showOk() {
		Task {
			await PluginCommunication.shared.sendEvent(.showOK, context: context, payload: nil)
		}
	}

	/// Change the state of the action's instance supporting multiple states.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - state: A 0-based integer value representing the state of an action with multiple states.
	func setState(to state: Int) {
		let payload: [String: Any] = ["state": state]

		Task {
			await PluginCommunication.shared.sendEvent(.setState,
													   context: context,
													   payload: payload)
		}
	}

	/// Send a payload to the Property Inspector.
	/// - Parameters:
	///   - context: An opaque value identifying the instance's action or Property Inspector.
	///   - action: The action unique identifier.
	///   - payload: A json object that will be received by the Property Inspector.
	func sendToPropertyInspector(payload: [String: Any]) {
		Task {
			await PluginCommunication.shared.sendEvent(.sendToPropertyInspector,
													   action: uuid,
													   context: context,
													   payload: payload)
		}
	}


	/// The plugin can send a `setFeedback` event to the Stream Deck application to dynamically change properties of items on the Stream Deck + touch display layout.
	func setFeedback(_ payload: [String: Any]) {
		Task {
			await PluginCommunication.shared.sendEvent(.setFeedback,
													   context: context,
													   payload: payload)
		}
	}

	/// The plugin can send a `setFeedbackLayout` event to the Stream Deck application to dynamically change the current Stream Deck + touch display layout.
	///
	/// `setFeedbackLayout` can use the `id` of a built-in layout or a relative path to a custom layout JSON file.
	/// - Parameter layout: The layout to set.
	func setFeedbackLayout(_ layout: LayoutName) {
		let payload: [String: Any] = ["layout": layout.id]

		Task {
			await PluginCommunication.shared.sendEvent(.setFeedbackLayout,
													   context: context,
													   payload: payload)
		}
	}

	/// Sets the trigger descriptions associated with an encoder (touch display + dial) action instance.
	///
	/// All descriptions are optional; when one or more descriptions are defined all descriptions are updated,
	/// with `undefined` values having their description hidden in Stream Deck.
	///
	/// To reset the descriptions to the default values defined within the manifest, an empty payload can be sent as part of the event.
	/// - Parameter triggerDescription: The new `TriggerDescription` or `nil` to reset.
	func setTriggerDescription(_ triggerDescription: TriggerDescription?) {
		Task {
			await PluginCommunication.shared.sendEvent(.setTriggerDescription,
													   context: context,
													   payload: triggerDescription)
		}
	}
}
