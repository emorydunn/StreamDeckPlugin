//
//  RotaryEncoder.swift
//  
//
//  Created by Emory Dunn on 12/24/22.
//

import Foundation

/// The Encoder property is used to describe and configure the dial and display segment on Stream Deck +.
public struct RotaryEncoder: Codable {

	/// The color that will be used in the dial stack as background color.
	let stackColor: String?

	/// The default icon found in the property inspector, dial stack image, and the layout. If no icon is set Stream Deck will use the action list icon.
	let icon: String?

	/// The default background image for the encoders touch display slot.
	let background: String?

	/// A string containing the name of a built-in layout or the partial path to a JSON file with a custom layout definition.
	///
	/// You can dynamically change the layout with with setFeedbackLayout event.
	///
	/// - Note: The default layout is the Icon Layout (`$X1`)
	let layout: Layout

	/// An object containing strings to describe actions in the property inspector.
	let triggerDescription: TriggerDescription

	/// Initiate an encoder layout.
	/// - Parameters:
	///   - layout: The layout for the screen above the encoder.
	///   - stackColor: A color of some sort
	///   - icon: The icon on screen.
	///   - rotate: The action description for rotating the dial.
	///   - push: The action description for pressing the dial.
	///   - touch: The action description for tapping the touch screen.
	///   - longTouch: The action description for long pressing on the touch screen.
	public init(layout: RotaryEncoder.Layout,
				stackColor: String? = nil,
				icon: String? = nil,
				background: String? = nil,
				rotate: String? = nil,
				push: String? = nil,
				touch: String? = nil,
				longTouch: String? = nil) {

		self.stackColor = stackColor
		self.icon = icon
		self.background = background
		self.layout = layout
		self.triggerDescription = TriggerDescription(rotate: rotate, push: push, touch: touch, longTouch: longTouch)
	}

	public init(layout: RotaryEncoder.Layout,
				stackColor: String? = nil,
				icon: String? = nil,
				background: String? = nil,
				triggerDescription: RotaryEncoder.TriggerDescription) {
		self.stackColor = stackColor
		self.icon = icon
		self.background = background
		self.layout = layout
		self.triggerDescription = triggerDescription
	}

	public struct TriggerDescription: Codable {
		let rotate: String?
		let push: String?
		let touch: String?
		let longTouch: String?

		public init(rotate: String? = nil, push: String? = nil, touch: String? = nil, longTouch: String? = nil) {
			self.rotate = rotate
			self.push = push
			self.touch = touch
			self.longTouch = longTouch
		}
	}

	/// [Layouts](https://developer.elgato.com/documentation/stream-deck/sdk/layouts) describe how information is shown on the Stream Deck + touch display.
	///
	/// There are built-in pre-defined layouts or create a custom layout JSON file. The layout name or path to the custom layout json file is defined in the manifest.
	///
	/// The layout can also be dynamically changed using the `setFeedbackLayout` event.
	public struct Layout: Codable, ExpressibleByStringLiteral {

		public var layoutName: String

		public init(_ layoutName: String) {
			self.layoutName = layoutName
		}

		public init(stringLiteral value: String) {
			self.layoutName = value
		}

		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()

			self.layoutName = try container.decode(String.self)
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.singleValueContainer()

			try container.encode(layoutName)
		}

		/// The default layout.
		public static let icon: Layout = "$X1"

		/// The layout best suited for custom images with a title.
		public static let canvas: Layout = "$A0"

		/// The layout best suited for representing a single value.
		public static let value: Layout = "$A1"

		/// The layout best suited for representing a single value range.
		public static let indicator: Layout = "$B1"

		/// The layout best suited for representing a single value range, where the data can be further explained using color.
		public static let gradient: Layout = "$B2"

		/// The layout best suited for representing two value ranges.
		public static let doubleIndicator: Layout = "$C1"
	}
}
