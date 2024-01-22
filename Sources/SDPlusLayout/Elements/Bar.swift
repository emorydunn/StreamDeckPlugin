//
//  Bar.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Bar: BarLayoutItem {
	public let key: String
	public let type: LayoutElement = .bar

	public var value: Int
	public var range: Range<Int>

	public var subtype: BarStyle?

	public var enabled: Bool = true

	public var frame: Rect = .standard
	public var zOrder: Int?

	public var opacity: Double = 1
	public var background: String?

	public var borderWidth: Int?
	public var barBackgroundColor: String?
	public var barBorderColor: String?
	public var barFillColor: String?

	public init(key: String, value: Int, range: Range<Int> = 0..<100) {
		self.key = key
		self.value = value
		self.range = range
	}
}
