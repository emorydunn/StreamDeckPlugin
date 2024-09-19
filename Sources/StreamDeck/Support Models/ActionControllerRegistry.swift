//
//  ActionControllerRegistry.swift
//  
//
//  Created by Emory Dunn on 6/5/24.
//

import Foundation

class ActionControllerRegistry {

	static let shared = ActionControllerRegistry()

	var actions: [String: ControllerType] = [:]

	func store(_ actionContext: String, controller: ControllerType) {
		actions[actionContext] = controller
	}

	func remove(_ actionContext: String) {
		actions[actionContext] = nil
	}

	subscript <A: Action>(_ action: A) -> ControllerType? {
		get {
			actions[action.context]
		}

		set {
			actions[action.context] = newValue
		}
	}
}

extension Action {
	/// The type of controller the action instance was instantiated on.
	public var controllerType: ControllerType {
		ActionControllerRegistry.shared[self]!
	}
}
