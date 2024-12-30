//
//  Properties.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public enum LayoutElement: String, Encodable {
	case image = "pixmap"
	case bar
	case slider = "gbar"
	case text
}

public enum BarStyle: Int, Encodable {
	case rectangle, doubleRectangle, trapezoid, doubleTrapezoid, groove
}

public enum TextOverflow: String, Encodable {
	case truncate = "ellipsis"
	case clip
	case fade
}

public enum TextAlignment: String, Encodable {
	case left, center, right
}

public struct Rect: Encodable {
	public var x: Int
	public var y: Int
	public var width: Int
	public var height: Int

	public init(x: Int, y: Int, width: Int, height: Int) {
		//		assert(x >= 0, "X must be greater than 0.")
		//		assert(y >= 0, "Y must be greater than 0.")
		//
		//		assert(x + width <= 200, "Rect width can not extend beyond 200 pixels.")
		//		assert(y + height <= 100, "Rect height can not extend beyond 100 pixels.")

		self.x = x
		self.y = y
		self.width = width
		self.height = height
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		try container.encode([x, y, width, height])
	}
	
	/// A rectangle which fills the whole layout. 
	static var standard = Rect(x: 0, y: 0, width: 200, height: 100)
}

public struct Font: Encodable {
	public var size: Int?
	public var weight: Int?
}

public struct BarRange: Encodable {
	public var min: Int
	public var max: Int

	public init(min: Int, max: Int) {
		self.min = min
		self.max = max
	}
}
