//
//  EventProtocols.swift
//  
//
//  Created by Emory Dunn on 10/25/21.
//

import Foundation

/// An event that includes coordinate information about the action.
///
/// - Note: Actions that are part of a Multi-Action don't have individual coordinates as they are nested inside their parent action. 
public protocol Locatable {
    
    /// The coordinates of the action.
    var coordinates: Coordinates? { get }
}

/// An event which includes the action's settings.
@available(*, deprecated)
public protocol EventSettings {
    
    /// The event's settings.
    var settings: [String: String] { get }
}
