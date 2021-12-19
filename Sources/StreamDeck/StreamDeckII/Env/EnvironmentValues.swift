//
//  File.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

/// The central registry of `ContextKeys` and their values.
public struct EnvironmentValues {
    
    /// The shared context store.
    public static var shared = EnvironmentValues()
    
    /// The underlying storage.
    private var dict: [String: Any] = [:]

    /// Get the value of a context key.
    /// - Important: It is a fatal error to create an `ImportedContext` for a key that has not been registered.
    public subscript<K: EnvironmentKey>(key: K.Type) -> K.Value {
        get {
            dict[K.dictKey] as? K.Value ?? K.defaultValue
        }
        
        set {
            dict[K.dictKey] = newValue
        }
    }

}
