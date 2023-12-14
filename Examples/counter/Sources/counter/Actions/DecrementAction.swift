//
//  DecrementAction.swift
//
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck
import OSLog

fileprivate let log = Logger(subsystem: "Counter Plugin", category: "Decrement")

class DecrementAction: KeyAction {

	typealias Settings = NoSettings

	static var name: String = "Decrement"

	static var uuid: String = "counter.decrement"

	static var icon: String = "Icons/actionIcon"

	static var states: [PluginActionState]? = [
		PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
	]

	var context: String

	var coordinates: StreamDeck.Coordinates?

	@GlobalSetting(\.count) var count

	required init(context: String, coordinates: StreamDeck.Coordinates?) {
		self.context = context
		self.coordinates = coordinates
	}

	func willAppear(device: String, payload: AppearEvent<Settings>) {
		log.log("Action appeared, setting title to \(self.count)")
		setTitle(to: "\(count)", target: nil, state: nil)
	}

	func keyDown(device: String, payload: KeyEvent<Settings>) {
		count -= 1
		log.log("Decrementing count to \(self.count)")
	}

	func didReceiveGlobalSettings() {
		log.log("Global settings changed, updating title with \(self.count)")
		setTitle(to: "\(count)", target: nil, state: nil)
	}

}
