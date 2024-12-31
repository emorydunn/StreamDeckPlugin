//
//  Slider.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Slider: BarLayoutItem {
	public let key: LayoutItemKey
	public let type: LayoutElement = .slider

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

	public var bar_h: Int?

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

extension Slider {
	public func barHeight(_ height: Int) -> Slider {
		var copy = self

		copy.bar_h = height

		return copy
	}
}

public struct SliderLayoutSettings: LayoutSettings {
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

	public var bar_h: Int?
}
