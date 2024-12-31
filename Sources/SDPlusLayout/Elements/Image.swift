//
//  Image.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

/// Image layout item used to render an image sourced from either a local file located under the plugin's folder, or base64 encoded string.
public struct Image: LayoutItemProtocol {

	/// Unique name used to identify the layout item.
	///
	/// When calling setFeedback this value should be used as the key as part of the object that represents the feedback.
	///
	/// - Note: The key of the layout item cannot be changed at runtime.
	public let key: LayoutItemKey

	public let type: LayoutElement = .image

	public var value: String

	public var enabled: Bool?

	public var rect: Rect = .standard

	public var zOrder: Int?

	public var opacity: Double?


	/// Background color represented as a named color, hexadecimal value, or gradient.
	///
	/// Gradients can be defined by specifying multiple color-stops separated by commas, in the following format `[{offset}:{color}[,]]`.
	public var background: String?
	
	/// Create a default icon `Image` for user-defined icons.
	///
	/// This image will be use the path provided, but will be overridden with a user-defined icon.
	public init(path: String? = nil) {
		self.key = .icon
		self.value = path ?? ""
	}
	
	/// Render an image from a path within the plugin.
	/// - Parameters:
	///   - key: Unique name used to identify the layout item.
	///   - path: Path to the image to render.
	public init(key: LayoutItemKey, path: String) {
		self.key = key
		self.value = path
	}
	
	/// Render an image from a base64 encoded string.
	/// - Parameters:
	///   - key: Unique name used to identify the layout item.
	///   - image: A base64 encoded string with the mime type declared (e.g. PNG, JPEG, etc.), or an SVG string.
	public init(key: LayoutItemKey, base64 image: String) {
		self.key = key
		self.value = image
	}
}
