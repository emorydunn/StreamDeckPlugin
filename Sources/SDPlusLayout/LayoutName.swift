//
//  LayoutName.swift
//  
//
//  Created by Emory Dunn on 12/25/22.
//

import Foundation

/// [Layouts](https://developer.elgato.com/documentation/stream-deck/sdk/layouts) describe how information is shown on the Stream Deck + touch display.
///
/// There are built-in pre-defined layouts or create a custom layout JSON file. The layout name or path to the custom layout json file is defined in the manifest.
///
/// The layout can also be dynamically changed using the `setFeedbackLayout` event.
public struct LayoutName: Codable, ExpressibleByStringLiteral, Identifiable, Hashable, CustomStringConvertible {

	public var id: String

	let builtIn: Bool

	public var description: String {
		id
	}

	public var path: String {
		if builtIn {
			id
		} else {
			"Layouts/\(id).json"
		}
	}

	public init(_ layoutName: String) {
		self.id = layoutName
		self.builtIn = false
	}

	private init(builtIn layoutName: String) {
		self.id = layoutName
		self.builtIn = true
	}

	public init(stringLiteral value: String) {
		self.id = value
		self.builtIn = false
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		self.id = try container.decode(String.self)
		self.builtIn = false
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		try container.encode(path)
	}
	
	/// The default layout.
	public static let icon = LayoutName(builtIn: "$X1")

	/// The layout best suited for custom images with a title.
	public static let canvas = LayoutName(builtIn: "$A0")

	/// The layout best suited for representing a single value.
	public static let value = LayoutName(builtIn: "$A1")

	/// The layout best suited for representing a single value range.
	public static let indicator = LayoutName(builtIn: "$B1")

	/// The layout best suited for representing a single value range, where the data can be further explained using color.
	public static let gradient = LayoutName(builtIn: "$B2")

	/// The layout best suited for representing two value ranges.
	public static let doubleIndicator = LayoutName(builtIn: "$C1")

}
