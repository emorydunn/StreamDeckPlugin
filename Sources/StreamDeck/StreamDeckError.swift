//
//  StreamDeckError.swift
//  
//
//  Created by Emory Dunn on 7/25/21.
//

import Foundation

enum StreamDeckError: LocalizedError {
    case invlaidJSON(String, [String: Any])
    
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
