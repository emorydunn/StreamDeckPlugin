//
//  SharedKeyMacro.swift
//
//
//  Created by Emory Dunn on 8/14/23.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum MacroError: String, Error {
	case invalidCount
	case invalidName
	case invalidType
	case invalidDefaultValue
}

public protocol SharedKeyMacro: DeclarationMacro {

	static var inheritedType: TypeSyntax { get }

}

extension SharedKeyMacro {
	public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {

		// Check we have the requisite number of arguments
		guard node.argumentList.count == 3 else {
			throw MacroError.invalidCount
		}

		// Create an array so we can access the args by index
		let argumentList = node.argumentList.map { $0 }

		// Get the name from the first argument
		guard
			let nameSyntax = argumentList[0].expression.as(StringLiteralExprSyntax.self),
			let settingName = nameSyntax.representedLiteralValue
		else {
			throw MacroError.invalidName
		}

		// Get the default value from the second argument
		let defaultValue = InitializerClauseSyntax(value: argumentList[1].expression)

		// Get the default value type from the third argument
		let defaultType = argumentList[2]

		// Parse the type-name and create a syntax token
		let typeName = defaultType.expression.trimmed.description.replacingOccurrences(of: ".self", with: "")
		let settingType = TypeSyntax(stringLiteral: typeName)

		// Create the inheritance token
		let globSetKey = InheritanceClauseSyntax {
			InheritedTypeSyntax(type: inheritedType)
		}

		// Create the struct with default value
		let settingStruct = StructDeclSyntax(name: "\(raw: settingName.capitalized)") {
			VariableDeclSyntax(bindingSpecifier: "static let") {
				PatternBindingSyntax(
					pattern: PatternSyntax(stringLiteral: "defaultValue"),
					typeAnnotation: TypeAnnotationSyntax(type: settingType),
					initializer: defaultValue
				)
			}
		}
			.with(\.inheritanceClause, globSetKey) // Inherit from the key type

		/// Add the variable for accessing the property via key path
		let keyPathExt = try VariableDeclSyntax("var \(raw: settingName): \(raw: typeName)") {
			AccessorDeclSyntax(stringLiteral: "get { self[\(settingName.capitalized).self] }")
			AccessorDeclSyntax(stringLiteral: "set { self[\(settingName.capitalized).self] = newValue }")
		}

		// Return our tokens
		return [
			DeclSyntax(fromProtocol: settingStruct),
			DeclSyntax(fromProtocol: keyPathExt)
		]

	}
}
