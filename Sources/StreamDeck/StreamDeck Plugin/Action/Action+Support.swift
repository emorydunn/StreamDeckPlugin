//
//  Action+Support.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

/// A convenience protocol that provides default values for an `Action`.
///
/// Use this protocol to create a standard button action that includes states.
///
/// - `controllers` is set to `[.keypad]`
/// - `encoder` is set to `nil`.
public protocol KeyAction: Action { }

extension KeyAction {
	public static var controllers: [ControllerType] { [.keypad] }

	public static var encoder: RotaryEncoder? { nil }
}

/// A convenience protocol that provides default values for an `Action`.
///
/// Use this protocol to create a standard button action that doesn't include any states.
///
/// - `states` is set to `nil`
/// - `controllers` is set to `[.keypad]`
/// - `encoder` is set to `nil`.
public protocol StatelessKeyAction: Action { }

extension StatelessKeyAction {
	public static var controllers: [ControllerType] { [.keypad] }

	public static var encoder: RotaryEncoder? { nil }

	public static var states: [PluginActionState]? { nil }
}

/// A convenience protocol that provides default values for an `Action`.
///
/// Use this protocol to create a dial action for the StreamDeck+.
///
/// - `states` is set to `nil`
/// - `controllers` is set to `[.encoder]`
public protocol EncoderAction: Action { }

extension EncoderAction {
	public static var controllers: [ControllerType] { [.encoder] }

	public static var states: [StreamDeck.PluginActionState]? { nil }
}

extension Action {
	
	// MARK: Defaults

	public static var sortName: String { name }

	public static var userTitleEnabled: Bool? { nil }
	
	public static var propertyInspectorPath: String? { nil }
	
	public static var supportedInMultiActions: Bool? { nil }
	
	public static var tooltip: String? { nil }
	
	public static var visibleInActionsList: Bool? { nil }

	public static var disableAutomaticStates: Bool? { nil }

	public var enableLongPress: Bool { true }

	/// The Action's UUID.
	public var uuid: String {
		type(of: self).uuid
	}
	
	public var longPressDuration: TimeInterval { 1 }
	
	// MARK: Events
	/// Decode and deliver a settings event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeSettings(_ data: Data, using decoder: JSONDecoder) throws {
		let settings = try decoder.decode(SettingsEvent<Settings>.self, from: data)

		didReceiveSettings(device: settings.device, payload: settings.payload)
	}
	
	/// Decode and deliver a key down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeKeyDown(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<KeyEvent<Settings>>.self, from: data)

		// If the action has opted out of long press behavior don't start the timer.
		if enableLongPress {
			// Begin a long-press timer
			TimerKeeper.shared.beginTimer(for: self, event: action)
		}

		keyDown(device: action.device, payload: action.payload)
	
	}

	/// Decode and deliver a key up event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeKeyUp(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<KeyEvent<Settings>>.self, from: data)

		// If the action has opted out of long press behavior just send the key up event.
		guard enableLongPress else {
			keyUp(device: action.device, payload: action.payload)
			return
		}

		// Cancel the long-press timer
		let longPress = TimerKeeper.shared.invalidateTimer(for: self)
		
		if !longPress {
			keyUp(device: action.device, payload: action.payload)
		}

		keyUp(device: action.device, payload: action.payload, longPress: longPress)
	}

	/// Decode and deliver a will appear event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeWillAppear(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<AppearEvent<Settings>>.self, from: data)
		
		willAppear(device: action.device, payload: action.payload)
	}
	
	/// Decode and deliver a dial rotation event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeDialRotate(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<EncoderEvent<Settings>>.self, from: data)
		
		dialRotate(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a dial press event.
	///
	/// - Important: Please note, from Stream Deck 6.5 onwards, `dialPress` will not be emitted by the API. Plugins should use `dialDown` and `dialUp` to receive events relating to dial presses.
	/// 
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeDialPress(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<EncoderPressEvent<Settings>>.self, from: data)
		
		dialPress(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a dial down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeDialDown(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<EncoderPressEvent<Settings>>.self, from: data)
		
		// Begin a long-press timer
		TimerKeeper.shared.beginTimer(for: self, event: action)

		dialDown(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a dial up event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeDialUp(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<EncoderPressEvent<Settings>>.self, from: data)
		
		// Cancel the long-press timer
		let longPress = TimerKeeper.shared.invalidateTimer(for: self)

		if !longPress {
			dialUp(device: action.device, payload: action.payload)
		}

		dialUp(device: action.device, payload: action.payload, longPress: longPress)
	}

	/// Decode and deliver a dial rotation event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeTouchTap(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<TouchTapEvent<Settings>>.self, from: data)
		
		touchTap(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a will disappear event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeWillDisappear(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<AppearEvent<Settings>>.self, from: data)

		willDisappear(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a title parameters did change event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeTitleParametersDidChange(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<TitleInfo<Settings>>.self, from: data)

		titleParametersDidChange(device: action.device, info: action.payload)
	}

	/// Decode and deliver a sent to plugin event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeSentToPlugin(_ data: Data, using decoder: JSONDecoder) throws {
		do {
			let action = try decoder.decode(SendToPluginSPDIEvent.self, from: data)
			sentToPlugin(payload: action.payload)
		} catch {
			let action = try decoder.decode(SendToPluginEvent.self, from: data)
			sentToPlugin(payload: action.payload)
		}
	}
}
