//
//  File.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation
import XCTest
@testable import SDPlusLayout

extension JSONEncoder {
	func json<T>(_ value: T) throws -> String where T : Encodable {
		let data = try encode(value)

		return String(decoding: data, as: UTF8.self)
	}
}


final class LayoutTests: XCTestCase {

	func testBuilder() {
		let layout = Layout(id: "custom") {
			Image(key: "logo", path: "images/logo.png")
				.frame(width: 60, height: 20)
				.position(x: 50, y: 50)

			Text(title: "Hi there!")
				.frame(width: 100, height: 20)
				.position(x: 5, y: 5)
				.zIndex(5)

			Bar(key: "bar", value: 5)
				.borderWidth(20)
				.barBackground(.red, .green, .blue)
		}
	}

	func testEncodeColor() throws {
		let color = Color.blueviolet

		let string = try JSONEncoder().json(color)

		XCTAssertEqual(string, "\"#8A2BE2\"")
	}

	func testEncodeGradient() throws {
		let gradient = Gradient(colors: [.red, .green, .blue])

		let string = try JSONEncoder().json(gradient)

		XCTAssertEqual(string, "\"0: #FF0000, 0.5: #008000, 1: #0000FF\"")
	}

	func testEncodeColorStyle() throws {
		let color = ColorStyle.color(.blueviolet)

		let string = try JSONEncoder().json(color)

		XCTAssertEqual(string, "\"#8A2BE2\"")
	}
}

