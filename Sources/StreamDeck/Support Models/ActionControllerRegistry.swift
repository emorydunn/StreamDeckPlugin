//
//  ActionControllerRegistry.swift
//  
//
//  Created by Emory Dunn on 6/5/24.
//

import Foundation

class ActionControllerRegistry {

	static let shared = ActionControllerRegistry()
	
	/// A dictionary of actions and their controller type.
	var actions: [String: ControllerType] = [:]

	/// A dictionary of devices and their actions
	var devices: [String: [String]] = [:]

	func store(_ actionContext: String, controller: ControllerType, device: String) {
		actions[actionContext] = controller
		devices[device, default: []].append(actionContext)
	}

	func remove(_ actionContext: String) {
		actions[actionContext] = nil
		devices[actionContext] = nil
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
