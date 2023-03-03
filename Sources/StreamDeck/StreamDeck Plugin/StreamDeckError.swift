//
//  StreamDeckError.swift
//  
//
//  Created by Emory Dunn on 7/25/21.
//

import Foundation

/// Errors that can occur when communicating with the Stream Deck application.
enum StreamDeckError: LocalizedError {

	/// The JSON for an event is invalid.
	case invalidJSON(String, [String: Any])

	/// The UUID has been used more than once.
	case duplicateUUIDs(String)

	/// The error description.
	var errorDescription: String? {
		switch self {
		case let .invalidJSON(event, json):
			return """
				The JSON for \(event) is invalid.

				\(json)
				"""
		case let .duplicateUUIDs(uuid):
			return "The UUID '\(uuid)' has been specified more than once."
		}
	}
}
