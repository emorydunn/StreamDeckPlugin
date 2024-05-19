//
//  SettingsWrapper.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

/// A struct that indicates an action has no settings. 
public struct NoSettings: Codable, Hashable { 

	public init() { } 

}

@propertyWrapper
/// A property wrapper that reads from and writes to the plugin's global settings.
///
/// The the `GlobalSetting` property wrapper to read and write global settings. 
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
