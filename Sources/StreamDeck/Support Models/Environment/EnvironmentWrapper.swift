//
//  Environment.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

/// Keys marked as exported are expected to be set by an action before it finishes.
///
/// - Note: Environmental values are not persistent. 
@propertyWrapper
public struct Environment<Value> {

	var keyPath: WritableKeyPath<EnvironmentValues, Value>

	public init(_ keyPath: WritableKeyPath<EnvironmentValues, Value>) {
		self.keyPath = keyPath
	}
	
	@MainActor
	public var wrappedValue: Value {
		get {
			EnvironmentValues.shared[keyPath: keyPath]
		}
		nonmutating set {
			EnvironmentValues.shared[keyPath: keyPath] = newValue
		}
	}
}
