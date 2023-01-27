//
//  ReceivableEvent.swift
//  
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation

// MARK: Sent

/// Keys for sent events.
public enum SendableEventKey: String, Codable {
	case setSettings
	case getSettings
	case setGlobalSettings
	case getGlobalSettings
	case openURL = "openUrl"
	case logMessage
	case setTitle
	case setImage
	case showAlert
	case showOK = "showOk"
	case setState
	case switchToProfile
	case sendToPropertyInspector
	case setFeedback
	case setFeedbackLayout
}

/// A event that is sent to the Stream Deck software. 
struct SendableEvent<P: Encodable>: Encodable {
	let event: SendableEventKey
	let action: String?
	let context: String?
	let payload: P?
}

// MARK: - Received

/// The root object to decode a received event.
public struct ReceivableEvent: Decodable {
	let event: EventKey
	let context: String?
}

//public struct TopLevelEvent: Decodable {
//	let event: ReceivableEvent.EventKey
//	let context: String?
//}

/// Keys for received events.
extension ReceivableEvent {
	public enum EventKey: String, Codable {
		case didReceiveSettings
		case didReceiveGlobalSettings
		case keyDown
		case keyUp
		case dialRotate
		case dialPress
		case touchTap
		case willAppear
		case willDisappear
		case titleParametersDidChange
		case deviceDidConnect
		case deviceDidDisconnect
		case applicationDidLaunch
		case applicationDidTerminate
		case systemDidWakeUp
		case propertyInspectorDidAppear
		case propertyInspectorDidDisappear
		case sendToPlugin
	}
}



/// Events sent by the server in response to actions.
public struct ActionEvent<Payload: Decodable>: Decodable {
	
	/// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
	public let action: String
	
	/// An opaque value identifying the instance's action.
	public let context: String
	
	/// An opaque value identifying the device.
	public let device: String
	
	/// The payload of the event.
	public let payload: Payload
}

/// Events sent by the server that do not have an associated action instance.
public struct Event<Payload: Decodable>: Decodable {
	
	/// An opaque value identifying the device.
	public let device: String
	
	/// The payload of the event.
	public let payload: Payload
}

/// Device connection events sent by the server. 
public struct DeviceConnectionEvent: Decodable {
	
	/// An opaque value identifying the device.
	public let device: String
	
	/// The payload of the event.
	public let deviceInfo: DeviceInfo?
}


// MARK: Settings Events

/// Action instance settings received after calling `getSettings()`.
public struct SettingsEvent<S: Decodable>: Decodable {
	/// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
	public let action: String
	
	/// An opaque value identifying the instance's action.
	public let context: String
	
	/// An opaque value identifying the device.
	public let device: String
	
	/// The payload of the event.
	public let payload: Payload
	
	/// Container for the settings data.
	public struct Payload: Decodable, Locatable {
		/// This json object contains data that you can set and are stored persistently.
		public let settings: S
		
		/// The coordinates of the action triggered.
		public let coordinates: Coordinates?
		
		/// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
		///
		/// The 0-based value contains the current state of the action.
		public let state: Int?
		
		/// Boolean indicating if the action is inside a Multi Action.
		public let isInMultiAction: Bool
	}
}

/// Global settings received after calling `getGlobalSettings()`.
public struct GlobalSettingsEvent<S: Decodable>: Decodable {
	/// The payload of the event.
	public let payload: Payload
	
	/// Container for the settings data.
	public struct Payload: Decodable {
		/// This json object contains data that you can set and are stored persistently.
		public let settings: S
	}
}

// MARK: Appear Events

/// Information received about a `willAppear` or `willDisappear` event.
public struct InstanceAppearEvent: Decodable, Hashable, Locatable {
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
}

/// Information received about a `willAppear` or `willDisappear` event.
public struct AppearEvent<S: Decodable & Hashable>: Decodable, Hashable, Locatable {
	
	/// This json object contains data that you can set and are stored persistently.
	public let settings: S
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
	/// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
	///
	/// The 0-based value contains the current state of the action.
	public let state: Int?
	
	/// Boolean indicating if the action is inside a Multi Action.
	public let isInMultiAction: Bool
	
	/// Holds the name of the controller of the current action.
	public let controller: ControllerType
	
}

// MARK: Controller Events
/// Information received about a `keyUp` or `keyDown` event.
public struct KeyEvent<S: Decodable & Hashable>: Decodable, Hashable, Locatable {
	
	/// This json object contains data that you can set and are stored persistently.
	public let settings: S
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
	/// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
	///
	/// The 0-based value contains the current state of the action.
	public let state: Int?
	
	/// This is a parameter that is only set when the action is triggered with a specific value from a Multi Action.
	///
	/// For example if the user sets the Game Capture Record action to be disabled in a Multi Action, you would see the value 1.
	///
	/// - Important: Only the value 0 and 1 are valid.
	public let userDesiredState: Int?
	
	/// Boolean indicating if the action is inside a Multi Action.
	public let isInMultiAction: Bool
	
}

/// Information received about a rotary encoder event.
public struct EncoderEvent<S: Decodable & Hashable>: Decodable, Hashable, Locatable {
	
	/// This json object contains data that you can set and are stored persistently.
	public let settings: S
	
	public let controller: ControllerType
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
	/// Boolean which is `true` on rotation when encoder pressed.
	public let pressed: Bool
	
	/// The integer which holds the number of "ticks" on encoder rotation.
	///
	/// Positive values are for clockwise rotation, negative values are for counterclockwise rotation, zero value is never happen.
	public let ticks: Int
}

/// Information received about a rotary encoder event.
public struct EncoderPressEvent<S: Decodable & Hashable>: Decodable, Hashable, Locatable {
	
	/// This json object contains data that you can set and are stored persistently.
	public let settings: S
	
	public let controller: ControllerType
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
	/// Boolean which is `true` on encoder pressed, else `false` on released
	public let pressed: Bool
}

/// Information received about a `keyUp` or `keyDown` event.
public struct TouchTapEvent<S: Decodable & Hashable>: Decodable, Hashable, Locatable {
	
	/// This json object contains data that you can set and are stored persistently.
	public let settings: S
	
	public let controller: ControllerType
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
	/// Boolean which is `true` when long tap happened
	public let hold: Bool
	
	/// The array which holds (x, y) coordinates as a position of tap inside of LCD slot associated with action.
	public let tapPos: [Int]
	
}



public struct SendToPluginEvent: Decodable {
	/// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
	public let action: String
	
	/// An opaque value identifying the instance's action.
	public let context: String
	
	/// The payload sent from the Property Inspector.
	public let payload: [String: String]
}

// MARK: Application Events

/// Basic type for application events.
/// - `applicationDidLaunch`
/// - `applicationDidTerminate`
public struct ApplicationEvent: Decodable {
	/// The event's payload.
	public let payload: App
	
	/// An application event payload.
	public struct App: Decodable {
		
		/// The bundle identifier of the application.
		public let application: String
	}
}

// MARK: Property Inspector Events

/// The basic type for decoding property inspector events.
/// - `propertyInspectorDidAppear`
/// - `propertyInspectorDidDisappear`
/// - `sendToPlugin`
/// - `sendToPropertyInspector`
public struct PropertyInspectorEvent: Decodable {
	
	/// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
	public let action: String
	
	/// An opaque value identifying the instance's action.
	public let context: String
	
	/// An opaque value identifying the device.
	public let device: String
}
