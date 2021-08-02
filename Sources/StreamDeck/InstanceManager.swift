//
//  ContextManager.swift
//  
//
//  Created by Emory Dunn on 7/26/21.
//

import Foundation

/// Manages known instances from the `willAppear` & `willDisappear` events.
public class InstanceManager {
    
    /// Known instances of the plugin's actions.
    public private(set) var instances: [String: ActionInstance]
    
    /// Create a new manager.
    /// - Parameter instances: Instances to register.
    public init(instances: [String: ActionInstance] = [:]) {
        self.instances = instances
    }
    
    /// Register a new instance of an action from a `willAppear` event.
    /// - Parameter action: The action instance to register.
    func registerInstance(_ action: ActionEvent<AppearEvent>) {
        NSLog("Registered instance of \(action.action) at \(action.payload.coordinates).")
        instances[action.context] = ActionInstance(event: action)
    }
    
    /// Remove an instance of an action from a `willDisappear` event.
    /// - Parameter action: The action instance to unregister.
    func removeInstance(_ action: ActionEvent<AppearEvent>) {
        NSLog("Removed instance of \(action.action) at \(action.payload.coordinates).")
        instances[action.context] = nil
    }
    
    /// Look up an instance based on its context.
    /// - Parameter context: The context from a Stream Deck event.
    /// - Returns: The registered action, if found.
    public func instance(for context: String) -> ActionInstance? {
        instances[context]
    }
    
    /// Look up all instances with the specified action UUID.
    ///
    /// The `actionID` is lowercased before lookup, as that seems to be how the Stream Deck stores IDs internally.
    /// - Parameter actionID: The action UUID as specified in `manifest.json`
    /// - Returns: All instances of the action found.
    public func instances(with actionID: String) -> [ActionInstance] {
        instances.values.filter { $0.action == actionID.lowercased() }
    }
    
    /// Look up an instance based on its coordinates.
    ///
    /// - Important: I'm not sure how this handles folders and more than one device. 
    /// - Parameter coordinates: The desired instances coordinates.
    /// - Returns: The registered action, if found.
    public func instance(at coordinates: Coordinates) -> ActionInstance? {
        instances.values.first { $0.coordinates == coordinates }
    }
}
