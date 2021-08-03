//
//  StreamDeckError.swift
//  
//
//  Created by Emory Dunn on 7/25/21.
//

import Foundation

/// Errors that can occur when communicating with the Stream Deck application.
enum StreamDeckError: LocalizedError {
    case invlaidJSON(String, [String: Any])
    
    /// The error description. 
    var errorDescription: String? {
        switch self {
        case let .invlaidJSON(event, json):
            return """
                The JSON for \(event) is invalid.

                \(json)
                """
        }
    }
}
