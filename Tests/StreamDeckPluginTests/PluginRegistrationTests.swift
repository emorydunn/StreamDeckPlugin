//
//  PluginRegistrationTests.swift
//
//
//  Created by Emory Dunn on 11/14/21.
//

import Foundation
import XCTest
@testable import StreamDeck

final class PluginRegistrationTests: XCTestCase {

	func testRegistrationFromString() {
		XCTAssertNoThrow(try PluginRegistrationInfo(string: TestEvent.registrationInfo))
	}

}
