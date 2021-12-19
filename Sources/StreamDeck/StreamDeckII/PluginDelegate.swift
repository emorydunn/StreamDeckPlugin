//
//  PluginDelegate.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

public protocol PluginDelegate {
    
    // MARK: Streamdeck Properties
    
    /// The port that should be used to create the WebSocket
    var port: Int32  { get }
    
    /// A unique identifier string that should be used to register the plugin once the WebSocket is opened.
    var uuid: String  { get }
    
    /// The event type that should be used to register the plugin once the WebSocket is opened
    var event: String  { get }

    /// The Stream Deck application information and devices information.
    var info: PluginRegistrationInfo  { get }
    
    var instanceManager: InstanceManagerII { get }
    
    // MARK: Plugin Properties

    /// The name of the plugin.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    var name: String { get }

    var actions: [Action.Type] { get }
    
    init(port: Int32, uuid: String, event: String, info: PluginRegistrationInfo)
    
    // MARK: Events Received
    
    func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent.Payload)
    func didReceiveGlobalSettings(_ settings: [String: String])
    func willAppear(action: String, context: String, device: String, payload: AppearEvent)
    func willDisappear(action: String, context: String, device: String, payload: AppearEvent)
    func keyDown(action: String, context: String, device: String, payload: KeyEvent)
    func keyUp(action: String, context: String, device: String, payload: KeyEvent)
    func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo)
    func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo)
    func deviceDidDisconnect(_ device: String)
    func applicationDidLaunch(_ application: String)
    func applicationDidTerminate(_ application: String)
    func systemDidWakeUp()
    func propertyInspectorDidAppear(action: String, context: String, device: String)
    func propertyInspectorDidDisappear(action: String, context: String, device: String)
    func sentToPlugin(context: String, action: String, payload: [String: String])
}

extension PluginDelegate {
    static func main() {
        
    }
}

extension PluginDelegate {
    
    // MARK: - Events Received
    
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
    
    
    func parseEvent(event: ReceivableEvent.EventKey, data: Data) throws {
        
        let decoder = JSONDecoder()

        switch event {
            
        case .didReceiveSettings:
            let action = try decoder.decode(SettingsEvent.self, from: data)
            self.didReceiveSettings(action: action.action, context: action.context, device: action.device, payload: action.payload)
        case .didReceiveGlobalSettings:
            let action = try decoder.decode(GlobalSettingsEvent.self, from: data)
            self.didReceiveGlobalSettings(action.payload.settings)
        case .keyDown:
            let action = try decoder.decode(ActionEvent<KeyEvent>.self, from: data)
            self.keyDown(action: action.action, context: action.context, device: action.context, payload: action.payload)
        
        case .keyUp:
            let action = try decoder.decode(ActionEvent<KeyEvent>.self, from: data)
            self.keyUp(action: action.action, context: action.context, device: action.context, payload: action.payload)
            self.instanceManager[action.context]?.keyUp(device: action.device, payload: action.payload)
        
        case .willAppear:
            let action = try decoder.decode(ActionEvent<AppearEvent>.self, from: data)
            self.instanceManager.registerInstance(action)
            self.willAppear(action: action.action, context: action.context, device: action.device, payload: action.payload)
        
        case .willDisappear:
            let action = try decoder.decode(ActionEvent<AppearEvent>.self, from: data)
            self.instanceManager.removeInstance(action)
            self.willDisappear(action: action.action, context: action.context, device: action.device, payload: action.payload)
        
        case .titleParametersDidChange:
            let action = try decoder.decode(ActionEvent<TitleInfo>.self, from: data)
            self.titleParametersDidChange(action: action.action, context: action.context, device: action.device, info: action.payload)
            
        case .deviceDidConnect:
            let action = try decoder.decode(DeviceConnectionEvent.self, from: data)
            self.deviceDidConnect(action.device, deviceInfo: action.deviceInfo!)
            
        case .deviceDidDisconnect:
            let action = try decoder.decode(DeviceConnectionEvent.self, from: data)
            self.deviceDidDisconnect(action.device)
            
        case .systemDidWakeUp:
            self.systemDidWakeUp()
            
        case .applicationDidLaunch:
            let action = try decoder.decode(ApplicationEvent.self, from: data)
            self.applicationDidLaunch(action.payload.application)
        
        case .applicationDidTerminate:
            let action = try decoder.decode(ApplicationEvent.self, from: data)
            self.applicationDidTerminate(action.payload.application)
            
        case .propertyInspectorDidAppear:
            let action = try decoder.decode(PropertyInspectorEvent.self, from: data)
            self.propertyInspectorDidAppear(action: action.action, context: action.context, device: action.device)
        
        case .propertyInspectorDidDisappear:
            let action = try decoder.decode(PropertyInspectorEvent.self, from: data)
            self.propertyInspectorDidDisappear(action: action.action, context: action.context, device: action.device)
        
        case .sendToPlugin:
            let action = try decoder.decode(SendToPluginEvent.self, from: data)
            self.sentToPlugin(context: action.context, action: action.action, payload: action.payload)
        }
    }

}


