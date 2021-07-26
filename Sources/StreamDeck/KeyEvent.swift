//
//  File.swift
//  
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation

public struct KeyEventAction: Decodable {
    public let action: String
    public let context: String
    public let device: String
    public let payload: KeyEvent
}

public struct KeyEvent: Decodable {
    public let settings: [String: String]
    public let coordinates: Coordinates
    public let state: Int?
    public let userDesiredState: Int?
    public let isInMultiAction: Bool
    
}

extension KeyEvent {
    public struct Coordinates: Decodable {
        public let column: Int
        public let row: Int
    }
}
