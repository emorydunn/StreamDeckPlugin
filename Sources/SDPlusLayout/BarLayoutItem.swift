//
//  BarLayoutItem.swift
//
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public protocol BarLayoutItem: LayoutItemProtocol {

	var borderWidth: Int? { get set }
	var barBackgroundColor: ColorStyle? { get set }
	var barBorderColor: Color? { get set }
	var barFillColor: Color? { get set }
}

public extension LayoutItem {
	func borderWidth(_ width: Int) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.borderWidth = width
		}
	}

	func barBackground(_ color: Color) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.barBackgroundColor = .color(color)
		}
	}

	func barBackground(_ gradient: Gradient) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.barBackgroundColor = .gradient(gradient)
		}
	}

	func barBackground(_ gradient: Color...) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.barBackgroundColor = .gradient(Gradient(colors: gradient))
		}
	}

	func barBackground(_ gradient: Gradient.Stop...) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.barBackgroundColor = .gradient(Gradient(stops: gradient))
		}
	}

	func barBorder(_ color: Color) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.barBorderColor = color
		}
	}

	func barFill(_ color: Color) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.barFillColor = color
		}
	}
}
