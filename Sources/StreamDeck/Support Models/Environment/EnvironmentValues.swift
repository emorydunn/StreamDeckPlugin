//
//  EnvironmentValues.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

/// The central registry of `EnvironmentKey` and their values.
public struct EnvironmentValues {
    
    /// The shared context store.
    public static var shared = EnvironmentValues()
    
    /// The underlying storage.
    private var dict: [String: Any] = [:]

    /// Get the value of a context key.
    public subscript<K: EnvironmentKey>(key: K.Type) -> K.Value {
        get {
            dict[K.dictKey] as? K.Value ?? K.defaultValue
        }
        
        set {
            dict[K.dictKey] = newValue
        }
    }

}
