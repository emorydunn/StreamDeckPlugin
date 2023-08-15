//
//  File.swift
//  
//
//  Created by Emory Dunn on 8/15/23.
//

import Foundation

@freestanding(declaration, names: arbitrary)
public macro globalSetting<T>(_ name: String, defaultValue value: T, ofType: T.Type) = #externalMacro(module: "StreamDeckMacros",
																									  type: "GlobalSettingsMacro")
