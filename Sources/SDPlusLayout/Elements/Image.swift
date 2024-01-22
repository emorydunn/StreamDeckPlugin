//
//  Image.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Image: LayoutItemProtocol {
	public let key: String
	public let type: LayoutElement = .image

	public var value: String

	public var enabled: Bool = true

	public var frame: Rect = .standard
	public var zOrder: Int?

	public var opacity: Double = 1
	public var background: String? = nil

	public init(key: String, path: String) {
		self.key = key
		self.value = path
	}

	public init(key: String, base64 image: String) {
		self.key = key
		self.value = image
	}
}
