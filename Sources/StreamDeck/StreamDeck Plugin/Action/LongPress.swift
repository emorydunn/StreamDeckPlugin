//
//  TimerKeeper.swift
//  
//
//  Created by Emory Dunn on 5/29/24.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "TimerKeeper")

class TimerKeeper {
	
	static let shared = TimerKeeper()
	
	private var activeTimers: [String: Timer] = [:]
	
	private var lastState: [String: Bool] = [:]
	
	func beginTimer<A: Action>(for action: A, event:  ActionEvent<KeyEvent<A.Settings>>) {
		
		log.log("Beginning long press timer for \(action.context, privacy: .public)")
		
		// Begin the long-press timer
		let timer = Timer(timeInterval: 1, repeats: false) { _ in
			log.log("Long press timer has fired for \(action.context, privacy: .public)")
			self.lastState[action.context] = true
			action.longPress(device: event.device, payload: event.payload)
		}
		
		// Store the timer
		activeTimers[action.context] = timer
		
		// Reset the last state, assuming it fails
		lastState[action.context] = false
		
		// Add the timer to the main Run Loop
		RunLoop.main.add(timer, forMode: .default)
		
	}
	
	func invalidateTimer<A: Action>(for action: A) {
		log.log("Invalidating long press timer for \(action.context, privacy: .public)")
		activeTimers[action.context]?.invalidate()
	}
	
	func lastPress<A: Action>(_ action: A) -> Bool {
		lastState[action.context] ?? false
	}
}

extension EnvironmentValues {
	
}
