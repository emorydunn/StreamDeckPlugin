//
//  DecrementAction.swift
//
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck

class DecrementAction: Action {
    
    static var name: String = "Decrement"
    
    static var uuid: String = "counter.decrement"
    
    static var icon: String = "Icons/minus"
    
    static var states: [PluginActionState] = []
    
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
        count -= 1
    }

}
