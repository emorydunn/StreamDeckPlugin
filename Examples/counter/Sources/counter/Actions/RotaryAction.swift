//
//  RotaryAction.swift
//  
//
//  Created by Emory Dunn on 12/23/22.
//

import Foundation
import StreamDeck

class RotaryAction: Action {

	typealias Settings = NoSettings

	static var name: String = "Count"

	static var uuid: String = "counter.rotary"

	static var icon: String = "Icons/actionIcon"

	static var states: [PluginActionState]? = [
		PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
	]

	static var controllers: [ControllerType] = [.encoder]

	static var encoder: RotaryEncoder? = StreamDeck.RotaryEncoder(stackColor: "#f1184c",
																  icon: "Icons/actionIcon",
																  layout: .b,
																  triggerDescription: RotaryEncoder.TriggerDescription(rotate: "Count",
																													   push: "Reset",
																													   touch: "Unused",
																													   longTouch: "Unused"))

	static var propertyInspectorPath: String?

	static var supportedInMultiActions: Bool?

	static var tooltip: String?

	static var visibleInActionsList: Bool?

	var context: String

	var coordinates: StreamDeck.Coordinates?

	@Environment(PluginCount.self) var count: Int

	required init(context: String, coordinates: StreamDeck.Coordinates?) {
		self.context = context
		self.coordinates = coordinates
	}

	func dialRotate(device: String, payload: EncoderEvent<Settings>) {
		count += payload.ticks

		StreamDeckPlugin.shared.instances.values.forEach {
			$0.setTitle(to: "\(count)", target: nil, state: nil)
		}
	}

	func dialPress(device: String, payload: EncoderPressEvent<NoSettings>) {
		guard payload.pressed else { return }

		count = 0

		StreamDeckPlugin.shared.instances.values.forEach {
			$0.setTitle(to: "\(count)", target: nil, state: nil)
		}
	}

	func touchTap(device: String, payload: TouchTapEvent<NoSettings>) {
		NSLog("Touch Tap: \(payload.hold)")
	}

}
