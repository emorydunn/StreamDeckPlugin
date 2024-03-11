//
//  File.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation
import XCTest
@testable import StreamDeck
import SDPlusLayout

struct PluginCount: EnvironmentKey {
	static let defaultValue: Int = 0
}

extension EnvironmentValues {
	var count: Int {
		get { self[PluginCount.self] }
		set { self[PluginCount.self] = newValue }
	}
}

struct GlobalCount: GlobalSettingKey {
	static let defaultValue: Int = 0
}

extension GlobalSettings {
	var count: Int {
		get { self[GlobalCount.self] }
		set { self[GlobalCount.self] = newValue }
	}
}


class TestAction: Action {
	
	struct Settings: Codable, Hashable {
		let someKey: String
	}
	
	@GlobalSetting(\.count) var count
	
	static var name: String = "TestAction"
	
	static var uuid: String = "test.action"
	
	static var icon: String = "Icons/test"
	
	static var states: [PluginActionState]?
	
	static var controllers: [StreamDeck.ControllerType] = [.keypad]
	
	static var encoder: StreamDeck.RotaryEncoder? = nil
	
	static var propertyInspectorPath: String?
	
	static var supportedInMultiActions: Bool?
	
	static var tooltip: String?
	
	static var visibleInActionsList: Bool?
	
	static var userTitleEnabled: Bool?
	
	var context: String
	
	var coordinates: Coordinates?
	
	required init(context: String, coordinates: Coordinates?) {
		self.context = context
		self.coordinates = coordinates
	}
	
	func keyDown(device: String, payload: KeyEvent<Settings>) {
		
	}
	
}

class TestPlugin: Plugin {
	
	// MARK: Manifest
	static var name: String = "Test Plugin"
	
	static var description: String = "A plugin for testing."
	
	static var category: String? = nil
	
	static var categoryIcon: String? = nil
	
	static var author: String = "Emory Dunn"
	
	static var icon: String = "Icons/Test"
	
	static var url: URL? = nil
	
	static var version: String = "0.1"
	
	static var os: [PluginOS] = [.macOS(.v11)]
	
	static var applicationsToMonitor: ApplicationsToMonitor? = nil
	
	static var software: PluginSoftware = .minimumVersion("4.1")
	
	static var sdkVersion: Int = 2
	
	static var codePath: String = TestPlugin.executableName
	
	static var codePathMac: String? = nil
	
	static var codePathWin: String? = nil
	
	let eventExp: XCTestExpectation
	
	static var actions: [any Action.Type] = [
		
	]

	static var layouts: [Layout] {
		Layout(id: "test") {
			
		}
	}

	init(_ exp: XCTestExpectation) {
		self.eventExp = exp
	}
	
	required init() {
		fatalError("init(port:uuid:event:info:) has not been implemented")
	}
	
	func didReceiveGlobalSettings() {}

	func didReceiveDeepLink(_ url: URL) { }

	func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) {}
	
	func deviceDidDisconnect(_ device: String) {}
	
	func applicationDidLaunch(_ application: String) {}
	
	func applicationDidTerminate(_ application: String) {}
	
	func systemDidWakeUp() {}
	
	func propertyInspectorDidAppear(action: String, context: String, device: String) {}
	
	func propertyInspectorDidDisappear(action: String, context: String, device: String) {}
	
}
