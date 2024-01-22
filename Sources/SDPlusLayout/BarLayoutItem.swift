//
//  BarLayoutItem.swift
//
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public protocol BarLayoutItem: LayoutItemProtocol {
	var borderWidth: Int? { get set }
	var barBackgroundColor: String? { get set }
	var barBorderColor: String? { get set }
	var barFillColor: String? { get set }
}

public extension LayoutItem {
	func borderWidth(_ width: Int) -> some LayoutItem {
		return ModifiedItem(modifyingBar: self) { copy in
			copy.borderWidth = width
		}
	}
}
