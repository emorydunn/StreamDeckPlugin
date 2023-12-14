//
//  Plugin.swift
//  
//
//  Created by Emory Dunn on 8/14/23.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroSettingsTestPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		GlobalSettingsMacro.self,
		EnvironmentMacro.self
	]
}
