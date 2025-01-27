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

	static var encoder: RotaryEncoder? = RotaryEncoder(layout: .counter,
													   stackColor: "#f1184c",
													   icon: "Icons/stopwatch",
													   rotate: "Count",
													   push: "Reset")

	var context: String

	var coordinates: StreamDeck.Coordinates?

	static var userTitleEnabled: Bool? = false

	@GlobalSetting(\.count) var count: Int

	required init(context: String, coordinates: StreamDeck.Coordinates?) {
		self.context = context
		self.coordinates = coordinates
	}

	func willAppear(device: String, payload: AppearEvent<Settings>) {
		displayCounter()
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

	func didReceiveGlobalSettings() {
		displayCounter()
	}

	func displayCounter() {
		let bgColor: Color

		// Change the color of the bar based on the count
		if count >= 1 {
			bgColor = .red
		} else if count <= -1 {
			bgColor = .blue
		} else {
			bgColor = .white
		}

		let feedback = CounterSettings(countText: TextLayoutSettings(value: count.formatted()),
						countBar: BarLayoutSettings(bar_fill_c: bgColor))

		setFeedback(feedback)
	}

}
