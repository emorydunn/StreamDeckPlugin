//
//  Color+ExpressibleByStringLiteral.swift
//  
//
//  Created by Emory Dunn on 10/20/22.
//

import Foundation

let rgbRegex = try! NSRegularExpression(pattern: #"rgba?\(([\d,\.]+)\)"#)

extension Color: ExpressibleByStringLiteral {

	public init(stringLiteral value: String) {

		if value.starts(with: "#") {
			self = .init(hexString: value)
		} else if value.starts(with: "rgb") {
			guard
				let match = rgbRegex.matches(in: value, range: NSRange(location: 0, length: value.count)).first
			else {
				self = .black
				return
			}

			let range = Range(match.range(at: 1), in: value)!

			let components = value[range].split(separator: ",").compactMap { Double($0) }
			self = Color(fromComponents: components)

		} else {
			self = Color(name: value) ?? Color.black
		}
	}
}
