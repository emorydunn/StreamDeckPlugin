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
	case scufController = 8
	case streamDeckNeo = 9

	public var description: String {
		switch self {
		case .streamDeck:
			"Elgato StreamDeck"
		case .mini:
			"Elgato StreamDeck Mini"
		case .xl:
			"Elgato StreamDeck XL"
		case .mobile:
			"Elgato StreamDeck Mobile"
		case .corsairGKeys:
			"Corsair GKeys"
		case .pedal:
			"Elgato StreamDeck Pedal"
		case .corsairVoyager:
			"Corsair Voyager"
		case .plus:
			"Elgato StreamDeck+"
		case .scufController:
			"SCUF Controller"
		case .streamDeckNeo:
			"Stream Deck Neo"
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
