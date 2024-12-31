//
//  LayoutItemKey.swift
//  StreamDeck
//
//  Created by Emory Dunn on 12/30/24.
//


public struct LayoutItemKey: Encodable, ExpressibleByStringLiteral {
	let key: String

	public init(stringLiteral value: StringLiteralType) {
		self.key = value
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(key)
	}

	public static let title: LayoutItemKey = "title"
	public static let icon: LayoutItemKey = "icon"
	public static let value: LayoutItemKey = "value"
	public static let indicator: LayoutItemKey = "indicator"
	public static let indicator1: LayoutItemKey = "indicator1"
	public static let indicator2: LayoutItemKey = "indicator2"
	public static let canvas: LayoutItemKey = "canvas"
	public static let fullCanvas: LayoutItemKey = "full-canvas"
}
