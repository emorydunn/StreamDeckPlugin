//
//  PluginManifestTests.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import XCTest
@testable import StreamDeck

final class PluginManifestTests: XCTestCase {
	
	func testEncode() {
		let manifest = PluginManifest(
			name: "Counter",
			description: "Count things. On your Stream Deck!",
			category: "Counting Actions",
			author: "Emory Dunn",
			icon: "counter",
			version: "0.1",
			os: [
				.macOS(.v11),
				.windows("10")
			],
			applicationsToMonitor: ApplicationsToMonitor(mac: ["com.test.app"]),
			software: .minimumVersion("4.1"),
			sdkVersion: 2,
			codePath: "counter-plugin",
			actions: [
				PluginAction(
					name: "Increment",
					uuid: "photo.lostcause.counter.increment",
					icon: "Icons/plus",
					states: [
						PluginActionState(image: "Icons/plus")
					],
					tooltip: "Increment the count."),
				PluginAction(
					name: "Decrement",
					uuid: "photo.lostcause.counter.decrement",
					icon: "Icons/minus",
					tooltip: "Decrement the count.")
			])
		
		let generator = ExportCommand()
		XCTAssertNoThrow(try ExportCommand.manifestEncoder.encode(manifest))
		
	}
}
