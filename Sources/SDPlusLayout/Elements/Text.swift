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
