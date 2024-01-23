//
//  BarLayoutItem.swift
//
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public protocol BarLayoutItem: LayoutItemProtocol {

	var subtype: BarStyle? { get set }

	var border_w: Int? { get set }
	var bar_bg_c: ColorStyle? { get set }
	var bar_border_c: Color? { get set }
	var bar_fill_c: Color? { get set }
}

public extension LayoutItem {
	func borderWidth(_ width: Int) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.border_w = width
		}
	}

	func barBackground(_ color: Color) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.bar_bg_c = .color(color)
		}
	}

	func barBackground(_ gradient: Gradient) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.bar_bg_c = .gradient(gradient)
		}
	}

	func barBackground(_ gradient: Color...) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.bar_bg_c = .gradient(Gradient(colors: gradient))
		}
	}

	func barBackground(_ gradient: Gradient.Stop...) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.bar_bg_c = .gradient(Gradient(stops: gradient))
		}
	}

	func barBorder(_ color: Color) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.bar_border_c = color
		}
	}

	func barFill(_ color: Color) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.bar_fill_c = color
		}
	}

	func barStyle(_ style: BarStyle) -> some LayoutItem {
		ModifiedItem(modifyingBar: self) { copy in
			copy.subtype = style
		}
	}
}
