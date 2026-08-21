//
//  SetValueAction.swift
//
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck
import OSLog

fileprivate let log = Logger(subsystem: "Counter Plugin", category: "Decrement")

class SetValueAction: KeyAction {
	struct Settings: Codable, Hashable {
		var newCount: Int?

		init(from decoder: any Decoder) throws {
			let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

			// The Property Inspector text field returns a string, so we need to handle the conversion
			let htmlValue = try container.decode(String.self, forKey: CodingKeys.newCount)
			self.newCount = Int(htmlValue)
		}
	}

	static var name: String = "Set Value"

	static var uuid: String = "com.example.counter.set-value"

	static var icon: String = "Icons/actionIcon"

	static var propertyInspectorPath: String? = "Inspectors/Counter.html"

	static var states: [PluginActionState]? = [
		PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
	]

	static var userTitleEnabled: Bool? = false

	let context: String

	@GlobalSetting(\.count) var count

	required init(context: String, coordinates: Coordinates?) {
		self.context = context
	}

	func willAppear(device: String, payload: AppearEvent<Settings>) {
		log.log("Action appeared, setting title to \(self.count)")
		setTitle(to: "\(count)", target: nil, state: nil)
	}

	func keyUp(device: String, payload: KeyEvent<Settings>, longPress: Bool) {
		guard let newCount = payload.settings.newCount else {
			showAlert()
			return
		}
		count = newCount
		log.log("Setting count to \(self.count)")
	}

	func didReceiveGlobalSettings() {
		log.log("Global settings changed, updating title with \(self.count)")
		setTitle(to: "\(count)", target: nil, state: nil)
	}
}
