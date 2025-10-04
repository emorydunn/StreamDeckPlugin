//
//  Action.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation
import AppKit

/// A single action that can be assigned to a Stream Deck key.
///
/// The action type is shown in the actions list and a new instance is initiated when the user adds an action to a key.
public protocol Action {
	
	/// Settings returned by the Stream Deck application.
	///
	/// If your action does not use settings, simply use `NoSettings`.
	associatedtype Settings: Codable & Hashable
	
	// MARK: - Action Properties
	
	/// The name of the action. This string is visible to the user in the actions list.
	static var name: String { get }
	
	/// A name used for sorting actions in the Stream Deck app.
	///
	/// By default this is `name`, but a custom value can be provided to sort
	/// and group actions together. 
	static var sortName: String { get }

	/// The unique identifier of the action.
	///
	/// It must be a uniform type identifier (UTI) that contains only lowercase alphanumeric characters (a-z, 0-9), hyphen (-), and period (.).
	///
	/// The string must be in reverse-DNS format.
	///
	/// For example, if your domain is elgato.com and you create a plugin named Hello with the action My Action, you could assign the string com.elgato.hello.myaction as your action's Unique Identifier.
	static var uuid: String { get }
	
	/// The relative path to a PNG image without the .png extension.
	///
	/// This image is displayed in the actions list. The PNG image should be a 20pt x 20pt image. You should provide @1x and @2x versions of the image.
	/// The Stream Deck application take care of loaded the appropriate version of the image.
	///
	/// - Note: This icon is not required for actions not visible in the actions list (`VisibleInActionsList` set to false).
	static var icon: String { get }
	
	/// Specifies an array of states.
	///
	/// Each action can have one state or 2 states (on/off).
	///
	/// For example the Hotkey action has a single state. However the Game Capture Record action has 2 states, active and inactive.
	///
	/// The state of an action, supporting multiple states, is always automatically toggled whenever the action's key is released (after being pressed).
	///
	/// In addition, it is possible to force the action to switch its state by sending a `setState` event.
	///
	/// - Note: If no states are specified the manifest will generate a single state using the `Action`'s icon. 
	static var states: [PluginActionState]? { get }
	
	
	/// Specifies an array of controllers.
	///
	/// Valid values include "Keypad" and "Encoder".
	///
	/// Include "Keypad" to have an action shown for standard StreamDeck keys.
	/// Include "Encoder" to have an action down for the StreamDeck+ dials. 
	static var controllers: [ControllerType] { get }
	
	/// An object containing encoder information.
	static var encoder: RotaryEncoder? { get }
	
	/// This can override PropertyInspectorPath member from the plugin if you wish to have different PropertyInspectorPath based on the action.
	///
	/// The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
	static var propertyInspectorPath: String? { get }
	
	/// Boolean to prevent the action from being used in a Multi Action.
	///
	/// True by default.
	static var supportedInMultiActions: Bool? { get }

	/// The string displayed as tooltip when the user leaves the mouse over your action in the actions list.
	static var tooltip: String? { get }
	
	/// Boolean to hide the action in the actions list.
	///
	/// This can be used for plugin that only works with a specific profile. True by default.
	static var visibleInActionsList: Bool? { get }
	
	/// Boolean to disable the title field for users in the property inspector. True by default.
	static var userTitleEnabled: Bool? { get }
	
	/// Determines whether the state of the action should automatically toggle when the user presses the action; only applies to actions that have two states defined.
	///
	/// Default is `false`.
	static var disableAutomaticStates: Bool? { get }

	// MARK: - Instance Properties
	
	/// The context value for the instance.
	var context: String { get }

	/// The duration a button needs to be held down in order to be considered a long press. 
	var longPressDuration: TimeInterval { get }

	/// Whether or not the action allows long presses.
	var enableLongPress: Bool { get }

	/// Create a new instance with the specified context and coordinates.
	init(context: String, coordinates: Coordinates?)

	// MARK: - Events
	func didReceiveGlobalSettings()
	
	/// Event received after calling the `getSettings` API to retrieve the persistent data stored for the action.
	func didReceiveSettings(device: String, payload: SettingsEvent<Settings>.Payload)
	
	/// When an instance of an action is displayed on the Stream Deck, for example when the hardware is first plugged in, or when a folder containing that action is entered, the plugin will receive a `willAppear` event.
	///
	/// You will see such an event when:
	/// - the Stream Deck application is started
	/// - the user switches between profiles
	/// - the user sets a key to use your action
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func willAppear(device: String, payload: AppearEvent<Settings>)
	
