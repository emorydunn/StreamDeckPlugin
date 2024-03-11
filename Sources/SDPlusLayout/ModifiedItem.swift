//
//  ModifiedItem.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

struct ModifiedItem: LayoutItem {
	var wrapped: any LayoutItem

	init(_ item: some LayoutItem) {
		self.wrapped = item
	}

	init(modifying item: some LayoutItem, action: (inout LayoutItemProtocol) -> Void) {
		if var copy = item as? LayoutItemProtocol {

			action(&copy)

			self.wrapped = copy

		} else if let modified = item as? ModifiedItem, var copy = modified.wrapped as? LayoutItemProtocol {

			action(&copy)

			self.wrapped = copy

		} else {
			self.wrapped = item
		}
	}

	init(modifyingBar item: some LayoutItem, action: (inout BarLayoutItem) -> Void) {
		if var copy = item as? BarLayoutItem {

			action(&copy)

			self.wrapped = copy

		} else if let modified = item as? ModifiedItem, var copy = modified.wrapped as? BarLayoutItem {

			action(&copy)

			self.wrapped = copy

		} else {
			self.wrapped = item
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		try container.encode(wrapped)
	}
}
