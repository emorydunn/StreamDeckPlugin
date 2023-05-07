//
//  RotaryAction.swift
//  
//
//  Created by Emory Dunn on 12/23/22.
//

import Foundation
import StreamDeck

class RotaryAction: EncoderAction {

	typealias Settings = NoSettings

	static var name: String = "Count"

	static var uuid: String = "counter.rotary"

	static var icon: String = "Icons/actionIcon"

	static var encoder: RotaryEncoder? = RotaryEncoder(layout: .value,
													   stackColor: "#f1184c",
													   icon: "Icons/stopwatch",
													   rotate: "Count",
													   push: "Reset")

	var context: String

	var coordinates: StreamDeck.Coordinates?

	static var userTitleEnabled: Bool? = false

	@Environment(PluginCount.self) var count: Int

	var valueLayout = true

	required init(context: String, coordinates: StreamDeck.Coordinates?) {
		self.context = context
		self.coordinates = coordinates
	}

	func willAppear(device: String, payload: AppearEvent<NoSettings>) {

		setFeedback([
			"title" : "Current Count",
			"value" : "\(count)"
		])

	}

	func dialRotate(device: String, payload: EncoderEvent<Settings>) {
		count += payload.ticks

		StreamDeckPlugin.shared.instances.values.forEach {
			$0.setTitle(to: "\(count)", target: nil, state: nil)
		}

		setFeedback(["value" : "\(count)"])
	}

	func dialPress(device: String, payload: EncoderPressEvent<NoSettings>) {
		guard payload.pressed else { return }

		count = 0

		StreamDeckPlugin.shared.instances.values.forEach {
			$0.setTitle(to: "\(count)", target: nil, state: nil)
		}

		logMessage("Resetting counter")
		setFeedback(["value" : "\(count)"])
	}

	func touchTap(device: String, payload: TouchTapEvent<NoSettings>) {
		NSLog("Touch Tap: \(payload.hold)")

		if valueLayout {
			setFeedbackLayout(.icon)
		} else {
			setFeedbackLayout(.value)
		}

		valueLayout.toggle()

	}

}
