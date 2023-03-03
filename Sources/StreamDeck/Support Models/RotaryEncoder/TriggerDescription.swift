//
//  TriggerDescription.swift
//  
//
//  Created by Emory Dunn on 12/25/22.
//

import Foundation

public struct TriggerDescription: Codable {
	let rotate: String?
	let push: String?
	let touch: String?
	let longTouch: String?

	public init(rotate: String? = nil, push: String? = nil, touch: String? = nil, longTouch: String? = nil) {
		self.rotate = rotate
		self.push = push
		self.touch = touch
		self.longTouch = longTouch
	}
}
