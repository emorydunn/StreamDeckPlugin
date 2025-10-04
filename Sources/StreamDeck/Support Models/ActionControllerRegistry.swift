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
	var actions: [String: ActionInfo] = [:]

	/// A dictionary of devices and their actions
	var devices: [String: [ActionInfo]] {
		let infos: [ActionInfo] = Array(actions.values)
		return Dictionary(grouping: infos) { $0.device }
	}

	func store(event: ActionEvent<InstanceAppearEvent>) {
		actions[event.context] = ActionInfo(event)
	}

	func remove(_ actionContext: String) {
		actions[actionContext] = nil
	}

	subscript <A: Action>(_ action: A) -> ActionInfo? {
		actions[action.context]
	}

}

/// Information about where the action is displayed.
struct ActionInfo {
	let context: String
	let device: String
	let controllerType: ControllerType
	let coordinates: Coordinates?

	init(_ event: ActionEvent<InstanceAppearEvent>) {
		self.context = event.context
		self.device = event.device
		self.controllerType = event.payload.controller
		self.coordinates = event.payload.coordinates
	}
}

extension Action {
	/// The type of controller the action instance was instantiated on.
	public var controllerType: ControllerType {
		ActionControllerRegistry.shared[self]!.controllerType
	}

	/// The type of controller the action instance was instantiated on.
	public var coordinates: Coordinates? {
		ActionControllerRegistry.shared[self]!.coordinates
	}

	/// The type of controller the action instance was instantiated on.
	public var device: String {
		ActionControllerRegistry.shared[self]!.device
	}
}
