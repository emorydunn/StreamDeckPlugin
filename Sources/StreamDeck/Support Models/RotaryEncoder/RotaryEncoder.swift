//
//  RotaryEncoder.swift
//  
//
//  Created by Emory Dunn on 12/24/22.
//

import Foundation

/// The Encoder property is used to describe and configure the dial and display segment on StreamDeck+.
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
	let layout: LayoutName

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
	public init(layout: LayoutName,
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

	public init(layout: LayoutName,
				stackColor: String? = nil,
				icon: String? = nil,
				background: String? = nil,
				triggerDescription: TriggerDescription) {
		self.stackColor = stackColor
		self.icon = icon
		self.background = background
		self.layout = layout
		self.triggerDescription = triggerDescription
	}

	

}
