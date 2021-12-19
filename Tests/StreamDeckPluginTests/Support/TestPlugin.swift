//
//  File.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation
import XCTest
@testable import StreamDeck

struct PluginCount: EnvironmentKey {
    static let defaultValue: Int = 0
}

class DemoIncrementAction: Action {
    static var name: String = "Increment"
    
    static var uuid: String = "counter.increment"
    
    static var icon: String = "Icons/plug"
    
    static var states: [PluginActionState] = []
    
    static var propertyInspectorPath: String?
    
    static var supportedInMultiActions: Bool?
    
    static var tooltip: String?
    
    static var visibleInActionsList: Bool?

    var context: String
    
    var coordinates: Coordinates
    
    @Environment(PluginCount.self) var count: Int
    
    required init(context: String, coordinates: Coordinates) {
        self.context = context
        self.coordinates = coordinates
    }
    
    func keyDown(device: String, payload: KeyEvent) {
        count += 1
    }

}

class TestPlugin: PluginDelegate {
    
    // MARK: Manifest
    static var name: String = "Test Plugin"
    
    static var description: String = "A plugin for testing."
    
    static var category: String? = nil
    
    static var categoryIcon: String? = nil
    
    static var author: String = "Emory Dunn"
    
    static var icon: String = "Icons/Test"
    
    static var url: URL? = nil
    
    static var version: String = "0.1"
    
    static var os: [PluginOS] = [.mac(minimumVersion: "10.15")]
    
    static var applicationsToMonitor: ApplicationsToMonitor? = nil
    
    static var software: PluginSoftware = .minimumVersion("4.1")
    
    static var sdkVersion: Int = 2
    
    static var codePath: String = TestPlugin.executableName
    
    static var codePathMac: String? = nil
    
    static var codePathWin: String? = nil
    
    let eventExp: XCTestExpectation
    
    @Environment(PluginCount.self) var count: Int
    
    static var actions: [Action.Type] = [
        DemoIncrementAction.self
    ]

    init(_ exp: XCTestExpectation) {
        self.eventExp = exp
    }
    
    required init() {
        fatalError("init(port:uuid:event:info:) has not been implemented")
    }
    
    func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent.Payload) {}
    
    func didReceiveGlobalSettings(_ settings: [String: String]) {}
    
    func willAppear(action: String, context: String, device: String, payload: AppearEvent) {}
    
    func willDisappear(action: String, context: String, device: String, payload: AppearEvent) {}
    
    func keyDown(action: String, context: String, device: String, payload: KeyEvent) {}
    
    func keyUp(action: String, context: String, device: String, payload: KeyEvent) {}
    
    func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo) {}
    
    func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) {}
    
    func deviceDidDisconnect(_ device: String) {}
    
    func applicationDidLaunch(_ application: String) {}
    
    func applicationDidTerminate(_ application: String) {}
    
    func systemDidWakeUp() {}
    
    func propertyInspectorDidAppear(action: String, context: String, device: String) {}
    
    func propertyInspectorDidDisappear(action: String, context: String, device: String) {}
    
    func sentToPlugin(context: String, action: String, payload: [String: String]) {}
    
 
}
