//
//  Delegate+Received.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "PluginDefaults")

public extension Plugin {
	
	// MARK: - Events Received
	
	func didReceiveGlobalSettings() { }

	func didReceiveDeepLink(_ url: URL) { }

	func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) { }
	
	func deviceDidDisconnect(_ device: String) { }
	
	func applicationDidLaunch(_ application: String) { }
	
	func applicationDidTerminate(_ application: String) { }
	
	func systemDidWakeUp() { }
	
	func propertyInspectorDidAppear(action: String, context: String, device: String) { }
	
	func propertyInspectorDidDisappear(action: String, context: String, device: String) { }

	// MARK: Errors
	func eventError<E: Error>(_ error: E, data: Data) {
		if error is DecodingError {
			let json = String(decoding: data, as: UTF8.self)

			log.error("""
			Error decoding event:
			\(error, privacy: .public)
			\(json, privacy: .public)
			""")
		} else {
			let json = String(decoding: data, as: UTF8.self)
			log.error("\(error.localizedDescription, privacy: .public)\n\(json, privacy: .public)")
		}
	}

}
