//
//  File.swift
//  
//
//  Created by Emory Dunn on 11/30/22.
//

import Foundation

public extension PluginDelegate {

	// MARK: - Events Received

	func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent<NoSettings>.Payload) { }

	func didReceiveGlobalSettings(_ settings: [String: String]) { }

	func didReceiveGlobalSettings(_ settings: Settings) { }

	func willAppear(action: String, context: String, device: String, payload: AppearEvent<NoSettings>) { }

	func willDisappear(action: String, context: String, device: String, payload: AppearEvent<NoSettings>) { }

	func keyDown(action: String, context: String, device: String, payload: KeyEvent<NoSettings>) { }

	func keyUp(action: String, context: String, device: String, payload: KeyEvent<NoSettings>) { }

	func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo<NoSettings>) { }

	func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) { }

	func deviceDidDisconnect(_ device: String) { }

	func applicationDidLaunch(_ application: String) { }

	func applicationDidTerminate(_ application: String) { }

	func systemDidWakeUp() { }

	func propertyInspectorDidAppear(action: String, context: String, device: String) { }

	func propertyInspectorDidDisappear(action: String, context: String, device: String) { }

	func sentToPlugin(context: String, action: String, payload: [String: String]) { }

}
