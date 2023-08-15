//
//  GlobalSettings.swift
//  
//
//  Created by Emory Dunn on 8/2/23.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "Global Settings")

/// Persistent global settings declared for the plugin.
///
/// When updating the value of a setting via the subscript a
/// `setGlobalSettings` event is sent to store the settings with
/// the Stream Deck app and instances are notified of the change. 
public struct GlobalSettings {

	/// Shared global instance of global settings. 
	static var shared = GlobalSettings()

	// Object to send to SD App
	private var settings: [String: Any] = [:]

	/// Access the global settings for the plugin with a custom key.
	public subscript<K: GlobalSettingKey>(key: K.Type) -> K.Value {
		get {
			log.debug("Getting value for \(key, privacy: .public)")
			return settings[key.name] as? K.Value ?? key.defaultValue
		}
		set {
			log.log("Setting value for \(key, privacy: .public) to \(String(describing: newValue), privacy: .public)")
			settings[key.name] = newValue

			let updatedSettings = settings
			Task {
				StreamDeckPlugin.shared.sendEvent(.setGlobalSettings,
															context: StreamDeckPlugin.shared.uuid,
															payload: updatedSettings)

				log.log("Notifying action instances")
				for (_ , instance) in StreamDeckPlugin.shared.instances {
					instance.didReceiveGlobalSettings()
				}
			}

		}
	}

	/// Update the settings from a `getGlobalSettings` event.
	///
	/// This method decodes the payload and settings from a event.
	/// - Parameter data: The full event data.
	mutating func updateSettings(fromEvent data: Data) {

		// Decode the event
		guard
			let event = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
			let payload = event["payload"] as? [String: Any],
			let newSettings = payload["settings"] as? [String: Any]
		else {
			return
		}

		self.settings = newSettings

		log.log("Notifying action instances")
		Task {
			for (_ , instance) in StreamDeckPlugin.shared.instances {
				instance.didReceiveGlobalSettings()
			}
		}
	}

}
