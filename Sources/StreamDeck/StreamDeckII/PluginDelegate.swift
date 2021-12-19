//
//  PluginDelegate.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

public protocol PluginDelegate {

    // MARK: Manifest
    
    /// The name of the plugin.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    static var name: String { get }

    /// Provides a general description of what the plugin does.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    static var description: String { get }

    /// The name of the custom category in which the actions should be listed.
    ///
    /// This string is visible to the user in the actions list. If you don't provide a category, the actions will appear inside a "Custom" category.
    static var category: String? { get }

    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is used in the actions list. The PNG image should be a 28pt x 28pt image.
    /// You should provide @1x and @2x versions of the image.
    /// The Stream Deck application takes care of loading the appropriate version of the image.
    static var categoryIcon: String? { get }

    /// The author of the plugin.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    static var author: String { get }

    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is displayed in the Plugin Store window. The PNG image should be a 72pt x 72pt image.
    /// You should provide @1x and @2x versions of the image.
    /// The Stream Deck application takes care of loading the appropriate version of the image.
    static var icon: String { get }

    /// A URL displayed to the user if he wants to get more info about the plugin.
    static var url: URL? { get }

    /// The version of the plugin which can only contain digits and periods.
    ///
    /// This is used for the software update mechanism.
    static var version: String { get }

    /// The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
    static var os: [PluginOS] { get }

    /// List of application identifiers to monitor (applications launched or terminated).
    ///
    /// See the [applicationDidLaunch][launch] and [applicationDidTerminate][term] events.
    ///
    /// [launch]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidlaunch
    /// [term]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidterminate
    static var applicationsToMonitor: ApplicationsToMonitor? { get }

    /// Indicates which version of the Stream Deck application is required to install the plugin.
    static var software: PluginSoftware { get }

    /// This value should be set to 2.
    static var sdkVersion: Int { get }

    /// The relative path to the HTML/binary file containing the code of the plugin.
    static var codePath: String { get }

    /// Override CodePath for macOS.
    static var codePathMac: String? { get }

    /// Override CodePath for Windows.
    static var codePathWin: String? { get }
    
    // MARK: Streamdeck Properties
    
    /// The port that should be used to create the WebSocket
    var port: Int32  { get }
    
    /// A unique identifier string that should be used to register the plugin once the WebSocket is opened.
    var uuid: String  { get }
    
    /// The event type that should be used to register the plugin once the WebSocket is opened
    var event: String  { get }

    /// The Stream Deck application information and devices information.
    var info: PluginRegistrationInfo  { get }
    
    // MARK: Plugin Properties
    
    var instanceManager: InstanceManagerII { get }

    static var actions: [Action.Type] { get }
    
    init(port: Int32, uuid: String, event: String, info: PluginRegistrationInfo, instanceManager: InstanceManagerII)
    
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

public extension PluginDelegate {
    
    static func main() {
        PluginManager.plugin = self
        PluginManager.main()
    }
    
    /// Determine the CodePath for the plugin based on the bundles executable's name.
    static var executableName: String {
        Bundle.main.executableURL!.lastPathComponent
    }
}

public extension PluginDelegate {
    
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


