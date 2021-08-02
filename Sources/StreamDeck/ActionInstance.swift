//
//  ActionInstance.swift
//  
//
//  Created by Emory Dunn on 8/1/21.
//

import Foundation

public struct ActionInstance {
    public let action: String
    public let context: String
    public let coordinates: Coordinates
}

extension ActionInstance: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(context)
    }
}

extension ActionInstance {
    init(event: ActionEvent<AppearEvent>) {
        self.action = event.action
        self.context = event.context
        self.coordinates = event.payload.coordinates
    }
}
