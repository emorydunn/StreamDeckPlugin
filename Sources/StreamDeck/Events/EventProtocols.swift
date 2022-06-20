//
//  EventProtocols.swift
//  
//
//  Created by Emory Dunn on 10/25/21.
//

import Foundation

/// An event that includes coordinate information about the action.
public protocol Locatable {
    
    /// The coordinates of the action.
    var coordinates: Coordinates? { get }
}

/// An event which includes the action's settings.
public protocol EventSettings {
    
    /// The event's settings.
    var settings: [String: String] { get }
}
