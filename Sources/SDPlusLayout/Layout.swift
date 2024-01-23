//
//  Layout.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Layout: Identifiable, Encodable {

	enum CodingKeys: String, CodingKey {
		case id
		case items
	}

	public let id: LayoutName

	var items: [any LayoutItem]

	public init(id: LayoutName, @ItemBuilder items: () -> [any LayoutItem]) {
		self.id = id
		self.items = items()
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(id, forKey: .id)

		var itemContainer = container.nestedUnkeyedContainer(forKey: .items)

		for item in items {
			try itemContainer.encode(ModifiedItem(item))
		}
	}
}

@resultBuilder
public struct ItemBuilder {

	public static func buildBlock() -> [any LayoutItem] {
		return []
	}

	public static func buildBlock(_ components: any LayoutItem...) -> [any LayoutItem] {

		// Place each item on a separate layer unless zIndex is specified.
		// This will prevent items overlapping and not being displayed
		// With the caveat that the auto-ordering could collide with an
		// explicitly set index 
		components.enumerated().map { index, item in
			ModifiedItem(modifying: item) { copy in
				if copy.zOrder == nil {
					copy.zOrder = index
				}
			}
		}
	}
}
