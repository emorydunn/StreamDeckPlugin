//
//  Text.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Text: LayoutItemProtocol {
	public let key: String
	public let type: LayoutElement = .text

	public var value: String

	public var enabled: Bool?

	public var rect: Rect = .standard
	public var zOrder: Int?

	public var opacity: Double?
	public var background: String?

	public var alignment: TextAlignment?
	public var textOverflow: TextOverflow?
	public var font: Font?

	public init(key: String, value: String) {
		self.key = key
		self.value = value
	}

	public init(title: String) {
		self.key = "title"
		self.value = title
	}

}

extension Text {
	public func textAlignment(_ alignment: TextAlignment) -> Text {
		var copy = self
		copy.alignment = alignment
		return copy
	}

	public func font(_ font: Font) -> Text {
		var copy = self
		copy.font = font
		return copy
	}

	public func font(size: Int, weight: Int) -> Text {
		var copy = self
		copy.font = Font(size: size, weight: weight)
		return copy
	}

	public func font(size: Int) -> Text {
		var copy = self

		if copy.font == nil {
			copy.font = Font(size: size)
		} else {
			copy.font?.size = size
		}

		return copy
	}

	public func font(weight: Int) -> Text {
		var copy = self

		if copy.font == nil {
			copy.font = Font(weight: weight)
		} else {
			copy.font?.weight = weight
		}

		return copy
	}
}
