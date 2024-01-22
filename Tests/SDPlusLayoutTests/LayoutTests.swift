//
//  File.swift
//  
//
//  Created by Emory Dunn on 1/22/24.
//

import Foundation
import XCTest
@testable import SDPlusLayout

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
		}
	}
}

