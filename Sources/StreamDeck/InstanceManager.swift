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
    public private(set) var instances: Set<ActionInstance>
    
    /// Create a new manager.
    /// - Parameter instances: Instances to register.
    public init(instances: Set<ActionInstance> = []) {
        self.instances = instances
    }
    
    /// Register a new instance of an action from a `willAppear` event.
    /// - Parameter action: The action instance to register.
    func registerInstance(_ action: ActionEvent<AppearEvent>) {
        NSLog("Registered instance of \(action.action) at \(action.payload.coordinates).")
        instances.insert(ActionInstance(event: action))
    }
    
    /// Remove an instance of an action from a `willDisappear` event.
    /// - Parameter action: The action instance to unregister.
    func removeInstance(_ action: ActionEvent<AppearEvent>) {
        NSLog("Removed instance of \(action.action) at \(action.payload.coordinates).")
        if let instance = instance(for: action.context) {
            instances.remove(instance)
        }
        
    }
    
    /// Look up an instance based on its context.
    /// - Parameter context: The context from a Stream Deck event.
    /// - Returns: The registered action, if found.
    public func instance(for context: String) -> ActionInstance? {
        instances.first { $0.context == context }
    }
    
    /// Look up all instances with the specified action UUID.
    ///
    /// The `actionID` is lowercased before lookup, as that seems to be how the Stream Deck stores IDs internally.
    /// - Parameter actionID: The action UUID as specified in `manifest.json`
    /// - Returns: All instances of the action found.
    public func instances(with actionID: String) -> [ActionInstance] {
        instances.filter { $0.action == actionID.lowercased() }
    }
    
    /// Look up an instance based on its coordinates.
    ///
    /// - Important: I'm not sure how this handles folders and more than one device. 
    /// - Parameter coordinates: The desired instances coordinates.
    /// - Returns: The registered action, if found.
    public func instance(at coordinates: Coordinates) -> ActionInstance? {
        instances.first { $0.coordinates == coordinates }
    }
}


/// Manages known instances from the `willAppear` & `willDisappear` events.
public class InstanceManagerII {
    
    private var actions: [Action.Type]
    private var instances: [String: Action] = [:]
    
    public init(actions: [Action.Type] = []) {
        self.actions = actions
    }
    
    /// Look up the action type based on the UUID.
    /// - Parameter uuid: The UUID of the action.
    /// - Returns: The action's type, if available.
    public func action(forID uuid: String) -> Action.Type? {
        actions.first { $0.uuid == uuid }
    }
    
    /// Register a new instance of an action from a `willAppear` event.
    /// - Parameter event: The event with information about the instance.
    public func registerInstance(_ event: ActionEvent<AppearEvent>) {
        
        // Check if the instance already exists
        guard instances[event.context] == nil else {
            NSLog("This instance has already been registered.")
            return
        }
        
        // Look up the action
        guard let actionType = action(forID: event.action) else {
            NSLog("No action available with UUID '\(event.action)'.")
            return
        }
        
        // Initialize a new instance
        instances[event.context] = actionType.init(context: event.context, coordinates: event.payload.coordinates)
        
    }
    
    /// Remove an instance of an action from a `willDisappear` event.
    /// - Parameter event: The event with information about the instance.
    public func removeInstance(_ event: ActionEvent<AppearEvent>) {
        instances[event.context] = nil
    }
    
    subscript (context: String) -> Action? { instances[context] }
}
