//
//  StreamDeckError.swift
//  
//
//  Created by Emory Dunn on 7/25/21.
//

import Foundation

/// Errors that can occur when communicating with the Stream Deck application.
enum StreamDeckError: LocalizedError {
    case invalidJSON(String, [String: Any])
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
