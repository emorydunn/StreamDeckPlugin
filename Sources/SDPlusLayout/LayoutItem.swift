//
//  LayoutItem.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public protocol LayoutItem: Encodable { }

public protocol LayoutItemProtocol: LayoutItem {

	var type: LayoutElement { get }

	var key: LayoutItemKey { get }

	var enabled: Bool? { get set }

	var rect: Rect { get set }

	var zOrder: Int? { get set }

	var opacity: Double? { get set }

	var background: ColorStyle? { get set }

}

public extension LayoutItem {
	func frame(width: Int, height: Int) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.rect.width = width
			copy.rect.height = height
		}
	}

	func position(x: Int, y: Int) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.rect.x = x
			copy.rect.y = y
		}
	}

	func zIndex(_ index: Int) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.zOrder = index
		}
	}

	func opacity(_ opacity: Double) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.opacity = opacity
		}
	}

	func disabled(_ disabled: Bool = true) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.enabled = !disabled
		}
	}

	@_disfavoredOverload
	@available(*, deprecated, message: "Use the Color type instead")
	func background(_ color: String) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.background = .color(Color(hexString: color))
		}
	}

	func background(_ color: ColorStyle) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.background = color
		}
	}

	func background(_ color: Color) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.background = .color(color)
		}
	}

	func background(_ gradient: Gradient) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.background = .gradient(gradient)
		}
	}

}
