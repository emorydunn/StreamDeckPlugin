//
//  Action+Received.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

public extension Action {

	func didReceiveGlobalSettings() { } 
	
	/// Event received after calling the `getSettings` API to retrieve the persistent data stored for the action.
	func didReceiveSettings(device: String, payload: SettingsEvent<Settings>.Payload) { }
	
	/// When an instance of an action is displayed on the Stream Deck, for example when the hardware is first plugged in, or when a folder containing that action is entered, the plugin will receive a `willAppear` event.
	///
	/// You will see such an event when:
	/// - the Stream Deck application is started
	/// - the user switches between profiles
	/// - the user sets a key to use your action
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func willAppear(device: String, payload: AppearEvent<Settings>) { }
	
	/// When an instance of an action ceases to be displayed on Stream Deck, for example when switching profiles or folders, the plugin will receive a `willDisappear` event.
	///
	/// You will see such an event when:
	/// - the user switches between profiles
	/// - the user deletes an action
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func willDisappear(device: String, payload: AppearEvent<Settings>) { }
	
	/// When the user presses a key, the plugin will receive the `keyDown` event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func keyDown(device: String, payload: KeyEvent<Settings>) { }
	
	/// When the user releases a key, the plugin will receive the `keyUp` event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func keyUp(device: String, payload: KeyEvent<Settings>) { }
	
	func keyUp(device: String, payload: KeyEvent<Settings>, longPress: Bool) { }
	
	func longKeyPress(device: String, payload: KeyEvent<Settings>) { }
	
	func dialRotate(device: String, payload: EncoderEvent<Settings>) { }
	
	func dialPress(device: String, payload: EncoderPressEvent<Settings>) { }

	func dialDown(device: String, payload: EncoderPressEvent<Settings>) { }

	func dialUp(device: String, payload: EncoderPressEvent<Settings>) { }
	
	func dialUp(device: String, payload: EncoderPressEvent<Settings>, longPress: Bool) { }
	
	func longDialPress(device: String, payload: EncoderPressEvent<Settings>) { }

	func touchTap(device: String, payload: TouchTapEvent<Settings>) { }
	
	/// When the user changes the title or title parameters of the instance of an action, the plugin will receive a `titleParametersDidChange` event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func titleParametersDidChange(device: String, info: TitleInfo<Settings>) { }
	
	/// The plugin will receive a `propertyInspectorDidAppear` event when the Property Inspector appears.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	func propertyInspectorDidAppear(device: String) { }
	
	/// The plugin will receive a `propertyInspectorDidDisappear` event when the Property Inspector appears.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	func propertyInspectorDidDisappear(device: String) { }
	
	/// The plugin will receive a `sendToPlugin` event when the Property Inspector sends a `sendToPlugin` event.
	/// - Parameters:
	///   - payload: A json object that will be received by the plugin.
	func sentToPlugin(payload: [String: String]) { }
}
