//
//  File 2.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

/// Keys marked as exported are expected to be set by an action before it finishes.
///
/// `ImportedContext` checks whether a key has been registered by a previous `ExportedContext`.
@propertyWrapper
public struct Environment<K: EnvironmentKey>: CustomReflectable {

    public init(_ key: K.Type) {}
    
    /// Gets and sets the value in the shared `ContextValues` instance.
    public var wrappedValue: K.Value {
        get {
            EnvironmentValues.shared[K.self]
        }
        set {
            EnvironmentValues.shared[K.self] = newValue
        }
        
    }
    
    public var customMirror: Mirror {
        Mirror(String.self, children: ["ExportedKey": K.dictKey])
    }
}
