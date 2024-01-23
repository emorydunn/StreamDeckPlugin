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

	@GlobalSetting(\.count) var count: Int

	var valueLayout = true

	required init(context: String, coordinates: StreamDeck.Coordinates?) {
		self.context = context
		self.coordinates = coordinates
	}

	func willAppear(device: String, payload: AppearEvent<Settings>) {

		setFeedback([
			"title" : "Current Count",
			"value" : "\(count)"
		])

	}

	func dialRotate(device: String, payload: EncoderEvent<Settings>) {
		count += payload.ticks

		displayCounter()
	}

	func dialDown(device: String, payload: EncoderPressEvent<NoSettings>) {
		count = 0

		logMessage("Resetting counter")
		displayCounter()
	}

	func touchTap(device: String, payload: TouchTapEvent<Settings>) {
		NSLog("Touch Tap: \(payload.hold)")

		if valueLayout {
			setFeedbackLayout(.icon)
		} else {
			setFeedbackLayout(.value)
			displayCounter()
		}

		valueLayout.toggle()

	}

	func didReceiveGlobalSettings() {
		displayCounter()
	}

	func displayCounter() {
		setFeedback(["value" : "\(count)"])
	}

}
