import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MacroSettingsTestMacros)
import MacroSettingsTestMacros

let testMacros: [String: Macro.Type] = [
	"globalSetting": SettingsExtension.self,
]
#endif

final class SettingsMacroTests: XCTestCase {
	func testSettingsMacro() throws {
		#if canImport(MacroSettingsTestMacros)
		assertMacroExpansion(
			"""
			#globalSetting("count", defaultValue: 42, ofType: Int.self)
			""",
			expandedSource: """
			struct Count: GlobalSettingKey {
			    static let defaultValue: Int = 42
			}
			var count: Int {
			    get {
			        self [Count.self]
			    }
			    set {
			        self [Count.self] = newValue
			    }
			}
			""",
			macros: testMacros
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}

	func testEnvMacro() throws {
		#if canImport(MacroSettingsTestMacros)
		assertMacroExpansion(
			"""
			#globalSetting("color", defaultValue: "#FFF", ofType: String.self)
			""",
			expandedSource: """
			struct Color: EnvironmentKey {
			   static let defaultValue: String = "#FFF"
			}
			var color: String {
			   get {
			       self [Color.self]
			   }
			   set {
			       self [Color.self] = newValue
			   }
			}
			""",
			macros: testMacros
		)
		#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
		#endif
	}

}
