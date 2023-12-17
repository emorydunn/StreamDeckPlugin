//
//  TestEvent.swift
//
//
//  Created by Emory Dunn on 10/31/21.
//

import Foundation

struct TestEvent {
	
	static let shared = TestEvent()
	
	let eventsWrapper: FileWrapper
	
	init() {
		
		guard let eventsURL = Bundle.module.url(forResource: "Test Events", withExtension: nil) else {
			fatalError("Failed to locate 'Test Events' folder in '\(Bundle.module.bundleURL.path)'.")
		}
		
		do {
			self.eventsWrapper = try FileWrapper(url: eventsURL)
		} catch {
			fatalError("Failed to load test events.")
		}
		
	}
	
	func data(for fileName: String) -> Data {
		guard let data = eventsWrapper.fileWrappers?[fileName]?.regularFileContents else {
			fatalError("Failed to read contents of '\(fileName)'.")
		}
		
		return data
	}
	
	static var registrationInfo: String = {
		let data = TestEvent.shared.data(for: "registrationInfo.json")
		return String(data: data, encoding: .utf8)!
	}()
	static var didReceiveSettings: Data = {
		TestEvent.shared.data(for: "didReceiveSettings.json")
	}()
	static var didReceiveGlobalSettings: Data = {
		TestEvent.shared.data(for: "didReceiveGlobalSettings.json")
	}()
	static var keyUp: Data = {
		TestEvent.shared.data(for: "keyUp.json")
	}()
	static var keyDown: Data = {
		TestEvent.shared.data(for: "keyDown.json")
	}()
	static var willAppear: Data = {
		TestEvent.shared.data(for: "willAppear.json")
	}()
	static var willDisappear: Data = {
		TestEvent.shared.data(for: "willDisappear.json")
	}()
	static var titleParametersDidChange: Data = {
		TestEvent.shared.data(for: "titleParametersDidChange.json")
	}()
	static var deviceDidConnect: Data = {
		TestEvent.shared.data(for: "deviceDidConnect.json")
	}()
	static var deviceDidDisconnect: Data = {
		TestEvent.shared.data(for: "deviceDidDisconnect.json")
	}()
	static var systemDidWakeUp: Data = {
		TestEvent.shared.data(for: "systemDidWakeUp.json")
	}()
	static var applicationDidLaunch: Data = {
		TestEvent.shared.data(for: "applicationDidLaunch.json")
	}()
	static var applicationDidTerminate: Data = {
		TestEvent.shared.data(for: "applicationDidTerminate.json")
	}()
	static var propertyInspectorDidAppear: Data = {
		TestEvent.shared.data(for: "propertyInspectorDidAppear.json")
	}()
	static var propertyInspectorDidDisappear: Data = {
		TestEvent.shared.data(for: "propertyInspectorDidDisappear.json")
	}()
	static var sendToPlugin: Data = {
		TestEvent.shared.data(for: "sendToPlugin.json")
	}()
	
}
