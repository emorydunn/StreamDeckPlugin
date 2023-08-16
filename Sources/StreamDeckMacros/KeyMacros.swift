//
//  GlobalSettings.swift
//
//
//  Created by Emory Dunn on 8/14/23.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct GlobalSettingsMacro: SharedKeyMacro {

	public static let inheritedType = TypeSyntax("GlobalSettingKey")

}

public struct EnvironmentMacro: SharedKeyMacro {

	public static let inheritedType = TypeSyntax("EnvironmentKey")

}

