//
//  SettingsMacros.swift
//  
//
//  Created by Emory Dunn on 8/15/23.
//

import Foundation

#if swift(>=5.9)
@available(*, deprecated, message: "Please use the @Entry() macro.")
@freestanding(declaration, names: arbitrary)
public macro globalSetting<T>(_ name: String, defaultValue value: T, ofType: T.Type) = #externalMacro(module: "StreamDeckMacros", type: "GlobalSettingsMacro")

@available(*, deprecated, message: "Please use the @Entry() macro.")
@freestanding(declaration, names: arbitrary)
public macro environmentKey<T>(_ name: String, defaultValue value: T, ofType: T.Type) = #externalMacro(module: "StreamDeckMacros", type: "EnvironmentMacro")

@attached(accessor)
@attached(peer, names: prefixed(__Key_))
public macro Entry() = #externalMacro(module: "StreamDeckMacros", type: "EntryMacro")
#endif
