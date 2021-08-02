//
//  ActionInstance.swift
//  
//
//  Created by Emory Dunn on 8/1/21.
//

import Foundation

/// Holds information about an instance of an action. 
public struct ActionInstance {
    
    /// The actions' ID from `manifest.json`
    ///
    /// - Note: Stream Deck lowercases the ID. 
    public let action: String
    
    /// The context value for the instance. 
    public let context: String
    
    /// The coordinates of the instance. 
    public let coordinates: Coordinates
}

extension ActionInstance: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(context)
    }
}

extension ActionInstance {
    
    /// Initialize an ActionInstance from an `AppearEvent`
    init(event: ActionEvent<AppearEvent>) {
        self.action = event.action
        self.context = event.context
        self.coordinates = event.payload.coordinates
    }
}
