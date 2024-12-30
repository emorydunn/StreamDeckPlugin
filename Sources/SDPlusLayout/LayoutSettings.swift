//
//  LayoutSettings.swift
//  StreamDeck
//
//  Created by Emory Dunn on 12/30/24.
//



public protocol LayoutSettings: Encodable { }

public struct IndicatorSettings: LayoutSettings {
	public var title: TextLayoutSettings
	public var value: TextLayoutSettings
	public var indicator: BarLayoutSettings

	public init(title: TextLayoutSettings = nil,
				value: TextLayoutSettings = nil,
				indicator: BarLayoutSettings = nil) {
		self.title = title
		self.value = value
		self.indicator = indicator
	}

	public init(title: String? = nil,
				value: TextLayoutSettings = nil,
				indicator: BarLayoutSettings = nil) {
		self.title = TextLayoutSettings(value: title)
		self.value = value
		self.indicator = indicator
	}

	public init(title: TextLayoutSettings = nil,
				value: String? = nil,
				indicator: BarLayoutSettings = nil) {
		self.title = title
		self.value = TextLayoutSettings(value: value)
		self.indicator = indicator
	}

	public init(title: TextLayoutSettings = nil,
				value: TextLayoutSettings = nil,
				indicator: Double? = nil) {
		self.title = title
		self.value = value
		self.indicator = BarLayoutSettings(value: indicator)
	}

	public init(title: String? = nil,
				value: String? = nil,
				indicator: BarLayoutSettings = nil) {
		self.title = TextLayoutSettings(value: title)
		self.value = TextLayoutSettings(value: value)
		self.indicator = indicator
	}

	public init(title: String? = nil,
				value: String? = nil,
				indicator: Double? = nil) {
		self.title = TextLayoutSettings(value: title)
		self.value = TextLayoutSettings(value: value)
		self.indicator = BarLayoutSettings(value: indicator)
	}

}
