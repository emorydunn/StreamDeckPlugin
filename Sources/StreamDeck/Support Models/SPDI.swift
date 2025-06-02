//
//  SPDI.swift
//  StreamDeck
//
//  Created by Emory Dunn on 6/2/25.
//

import Foundation

public protocol SPDIItem: Codable { }

public struct DatasourceItem: SPDIItem {

	public var label: String?
	public var value: String
	public var disabled: Bool?

	public init(label: String? = nil, value: String, disabled: Bool? = nil) {
		self.label = label
		self.value = value
		self.disabled = disabled
	}
}

public struct DatasourceItemGroup: SPDIItem {

	public var label: String?
	public var children: [DatasourceItem]

	public init(label: String? = nil, children: [DatasourceItem]) {
		self.label = label
		self.children = children
	}

}

/// The nested payload sent to the property inspector, from the plugin, via `sendToPropertyInspector`.
public struct DataSourcePayload {

	public enum CodingKeys: CodingKey {
		case event, items
	}

	/// The event that requested the data source.
	public let event: String

	/// The items of the data source.
	public let items: [any SPDIItem]

	public init(event: String, items: [any SPDIItem]) {
		self.event = event
		self.items = items
	}

	public init<C>(event: String, items: C, map: (C.Element) -> any SPDIItem) where C: Collection{
		self.event = event
		self.items = items.map(map)
	}

}

extension DataSourcePayload: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(event, forKey: .event)
		try container.encode(items.compactMap(PayloadItem.init), forKey: .items)
	}
}

extension DataSourcePayload: Decodable {
	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.event = try container.decode(String.self, forKey: .event)
		self.items = try container.decode([PayloadItem].self, forKey: .items).compactMap(\.item)
	}
}

struct PayloadItem: Codable {
	let label: String?
	let value: String?
	let disabled: Bool?
	let children: [PayloadItem]?

	init?(_ item: any SPDIItem) {
		switch item {
		case let item as DatasourceItem:
			self.init(item)
		case let item as DatasourceItemGroup:
			self.init(item)
		default:
			return nil
		}
	}

	init(_ item: DatasourceItem) {
		self.label = item.label
		self.value = item.value
		self.disabled = item.disabled
		self.children = nil
	}

	init(_ item: DatasourceItemGroup) {
		self.label = item.label
		self.children = item.children.map(PayloadItem.init)

		self.value = nil
		self.disabled = nil

	}

	var item: (any SPDIItem)? {

		// If the item has a value it's a standard item
		if let value {
			DatasourceItem(label: label, value: value, disabled: disabled)
		}

		// If the item has children it's a group
		if let children {

			// Map the children back to DatasourceItems
			let items: [DatasourceItem] = children.compactMap { item in
				item.item as? DatasourceItem
			}

			DatasourceItemGroup(label: label, children: items)
		}

		// If it has neither marker toss it back into the digital ocean
		return nil
	}
}
