//
//  EnvironmentKey.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

/// A key with an associated value type.
public protocol EnvironmentKey {
	associatedtype Value
	static var defaultValue: Value { get }
}

extension EnvironmentKey {
	/// Unique name for the key type
	static var dictKey: String {
		return String(reflecting: Self.self)
	}
}
