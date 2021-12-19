//
//  IncrementAction.swift
//  
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck

class IncrementAction: Action {
    
    static var name: String = "Increment"
    
    static var uuid: String = "counter.increment"
    
    static var icon: String = "Icons/actionIcon"
    
    static var states: [PluginActionState] = [
        PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
    ]
    
    static var propertyInspectorPath: String?
    
    static var supportedInMultiActions: Bool?
    
    static var tooltip: String?
    
    static var visibleInActionsList: Bool?

    var context: String
    
    var coordinates: Coordinates
    
    @Environment(PluginCount.self) var count: Int
    
    required init(context: String, coordinates: Coordinates) {
        self.context = context
        self.coordinates = coordinates
    }
    
    func keyDown(device: String, payload: KeyEvent) {
        count += 1
    }

}
