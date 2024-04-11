//
//  CounterPlugin.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation
import StreamDeck
import OSLog

fileprivate let log = Logger(subsystem: "Counter Plugin", category: "Main Plugin")

@main
class CounterPlugin: Plugin {

	// MARK: Manifest
	static var name: String = "Counter"

	static var description: String = "Count things. On your Stream Deck!"

	static var author: String = "Emory Dunn"

	static var icon: String = "Icons/pluginIcon"

	static var url: URL? = URL(string: "https://github.com/emorydunn/StreamDeckPlugin")

	static var version: String = "0.5"

	static var os: [PluginOS] = [.macOS(.v11)]

	@ActionBuilder
	static var actions: [any Action.Type] {
		IncrementAction.self
		DecrementAction.self
		RotaryAction.self
	}

	static var layouts: [Layout] {
		Layout(id: "counter") {
			// The title of the layout
			Text(title: "Current Count")
				.textAlignment(.center)
				.frame(width: 180, height: 24)
				.position(x: (200 - 180) / 2, y: 10)

			// A large counter label
			Text(key: "count-text", value: "0")
				.textAlignment(.center)
				.font(size: 16, weight: 600)
				.frame(width: 180, height: 24)
				.position(x: (200 - 180) / 2, y: 30)

			// A bar that shows the current count
			Bar(key: "count-bar", value: 0, range: -50..<50)
				.frame(width: 180, height: 20)
				.position(x: (200 - 180) / 2, y: 60)
				.barBackground(.black)
				.barStyle(.doubleTrapezoid)
				.barBorder("#943E93")
		}
	}

	@GlobalSetting(\.count) var count

	required init() {
		log.log("CounterPlugin init!")
	}

	func didReceiveDeepLink(_ url: URL) {
		if let newCount = Int(url.lastPathComponent) {
			log.log("Setting counter to \(newCount) from deep link")
			count = newCount
		} else {
			log.error("Could not convert deep link '\(url.lastPathComponent)' to integer")
		}
	}

}
