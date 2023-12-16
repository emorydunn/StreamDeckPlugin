//
//  State.swift
//
//
//  Created by Emory Dunn on 12/15/23.
//

import Foundation

@propertyWrapper
/// A property wrapper type that can read and write a value managed by a StreamDeck action.
///
/// Use `state` as the source of truth for an action-specific value.
/// The value is neither persisted nor shared across instances of the same action. 
public final class State<Value> {

	var value: Value

	public init(wrappedValue value: Value) {
		self.value = value
	}

	public var wrappedValue: Value {
		get {
			value
		}
		set {
			value = newValue
		}
	}
}
