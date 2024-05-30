//
//  IncrementAction.swift
//  
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck
import OSLog

fileprivate let log = Logger(subsystem: "Counter Plugin", category: "Increment")

class IncrementAction: KeyAction {

	typealias Settings = NoSettings

	static var name: String = "Increment"

	static var uuid: String = "counter.increment"

	static var icon: String = "Icons/actionIcon"

	static var states: [PluginActionState]? = [
		PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
	]

	static var userTitleEnabled: Bool? = false

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

	func keyUp(device: String, payload: KeyEvent<Settings>, longPress: Bool) {
		if longPress { return }
		
		count += 1
		log.log("Incrementing count to \(self.count)")
	}
	
	func longPress(device: String, payload: KeyEvent<NoSettings>) {
		count = 0
		showOk()
		log.log("Resetting count to \(self.count)")
	}

	func didReceiveGlobalSettings() {
		log.log("Global settings changed, updating title with \(self.count)")
		setTitle(to: "\(count)", target: nil, state: nil)
	}

}
