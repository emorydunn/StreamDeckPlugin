//
//  File.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation

public struct Gradient: Encodable {
	public let stops: [Stop]

	public init(stops: [Stop]) {
		self.stops = stops
	}

	public init(colors: [Color]) {

		switch colors.count {
		case 0:
			self.stops = []
			return
		case 1:
			self.stops = [Stop(color: colors[0], position: 0)]
			return
		default:
			break
		}

		let increments = stride(from: 0, through: 1, by: 1.0 / Double(colors.count - 1))

		self.stops = zip(increments, colors).map { position, color in
			Stop(color: color, position: position)
		}
	}

	public struct Stop: Encodable, Comparable {

		public let color: Color
		public let position: Double

		public static func < (lhs: Gradient.Stop, rhs: Gradient.Stop) -> Bool {
			lhs.position < rhs.position
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		let value = stops.sorted().map { stop in
			"\(stop.position.formatted(.number.precision(.fractionLength(0..<2)))): \(stop.color.formatted(.hex))"
		}
		.joined(separator: ", ")

		try container.encode(value)
	}
}
