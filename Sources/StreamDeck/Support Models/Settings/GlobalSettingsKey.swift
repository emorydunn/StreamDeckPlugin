//
//  GlobalSettingKey.swift
//  
//
//  Created by Emory Dunn on 8/2/23.
//

import Foundation

/// A key for accessing global settings.
public protocol GlobalSettingKey {

	associatedtype Value: Codable

	/// The default value for the setting.
	static var defaultValue: Value { get }

	/// The name of the key in the global settings JSON.
	///
	/// By default the name is the name of the conforming type. 
	static var name: String { get }

}

extension GlobalSettingKey {
	public static var name: String {
		String(describing: self)
	}
}