	/// When an instance of an action ceases to be displayed on Stream Deck, for example when switching profiles or folders, the plugin will receive a `willDisappear` event.
	///
	/// You will see such an event when:
	/// - the user switches between profiles
	/// - the user deletes an action
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func willDisappear(device: String, payload: AppearEvent<Settings>)
	
	/// When the user presses a key, the plugin will receive the `keyDown` event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func keyDown(device: String, payload: KeyEvent<Settings>)

	/// When the user releases a key, the plugin will receive the `keyUp` event.
	///
	/// This method is only called if the key was released quickly, that is, wasn't a long press. Use this method if your action implements specific
	/// for a long press versus a short press.
	///
	/// - Note: If your action needs to always be notified when a key was released  implement `keyUp(device:payload:longPress:)`.
	///
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func keyUp(device: String, payload: KeyEvent<Settings>)
	
	/// When the user releases a key, the plugin will receive the `keyUp` event.
	///
	/// This method is always called when the `keyUp` event is received. Use `longPress` to
	/// change the behavior of the event as needed if the key was held down.
	///
	/// - Note: If you only need to be notified when a key is released that isn't a long press use `keyUp(device:payload:)`.
	///
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	///   - longPress: Whether the key was held down before being released.
	func keyUp(device: String, payload: KeyEvent<Settings>, longPress: Bool)
	
	/// When the user holds a key down.
	///
	/// This isn't a Stream Deck event, instead this method is called internally by the plugin
	/// when the user holds a key down for a second.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func longKeyPress(device: String, payload: KeyEvent<Settings>)
	
	/// When the user rotates the encoder, the plugin will receive the dialRotate event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func dialRotate(device: String, payload: EncoderEvent<Settings>)

	/// When the user presses or releases the encoder, the plugin will receive the dialPress event.
	///
	/// - Important: Please note, from Stream Deck 6.5 onwards, `dialPress` will not be emitted by the API. Plugins should use `dialDown` and `dialUp` to receive events relating to dial presses.
	///
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func dialPress(device: String, payload: EncoderPressEvent<Settings>)
	
	/// When the user presses the encoder down, the plugin will receive the dialDown event (SD+).
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func dialDown(device: String, payload: EncoderPressEvent<Settings>)

	/// When the user releases a pressed encoder, the plugin will receive the dialUp event (SD+).
	///
	/// This method is only called if the dial was released quickly, that is, wasn't a long press. Use this method if your action implements specific
	/// for a long press versus a short press.
	///
	/// - Note: If your action needs to always be notified when a dial was released  implement `dialUp(device:payload:longPress:)`.
	///
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func dialUp(device: String, payload: EncoderPressEvent<Settings>)
	
	/// When the user releases a pressed encoder, the plugin will receive the dialUp event (SD+).
	///
	/// This method is always called when the `dialUp` event is received. Use `longPress` to
	/// change the behavior of the event as needed if the key was held down.
	///
	/// - Note: If you only need to be notified when a dial is released that isn't a long press use `dialUp(device:payload:)`.
	///
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func dialUp(device: String, payload: EncoderPressEvent<Settings>, longPress: Bool)
	
	/// When the user holds a dial down.
	///
	/// This isn't a Stream Deck event, instead this method is called internally by the plugin
	/// when the user holds a key down for a second.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func longDialPress(device: String, payload: EncoderPressEvent<Settings>)
	
	/// When the user touches the display, the plugin will receive the touchTap event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func touchTap(device: String, payload: TouchTapEvent<Settings>)
	
	/// When the user changes the title or title parameters of the instance of an action, the plugin will receive a `titleParametersDidChange` event.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	///   - payload: The event payload sent by the server.
	func titleParametersDidChange(device: String, info: TitleInfo<Settings>)
	
	/// The plugin will receive a `propertyInspectorDidAppear` event when the Property Inspector appears.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	func propertyInspectorDidAppear(device: String)
	
	/// The plugin will receive a `propertyInspectorDidDisappear` event when the Property Inspector appears.
	/// - Parameters:
	///   - device: An opaque value identifying the device.
	func propertyInspectorDidDisappear(device: String)
	
	/// The plugin will receive a `sendToPlugin` event when the Property Inspector sends a `sendToPlugin` event.
	/// - Parameters:
	///   - payload: A json object that will be received by the plugin.
	func sentToPlugin(payload: [String: String])

	/// The plugin will receive a `sendToPlugin` event when the Property Inspector sends a `sendToPlugin` event.
	///
	/// - Note: This method will be called if the payload includes an `event` key.
	/// - Parameters:
	///   - payload: A json object that will be received by the plugin.
	func sentToPlugin(payload: DataSourcePayload)
}
