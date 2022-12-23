//
//  Action+Support.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

extension Action {

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

		NSLog("Action \(#function)")
		didReceiveSettings(device: settings.device, payload: settings.payload)
	}

	/// Decode and deliver a key down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeKeyDown(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<KeyEvent<Settings>>.self, from: data)

		NSLog("Action \(#function)")
		keyDown(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a key down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeKeyUp(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<KeyEvent<Settings>>.self, from: data)

		NSLog("Action \(#function)")
		keyUp(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a key down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeWillAppear(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<AppearEvent<Settings>>.self, from: data)

		willAppear(device: action.device, payload: action.payload)

		NSLog("Action \(#function)")
//		return (action: action.action, context: action.context, coordinates: action.payload.coordinates)
	}

	/// Decode and deliver a key down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeWillDisappear(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<AppearEvent<Settings>>.self, from: data)

		NSLog("Action \(#function)")
		willDisappear(device: action.device, payload: action.payload)
	}

	/// Decode and deliver a key down event.
	/// - Parameters:
	///   - data: Event data
	///   - decoder: The decoder to use
	func decodeTitleParametersDidChange(_ data: Data, using decoder: JSONDecoder) throws {
		let action = try decoder.decode(ActionEvent<TitleInfo<Settings>>.self, from: data)

		NSLog("Action \(#function)")
		titleParametersDidChange(device: action.device, info: action.payload)
	}

}


