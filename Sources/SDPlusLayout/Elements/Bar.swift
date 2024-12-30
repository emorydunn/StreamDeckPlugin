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
	public var range: BarRange

	public var subtype: BarStyle?

	public var enabled: Bool?

	public var rect: Rect = .standard
	public var zOrder: Int?

	public var opacity: Double?
	public var background: String?

	public var border_w: Int?
	public var bar_bg_c: ColorStyle?
	public var bar_border_c: Color?
	public var bar_fill_c: Color?

	@available(*, deprecated, message: "Use a closed range instead.")
	public init(key: String, value: Int, range: Range<Int> = 0..<100) {
		self.key = key
		self.value = value
		self.range = BarRange(min: range.lowerBound, max: range.upperBound)
	}

	public init(key: String, value: Int, range: ClosedRange<Int> = 0...100) {
		self.key = key
		self.value = value
		self.range = BarRange(min: range.lowerBound, max: range.upperBound)
	}

}
