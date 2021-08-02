//
//  ActionInstance.swift
//  
//
//  Created by Emory Dunn on 8/1/21.
//

import Foundation

public struct ActionInstance {
    public let action: String
    public let coordinates: Coordinates
}

extension ActionInstance {
    init(event: ActionEvent<AppearEvent>) {
        self.action = event.action
        self.coordinates = event.payload.coordinates
    }
}
