//
//  TriggerDescription.swift
//  
//
//  Created by Emory Dunn on 12/25/22.
//

import Foundation

/// Used to describe encoder actions in the property inspector.
public struct TriggerDescription: Codable {
	/// Optional value that describes the rotate interaction with the dial.
	///
	/// When undefined the description will be hidden.
	let rotate: String?
	/// Optional value that describes the push interaction with the dial.
	///
	/// When undefined the description will be hidden.
	let push: String?
	
	/// Optional value that describes the touch interaction with the touch display.
	///
	/// When undefined the description will be hidden.
	let touch: String?

	/// Optional value that describes the long-touch interaction with the touch display.
	///
	/// When undefined the description will be hidden.
	let longTouch: String?

	public init(rotate: String? = nil, push: String? = nil, touch: String? = nil, longTouch: String? = nil) {
		self.rotate = rotate
		self.push = push
		self.touch = touch
		self.longTouch = longTouch
	}
}
