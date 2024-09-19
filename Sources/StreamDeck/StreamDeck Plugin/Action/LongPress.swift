//
//  TimerKeeper.swift
//  
//
//  Created by Emory Dunn on 5/29/24.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "TimerKeeper")

/// A class that stores long press timers for actions.
class TimerKeeper {
	
	/// The shared `TimerKeeper` instance.
	static let shared = TimerKeeper()
	
	/// Times that have been set for a specific action instance.
	private var activeTimers: [String: Timer] = [:]
	
	/// The last state of an instance.
	private var lastState: [String: Bool] = [:]
	
	/// Store a timer for an action instance.
	///
	/// This method stores the `Timer`, resets the last state to `false`, and then adds the timer to the main `RunLoop`.
	/// - Parameters:
	///   - timer: The `Timer` to store.
	///   - action: The action instance the `Timer` belongs to.
	private func storeTimer<A: Action>(_ timer: Timer, for action: A) {
		// Store the timer
		activeTimers[action.context] = timer
		
		// Reset the last state, assuming it fails
		lastState[action.context] = false
		
		// Add the timer to the main Run Loop
		RunLoop.main.add(timer, forMode: .default)
	}
	
	/// Begin a new long press timer in response to a `KeyEvent`.
	/// - Parameters:
	///   - action: The `Action`.
	///   - event: The `KeyEvent` which is passed to handler.
	func beginTimer<A: Action>(for action: A, event: ActionEvent<KeyEvent<A.Settings>>) {
		
		log.log("Beginning long press timer for \(action.context, privacy: .public)")
		
		// Begin the long-press timer
		let timer = Timer(timeInterval: action.longPressDuration, repeats: false) { _ in
			log.log("Long key press timer has fired for \(action.context, privacy: .public)")
			self.lastState[action.context] = true
			action.longKeyPress(device: event.device, payload: event.payload)
		}
		
		storeTimer(timer, for: action)
	}
	
	/// Begin a new long press timer in response to a `EncoderPressEvent`.
	/// - Parameters:
	///   - action: The `Action`.
	///   - event: The `KeyEvent` which is passed to handler.
	func beginTimer<A: Action>(for action: A, event: ActionEvent<EncoderPressEvent<A.Settings>>) {
		
		log.log("Beginning long press timer for \(action.context, privacy: .public)")
		
		// Begin the long-press timer
		let timer = Timer(timeInterval: action.longPressDuration, repeats: false) { _ in
			log.log("Long dial press timer has fired for \(action.context, privacy: .public)")
			self.lastState[action.context] = true
			action.longDialPress(device: event.device, payload: event.payload)
		}
		
		storeTimer(timer, for: action)
	}
	
	@discardableResult
	/// Invalidate a `Timer` in response to an event.
	/// - Parameter action: The `Action`.
	/// - Returns: A `Bool` indicating whether the long press timer fired before it was invalidated. 
	func invalidateTimer<A: Action>(for action: A) -> Bool {
		log.log("Invalidating long press timer for \(action.context, privacy: .public)")
		activeTimers[action.context]?.invalidate()
		
		return lastState[action.context] ?? false
	}

}
