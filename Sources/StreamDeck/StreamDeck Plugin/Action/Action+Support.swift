//
//  Action+Support.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

public protocol KeyAction: Action { }

extension KeyAction {
	public static var controllers: [ControllerType] { [.keypad] }

	public static var encoder: RotaryEncoder? { nil }
}

public protocol StatelessKeyAction: Action { }

extension StatelessKeyAction {
	public static var controllers: [ControllerType] { [.keypad] }

	public static var encoder: RotaryEncoder? { nil }

	public static var states: [PluginActionState]? { nil }
}

public protocol EncoderAction: Action { }

extension EncoderAction {
	public static var controllers: [ControllerType] { [.encoder] }

	public static var states: [StreamDeck.PluginActionState]? { nil }
}

extension Action {
	
	// MARK: Defaults
	public static var userTitleEnabled: Bool? { nil }
	
	public static var propertyInspectorPath: String? { nil }
	
	public static var supportedInMultiActions: Bool? { nil }
	
	public static var tooltip: String? { nil }
	
	public static var visibleInActionsList: Bool? { nil }
	
	/// The Action's UUID.
	public var uuid: String {
		type(of: self).uuid
	}
	
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

        let str = String(decoding: data, as: UTF8.self)
        
		NSLog("Action \(#function)")
		keyDown(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a key up event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeKeyUp(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<KeyEvent<Settings>>.self, from: data)

		keyUp(device: action.device, payload: action.payload)
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
	
	/// Decode and deliver a dial rotation event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeDialPress(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<EncoderPressEvent<Settings>>.self, from: data)
		
		dialPress(device: action.device, payload: action.payload)
	}
	
	/// Decode and deliver a dial rotation event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeTouchTap(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<TouchTapEvent<Settings>>.self, from: data)
		
		touchTap(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a will dissapear  event.
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
        let action = try decoder.decode(SendToPluginEvent.self, from: data)
        sentToPlugin(payload: action.payload)
    }
}


