//
//  Delegate+Received.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

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
	
}
