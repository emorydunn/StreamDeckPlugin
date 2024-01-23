//
//  ColorStyle.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public enum ColorStyle: Encodable {
	case color(Color)
	case gradient(Gradient)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .color(let color):
			try container.encode(color)
		case .gradient(let gradient):
			try container.encode(gradient)
		}
	}
}
