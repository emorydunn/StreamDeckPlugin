//
//  PluginAction.swift
//  
//
//  Created by Emory Dunn on 12/18/23.
//

import Foundation

/// An action a plugin can provide for the user.
struct PluginAction: Codable {

	/// The name of the action. This string is visible to the user in the actions list.
	let name: String

	/// The unique identifier of the action.
	///
	/// It must be a uniform type identifier (UTI) that contains only lowercase alphanumeric characters (a-z, 0-9), hyphen (-), and period (.).
	///
	/// The string must be in reverse-DNS format.
	///
	/// For example, if your domain is elgato.com and you create a plugin named Hello with the action My Action, you could assign the string com.elgato.hello.myaction as your action's Unique Identifier.
	let uuid: String

	/// The relative path to a PNG image without the .png extension.
	///
	/// This image is displayed in the actions list. The PNG image should be a 20pt x 20pt image. You should provide @1x and @2x versions of the image.
	/// The Stream Deck application take care of loaded the appropriate version of the image.
	///
	/// - Note: This icon is not required for actions not visible in the actions list (`VisibleInActionsList` set to false).
	let icon: String

	/// Specifies an array of states.
	///
	/// Each action can have one state or 2 states (on/off).
	///
	/// For example the Hotkey action has a single state. However the Game Capture Record action has 2 states, active and inactive.
	///
	/// The state of an action, supporting multiple states, is always automatically toggled whenever the action's key is released (after being pressed).
	///
	/// In addition, it is possible to force the action to switch its state by sending a setState event.
	let states: [PluginActionState]

	let controllers: [ControllerType]

	let encoder: RotaryEncoder?

	/// This can override PropertyInspectorPath member from the plugin if you wish to have different PropertyInspectorPath based on the action.
	///
	/// The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
	let propertyInspectorPath: String?

	/// Boolean to prevent the action from being used in a Multi Action.
	///
	/// True by default.
	let supportedInMultiActions: Bool?

	/// The string displayed as tooltip when the user leaves the mouse over your action in the actions list.
	let tooltip: String?

	/// Boolean to hide the action in the actions list.
	///
	/// This can be used for plugin that only works with a specific profile. True by default.
	let visibleInActionsList: Bool?

	let userTitleEnabled: Bool?

	let disableAutomaticStates: Bool?

	/// Initialize a new action.
	init(name: String,
		 uuid: String,
		 icon: String,
		 states: [PluginActionState]? = nil,
		 controllers: [ControllerType] = [.keypad],
		 encoder: RotaryEncoder? = nil,
		 propertyInspectorPath: String? = nil,
		 supportedInMultiActions: Bool? = nil,
		 tooltip: String? = nil,
		 visibleInActionsList: Bool? = nil,
		 userTitleEnabled: Bool? = nil,
		 disableAutomaticStates: Bool? = nil) {

		precondition(CharacterSet(charactersIn: uuid).isSubset(of: .reverseDNS),
					 "The UUID must be a uniform type identifier that contains only lowercase alphanumeric characters (a-z, 0-9), hyphen (-), and period (.)")

		self.name = name
		self.uuid = uuid
		self.icon = icon
		self.propertyInspectorPath = propertyInspectorPath
		self.supportedInMultiActions = supportedInMultiActions
		self.tooltip = tooltip
		self.visibleInActionsList = visibleInActionsList
		self.userTitleEnabled = userTitleEnabled
		self.disableAutomaticStates = disableAutomaticStates

		if let states = states {
			self.states = states
		} else {
			self.states = [
				PluginActionState(image: icon)
			]
		}

		self.controllers = controllers
		self.encoder = encoder
	}

	init(action: any Action.Type) {
		precondition(CharacterSet(charactersIn: action.uuid).isSubset(of: .reverseDNS), 
					 "The UUID must be a uniform type identifier that contains only lowercase alphanumeric characters (a-z, 0-9), hyphen (-), and period (.)")

		self.name = action.name
		self.uuid = action.uuid
		self.icon = action.icon
		self.propertyInspectorPath = action.propertyInspectorPath
		self.supportedInMultiActions = action.supportedInMultiActions
		self.tooltip = action.tooltip
		self.visibleInActionsList = action.visibleInActionsList
		self.userTitleEnabled = action.userTitleEnabled
		self.disableAutomaticStates = action.disableAutomaticStates

		if let states = action.states {
			self.states = states
		} else {
			self.states = [
				PluginActionState(image: icon)
			]
		}

		self.controllers = action.controllers
		self.encoder = action.encoder

	}

}
