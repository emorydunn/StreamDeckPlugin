//
//  Bar.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Bar: BarLayoutItem {
	public let key: LayoutItemKey
	public let type: LayoutElement = .bar

	public var value: Int
	public var range: BarRange

	public var subtype: BarStyle?

	public var enabled: Bool?

	public var rect: Rect = .standard
	public var zOrder: Int?

	public var opacity: Double?
	public var background: ColorStyle?

	public var border_w: Int?
	public var bar_bg_c: ColorStyle?
	public var bar_border_c: Color?
	public var bar_fill_c: Color?

	@_disfavoredOverload
	@available(*, deprecated, message: "Use a closed range instead.")
	public init(key: LayoutItemKey, value: Int, range: Range<Int> = 0..<100) {
		self.key = key
		self.value = value
		self.range = BarRange(min: range.lowerBound, max: range.upperBound)
	}

	public init(key: LayoutItemKey, value: Int, range: ClosedRange<Int> = 0...100) {
		self.key = key
		self.value = value
		self.range = BarRange(min: range.lowerBound, max: range.upperBound)
	}

}

public struct BarLayoutSettings: LayoutSettings {
	public var value: Double?
	public var range: BarRange?

	public var subtype: BarStyle?

	public var enabled: Bool?

	public var opacity: Double?
	public var background: ColorStyle?

	public var border_w: Int?
	public var bar_bg_c: ColorStyle?
	public var bar_border_c: Color?
	public var bar_fill_c: Color?

	public init(value: Double? = nil,
				range: BarRange? = nil,
				subtype: BarStyle? = nil,
				enabled: Bool? = nil,
				opacity: Double? = nil,
				background: ColorStyle? = nil,
				border_w: Int? = nil,
				bar_bg_c: ColorStyle? = nil,
				bar_border_c: Color? = nil,
				bar_fill_c: Color? = nil) {
		self.value = value
		self.range = range
		self.subtype = subtype
		self.enabled = enabled
		self.opacity = opacity
		self.background = background
		self.border_w = border_w
		self.bar_bg_c = bar_bg_c
		self.bar_border_c = bar_border_c
		self.bar_fill_c = bar_fill_c
	}

	@_disfavoredOverload
	public init(value: Double? = nil,
				range: BarRange? = nil,
				subtype: BarStyle? = nil,
				enabled: Bool? = nil,
				opacity: Double? = nil,
				background: ColorStyle? = nil,
				border_w: Int? = nil,
				bar_bg_c: Color? = nil,
				bar_border_c: Color? = nil,
				bar_fill_c: Color? = nil) {
		self.value = value
		self.range = range
		self.subtype = subtype
		self.enabled = enabled
		self.opacity = opacity
		self.background = background
		self.border_w = border_w
		if let bar_bg_c {
			self.bar_bg_c = .color(bar_bg_c)
		}
		self.bar_border_c = bar_border_c
		self.bar_fill_c = bar_fill_c
	}
}

extension BarLayoutSettings: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByNilLiteral {
	public init(integerLiteral value: Int) {
		self.init(value: Double(value))
	}

	public init(floatLiteral value: Double) {
		self.init(value: value)
	}

	public init(nilLiteral: ()) {
		self.init()
	}

}
