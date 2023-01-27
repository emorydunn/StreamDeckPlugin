//
//  StreamDeckKey.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation
import ArgumentParser

/// A coding key for converting between `JSONCodable` and the keys expected by the Stream Deck application.
struct StreamDeckKey: CodingKey {
	var stringValue: String
	var intValue: Int?
	
	init(key: CodingKey) {
		self.init(stringValue: key.stringValue)!
	}
	
	init?(stringValue: String) {
		switch stringValue {
		case "sdkVersion":
			self.stringValue = "SDKVersion"
		case "uuid", "url", "os":
			self.stringValue = stringValue.uppercased()
		case "layout", "background":
			self.stringValue = stringValue
		default:
			let firstLetter = stringValue.first!.uppercased()
			self.stringValue = firstLetter + stringValue.dropFirst()
		}
		self.intValue = nil
	}
	
	init?(intValue: Int) {
		self.stringValue = String(intValue)
		self.intValue = intValue
	}
}
