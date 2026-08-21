//
//  ProfileAction.swift
//
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck
import OSLog

fileprivate let log = Logger(subsystem: "Counter Plugin", category: "Decrement")

class ProfileAction: KeyAction {
	typealias Settings = NoSettings

	static var name: String = "Change Profile"

	static var uuid: String = "com.example.counter.profile"

	static var icon: String = "Icons/actionIcon"

	static var states: [PluginActionState]? = [
		PluginActionState(image: "Icons/profile", titleAlignment: .middle)
	]

	let context: String

	required init(context: String, coordinates: Coordinates?) {
		self.context = context
	}

	func keyUp(device: String, payload: KeyEvent<Settings>, longPress: Bool) {
		switchToProfile(named: "Profiles/Counter Example")
	}
}
