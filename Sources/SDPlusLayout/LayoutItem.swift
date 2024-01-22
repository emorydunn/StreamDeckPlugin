//
//  LayoutItem.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public protocol LayoutItem: Encodable { }

public protocol LayoutItemProtocol: LayoutItem {
	var key: String { get }
	var type: LayoutElement { get }

	var enabled: Bool { get set }

	var frame: Rect { get set }

	var zOrder: Int? { get set }

	var opacity: Double { get set }

	var background: String? { get set }

}

public extension LayoutItem {
	func frame(width: Int, height: Int) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.frame.width = width
			copy.frame.height = height
		}
	}

	func position(x: Int, y: Int) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.frame.x = x
			copy.frame.y = y
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

	func background(_ color: String) -> some LayoutItem {
		ModifiedItem(modifying: self) { copy in
			copy.background = color
		}
	}

}
