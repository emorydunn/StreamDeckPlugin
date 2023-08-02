//
//  File.swift
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

}
