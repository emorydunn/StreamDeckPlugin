//
//  Coordinates.swift
//  
//
//  Created by Emory Dunn on 11/14/21.
//

import Foundation

/// The coordinates of the action triggered.
public struct Coordinates: Decodable, Hashable, Sendable, CustomStringConvertible {

	/// The column.
	public let column: Int
	
	/// The row.
	public let row: Int

	public var description: String {
		"Coord (\(row), \(column))"
	}
}
