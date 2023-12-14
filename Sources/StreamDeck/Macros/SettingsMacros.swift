//
//  SettingsMacros.swift
//  
//
//  Created by Emory Dunn on 8/15/23.
//

import Foundation

#if swift(>=5.9)
@freestanding(declaration, names: arbitrary)
public macro globalSetting<T>(_ name: String, defaultValue value: T, ofType: T.Type) = #externalMacro(module: "StreamDeckMacros", type: "GlobalSettingsMacro")

@freestanding(declaration, names: arbitrary)
public macro environmentKey<T>(_ name: String, defaultValue value: T, ofType: T.Type) = #externalMacro(module: "StreamDeckMacros", type: "EnvironmentMacro")
#endif
