//
//  Settings.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "Global Settings")

/// A struct that indicates an action has no settings. 
public struct NoSettings: Codable, Hashable { }

/// A key for accessing global settings.
public protocol GlobalSettingKey {

	associatedtype Value: Codable

	/// The default value for the setting. 
	static var defaultValue: Value { get }

}

public struct GlobalSettings {

	static var shared = GlobalSettings()

	// Object to send to SD App
	private var settings: [String: Any] = [:]

	public subscript<K: GlobalSettingKey>(key: K.Type) -> K.Value {
		get {
			log.debug("Getting value for \(key)")
			return settings[String(describing: key)] as? K.Value ?? key.defaultValue
		}
		set {
			log.log("Setting value for \(key) to \(String(describing: newValue))")
			settings[String(describing: key)] = newValue

			let updatedSettings = settings
			Task {
				try await StreamDeckPlugin.shared.sendEvent(.setGlobalSettings,
												  context: StreamDeckPlugin.shared.uuid,
												  payload: updatedSettings)

				log.log("Notifying action instances")
				for (_ , instance) in StreamDeckPlugin.shared.instances {
					instance.didReceiveGlobalSettings()
				}
			}

		}
	}

	mutating func updateSettings(fromEvent data: Data) {
		guard let newSettings = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
			return
		}

		log.log("Updated global settings from event")
		self.settings = newSettings
	}

}


@propertyWrapper
public struct GlobalSetting<Value: Codable> {

	var keyPath: WritableKeyPath<GlobalSettings, Value>

	public init(_ keyPath: WritableKeyPath<GlobalSettings, Value>) {
		self.keyPath = keyPath
	}

	@MainActor
	public var wrappedValue: Value {
		get {
			GlobalSettings.shared[keyPath: keyPath]
		}
		nonmutating set {
			GlobalSettings.shared[keyPath: keyPath] = newValue
		}
	}

}
