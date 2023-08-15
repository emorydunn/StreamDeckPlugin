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

enum MacroError: String, Error {
	case invalidCount
	case invalidName
	case invalidType
	case invalidDefaultValue
}

public struct GlobalSettingsMacro: DeclarationMacro {

	public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {


		guard node.argumentList.count == 3 else {
			throw MacroError.invalidCount
		}


		let argumentList = node.argumentList.map { $0 }

		guard
			let nameSyntax = argumentList[0].expression.as(StringLiteralExprSyntax.self),
			let settingName = nameSyntax.representedLiteralValue
		else {
			throw MacroError.invalidName
		}

		let defaultValue = InitializerClauseSyntax(value: argumentList[1].expression)
		let defaultType = argumentList[2]

		let typeName = defaultType.expression.trimmed.description.replacingOccurrences(of: ".self", with: "")
		let settingType = TypeSyntax(stringLiteral: typeName)

		let globSetKey = InheritanceClauseSyntax {
			InheritedTypeSyntax(type: TypeSyntax("GlobalSettingKey"))
		}

		let settingStruct = StructDeclSyntax(name: "\(raw: settingName.capitalized)") {
			VariableDeclSyntax(bindingSpecifier: "static let") {
				PatternBindingSyntax(
					pattern: PatternSyntax(stringLiteral: "defaultValue"),
					typeAnnotation: TypeAnnotationSyntax(type: settingType),
					initializer: defaultValue
				)
			}
		}
			.with(\.inheritanceClause, globSetKey)


		let keyPathExt = try VariableDeclSyntax("var \(raw: settingName): \(raw: typeName)") {
			AccessorDeclSyntax(stringLiteral: "get { self[\(settingName.capitalized).self] }")
			AccessorDeclSyntax(stringLiteral: "set { self[\(settingName.capitalized).self] = newValue }")
		}

		return [
			DeclSyntax(fromProtocol: settingStruct),
			DeclSyntax(fromProtocol: keyPathExt)
		]

	}

}

