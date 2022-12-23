//
//  Hardware.swift
//  
//
//  Created by Emory Dunn on 10/25/21.
//

import Foundation

/// Where to display information.
public enum Target: Int, Encodable {
    case both = 0
    case hardwareOnly = 1
    case softwareOnly = 2
}

/// Information received about the Stream Deck device.
public struct DeviceInfo: Decodable {
    
    /// An opaque value identifying the device.
    public let id: String?
    
    /// The name of the device set by the user.
    public let name: String
    
    /// Type of device.
    public let type: DeviceType
    
    /// The number of columns and rows of keys that the device owns.
    public let size: Size
    
}

/// The available Stream Deck devices.
public enum DeviceType: Int, Codable, CustomStringConvertible {
    case streamDeck = 0
    case mini = 1
    case xl = 2
    case mobile = 3
    case corsairGKeys = 4
	case pedal = 5
	case corsairVoyager = 6
	case plus = 7

	public var description: String {
		switch self {
		case .streamDeck:
			return "Elgato StreamDeck"
		case .mini:
			return "Elgato StreamDeck Mini"
		case .xl:
			return "Elgato StreamDeck XL"
		case .mobile:
			return "Elgato StreamDeck Mobile"
		case .corsairGKeys:
			return "Corsair GKeys"
		case .pedal:
			return "Elgato StreamDeck Pedal"
		case .corsairVoyager:
			return "Corsair Voyager"
		case .plus:
			return "Elgato StreamDeck+"
		}
	}

}

/// The size of a device.
public struct Size: Decodable {
    
    /// Number of columns a device has.
    public let columns: Int
    
    /// Number of rows a device has.
    public let rows: Int
}

/// The available controller types.
public enum ControllerType: String, Codable, CustomStringConvertible {

	case keypad = "Keypad"
	case encoder = "Encoder"

	public var description: String {
		rawValue
	}
}

/// Rotary encoder configuration.
public struct RotaryEncoder: Codable {
	let stackColor: String
	let icon: String
	let layout: Layout
	let triggerDescription: TriggerDescription

	public init(stackColor: String, icon: String, layout: RotaryEncoder.Layout, triggerDescription: RotaryEncoder.TriggerDescription) {
		self.stackColor = stackColor
		self.icon = icon
		self.layout = layout
		self.triggerDescription = triggerDescription
	}

	public struct TriggerDescription: Codable {
		let rotate: String
		let push: String
		let touch: String
		let longTouch: String

		public init(rotate: String, push: String, touch: String, longTouch: String) {
			self.rotate = rotate
			self.push = push
			self.touch = touch
			self.longTouch = longTouch
		}
	}

	public enum Layout: String, Codable {
		case a = "$A1"
		case b = "$B1"
	}
}
