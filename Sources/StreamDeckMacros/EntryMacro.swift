//
//  EntryMacro.swift
//  StreamDeck
//
//  Created by Emory Dunn on 1/27/25.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct EntryMacro {

	enum KeyType: String {
		case global = "GlobalSettings"
		case environment = "EnvironmentValues"

		var inheritedType: TypeSyntax {
			switch self {
			case .global:
				TypeSyntax("GlobalSettingKey")
			case .environment:
				TypeSyntax("EnvironmentKey")
			}
		}
	}

	static func identifier(of declaration: some DeclSyntaxProtocol) throws -> String {
		guard let variableDecl = declaration.as(VariableDeclSyntax.self),
			  let patternBinding = variableDecl.bindings.as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
			  let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
		else {
			throw MacroError.invalidName
		}

		return identifier
	}

	static func initializer(of declaration: some DeclSyntaxProtocol) throws -> InitializerClauseSyntax {
		guard let variableDecl = declaration.as(VariableDeclSyntax.self),
			  let patternBinding = variableDecl.bindings.as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
			  let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
			  let initializer = patternBinding.initializer
		else {
			throw MacroError.invalidDefaultValue
		}

		return initializer
	}

	static func extensionKey(of context: some MacroExpansionContext) throws -> KeyType {
		let extensionType = context.lexicalContext.first?
			.as(ExtensionDeclSyntax.self)?.extendedType
			.as(IdentifierTypeSyntax.self)

		guard
			let typeName = extensionType?.name.text,
			let key = KeyType(rawValue: typeName)
		else {
			throw MacroError.invalidExtension
		}

		return key

	}

}

extension EntryMacro: AccessorMacro {
	static func expansion(of node: AttributeSyntax, providingAccessorsOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext
	) throws -> [AccessorDeclSyntax] {

		let identifier = try identifier(of: declaration)

		let settingName = "__Key_\(identifier)"

		return [
			AccessorDeclSyntax(stringLiteral: "get { self[\(settingName).self] }"),
			AccessorDeclSyntax(stringLiteral: "set { self[\(settingName).self] = newValue }")
		]
	}
}

extension EntryMacro: PeerMacro {
	static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {

		let identifier = try identifier(of: declaration)
		let initializer = try initializer(of: declaration)
		let keyType = try extensionKey(of: context)

		let settingName = "__Key_\(identifier)"

		// Create the inheritance token
		let globSetKey = InheritanceClauseSyntax {
			InheritedTypeSyntax(type: keyType.inheritedType)
		}

		// Create the struct with default value
		let settingStruct = try StructDeclSyntax(name: "\(raw: settingName)") {

			// Create an override for the key name
			try VariableDeclSyntax("static let name = \"\(raw: settingName)\"")

			VariableDeclSyntax(bindingSpecifier: "static let") {
				PatternBindingSyntax(
					pattern: PatternSyntax(stringLiteral: "defaultValue"),
					initializer: initializer
				)
			}
		}
			.with(\.inheritanceClause, globSetKey) // Inherit from the key type

		return [
			DeclSyntax(settingStruct)
		]
	}
}
