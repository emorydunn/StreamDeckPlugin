//
//  StreamDeckPlugin.swift
//  
//
//  Created by Emory Dunn on 7/25/21.
//

import Foundation
import Cocoa
import Combine


/// The base class for building Stream Deck plugins.
///
/// The WebSocket connection and plugin registration procedure are handled automatically.
open class StreamDeckPlugin {
    
    // MARK: Shared Plugin
    
    /// The shared plugin instance
    public static var shared: StreamDeckPlugin?
    
    // MARK: Connection Properties
    
    /// Storage for Combine tokens.
    public var tokens: [AnyCancellable] = []
    
    /// The underlying WebSocket task
    let task: WebSocketTaskPublisher
    
    /// The queue used for WebSocket subscriptions
    let backgroundQueue = DispatchQueue(label: "WebSocketQueue", qos: .userInteractive)
    
    // MARK: Plugin Properties
    
    /// The port that should be used to create the WebSocket
    public var port: Int32
    
    /// A unique identifier string that should be used to register the plugin once the WebSocket is opened.
    public var uuid: String
    
    /// The event type that should be used to register the plugin once the WebSocket is opened
    public var event: String

    /// A stringified json containing the Stream Deck application information and devices information.
    public var info: String
//    /// The properties sent from the Stream Deck application during init.
//    public let properties: PluginProperties
    
    /// Known action instances
    public let instanceManager = InstanceManager()
    
    /// Create a new plugin object.
    /// - Parameter properties: Properties from the Stream Deck application.
    /// - Throws: Errors while registering the plugin.
    public required init(port: Int32, uuid: String, event: String, info: String) throws {
//        self.properties = properties
        self.port = port
        self.uuid = uuid
        self.event = event
        self.info = info
        
        let url = URL(string: "ws://localhost:\(port)")!
        
        NSLog("Starting connection with \(url)")
        
        self.task = URLSession.shared.webSocketTaskPublisher(for: url)
        
        monitorSocket()
        
        try registerPlugin()

    }
    
    // MARK: Connections
    
    /// Connect to the Web Socket, watch for events, and parse the actions.
    func monitorSocket() {
        NSLog("Beginning to monitor socket")
        
        let decoder = JSONDecoder()
        
        task
            .subscribe(on: backgroundQueue)
            .compactMap { message in
                switch message {
                case let .data(data):
                    return data
                case let .string(string):
                    return string.data(using: .utf8)
                @unknown default:
                    return nil
                }
            }
            .tryMap { data in
                (try JSONDecoder().decode(ReceivableEvent.self, from: data).event, data)
            }
            .catch { fail -> Just<(ReceivableEvent.EventKey, Data)?> in
                NSLog("ERROR: \(fail.localizedDescription)")
                
                return Just(nil)
            }
            .compactMap { $0 }
            .sink { (event, data) in
                
                do {
                    switch event {
                    case .keyDown:
                        try JSONSerialization.jsonObject(with: data, options: [])
                        
                        let action = try decoder.decode(ActionEvent<KeyEvent>.self, from: data)
                        self.keyDown(action: action.action, context: action.context, device: action.context, payload: action.payload)
                    
                    case .keyUp:
                        let action = try decoder.decode(ActionEvent<KeyEvent>.self, from: data)
                        self.keyUp(action: action.action, context: action.context, device: action.context, payload: action.payload)
                    
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
                        let action = try decoder.decode(ActionEvent<DeviceInfo>.self, from: data)
                        self.deviceDidConnect(action.device, deviceInfo: action.payload)
                        
                    case .deviceDidDisconnect:
                        let action = try decoder.decode(ActionEvent<DeviceInfo?>.self, from: data)
                        self.deviceDidDisconnect(action.device)
                    
                    default:
                        NSLog("Unsupported action \(event.rawValue)")
                    }
                } catch {
                    NSLog("Failed to decode data for event \(event)")
                    NSLog(error.localizedDescription)
                    NSLog("\(error)")
                    NSLog(String(data: data, encoding: .utf8)!)
                }
                
            }
            .store(in: &tokens)
    }
    
    // MARK: - Events
    
    /// Send raw events over the the socket.
    ///
    /// - Parameters:
    ///   - eventType: The event type.
    ///   - context: The context token.
    ///   - payload: The payload for the action.
    /// - Throws: Errors while encoding the data to JSON.
    func sendEvent(_ eventType: SendableEventKey, context: String?, payload: [String: Any]?) {
        
        var event: [String: Any] = [
            "event": eventType.rawValue
        ]
        
        event["context"] = context
        event["payload"] = payload
        
        guard JSONSerialization.isValidJSONObject(event) else {
            NSLog("Data for \(eventType.rawValue) is not valid JSON.")
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: event, options: [])
            
            task.send(URLSessionWebSocketTask.Message.data(data)) { error in
                if let error = error {
                    NSLog("ERROR: Failed to send \(eventType.rawValue) event.")
                    NSLog(error.localizedDescription)
                } else {
                    NSLog("Completed \(eventType.rawValue)")
                }
            }
        } catch {
            NSLog("ERROR: \(error.localizedDescription).")
        }

    }
    
    // MARK: Sent
    
    /// Complete the registration handshake with the server,
    /// - Parameter properties: The properties provided by the Stream Deck application.
    /// - Throws: Errors while encoding the data to JSON.
    func registerPlugin() throws {
        let registrationEvent: [String: Any] = [
            "event": event,
            "uuid": uuid
        ]
        
        guard JSONSerialization.isValidJSONObject(event) else {
            throw StreamDeckError.invlaidJSON(event, registrationEvent)
        }
        
        let data = try JSONSerialization.data(withJSONObject: event, options: [])
        
        task.task.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                NSLog("ERROR: Failed to send \(self.event) event.")
                NSLog(error.localizedDescription)
            }
        }

    }
    
    /// Save data persistently for the action's instance.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - settings: A json object which is persistently saved for the action's instance.
    public func setSettings(in context: String, to settings: [String: Any]) {
        sendEvent(.setSettings,
                      context: context,
                      payload: settings)
    }
    
    /// Request the persistent data for the action's instance.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    public func getSettings(in context: String) {
        sendEvent(.getSettings,
                      context: context,
                      payload: nil)
    }
    
    /// Save data securely and globally for the plugin.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - settings: A json object which is persistently saved globally.
    public func setGlobalSettings(in context: String, to settings: [String: Any]) {
        sendEvent(.setGlobalSettings,
                      context: context,
                      payload: settings)
    }
    
    /// Request the global persistent data.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    public func getGloablSettings(in context: String) {
        sendEvent(.getGlobalSettings,
                      context: context,
                      payload: nil)
    }
    
    /// Open an URL in the default browser.
    /// - Parameter url: The URL to open
    public func openURL(_ url: URL) {
        sendEvent(.openURL,
                      context: nil,
                      payload: ["url": url.path])
    }
    
    /// Write a debug log to the logs file.
    /// - Parameter message: A string to write to the logs file.
    public func logMessage(_ message: String) {
        NSLog("EVENT: Sending log message: \(message)")
        sendEvent(.logMessage, context: nil, payload: ["message": message])
    }
    
    /// Dynamically change the title of an instance of an action.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - title: The title to display. If there is no title parameter, the title is reset to the title set by the user.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    public func setTitle(in context: String, to title: String?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        payload["title"] = title
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        sendEvent(.setTitle,
                      context: context,
                      payload: payload)
    }
    
    /// Dynamically change the image displayed by an instance of an action.
    ///
    /// The image is automatically encoded to a prefixed base64 string.
    ///
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - image: An image to display.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    public func setImage(in context: String, to image: NSImage?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        payload["image"] = image?.base64String
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        sendEvent(.setImage,
                      context: context,
                      payload: payload)
    }
    
//    func setTitle(to string: String, target: Target? = nil, state: Int? = nil) throws {
//        try knownContexts.forEach { context in
//            try setTitle(to: string, in: context, target: target, state: state)
//        }
//    }
    
    /// Temporarily show an alert icon on the image displayed by an instance of an action.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    public func showAlert(in context: String) {
        sendEvent(.showAlert, context: context, payload: nil)
    }
    
    /// Temporarily show an OK checkmark icon on the image displayed by an instance of an action.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    public func showOk(in context: String) {
        sendEvent(.showOK, context: context, payload: nil)
    }
    
    /// Change the state of the action's instance supporting multiple states.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    public func setState(in context: String, to state: Int) {
        let payload: [String: Any] = ["state": state]

        sendEvent(.setState,
                      context: context,
                      payload: payload)
    }
    
    /// Switch to one of the preconfigured read-only profiles.
    /// - Parameter name: The name of the profile to switch to. The name should be identical to the name provided in the manifest.json file.
    public func switchToProfile(named name: String) {
        let payload: [String: Any] = ["profile": name]
        // FIXME: Add Device

        sendEvent(.switchToProfile,
                      context: uuid,
                      payload: payload)
    }
    
    /// Send a payload to the Property Inspector.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - action: The action unique identifier.
    ///   - payload: A json object that will be received by the Property Inspector.
    public func sendToPropertyInspector(in context: String, action: String, payload: [String: Any]) {
//        let payload: [String: Any] = ["profile": name]
        // FIXME: Add action

        sendEvent(.sendToPropertyInspector,
                      context: context,
                      payload: payload)
    }
    
    /// Send a payload to the plugin.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - action: The action unique identifier. If your plugin supports multiple actions, you should use this value to find out which action was triggered.
    ///   - payload: A json object that will be received by the plugin.
    public func sendToPlugin(in context: String, action: String, payload: [String: Any]) {
//        let payload: [String: Any] = ["profile": name]
        // FIXME: Add action

        sendEvent(.sendToPlugin,
                      context: context,
                      payload: payload)
    }
    
    // MARK: Received
    /// When an instance of an action is displayed on the Stream Deck, for example when the hardware is first plugged in, or when a folder containing that action is entered, the plugin will receive a `willAppear` event.
    ///
    /// You will see such an event when:
    /// - the Stream Deck application is started
    /// - the user switches between profiles
    /// - the user sets a key to use your action
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    open func willAppear(action: String, context: String, device: String, payload: AppearEvent) {
        
    }
    
    /// When an instance of an action ceases to be displayed on Stream Deck, for example when switching profiles or folders, the plugin will receive a `willDisappear` event.
    ///
    /// You will see such an event when:
    /// - the user switches between profiles
    /// - the user deletes an action
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    open func willDisappear(action: String, context: String, device: String, payload: AppearEvent) {
        
    }
    
    /// When the user presses a key, the plugin will receive the `keyDown` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    open func keyDown(action: String, context: String, device: String, payload: KeyEvent) {
        
    }

    
    /// When the user releases a key, the plugin will receive the `keyUp` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    open func keyUp(action: String, context: String, device: String, payload: KeyEvent) {
        
    }
    
    /// When the user changes the title or title parameters of the instance of an action, the plugin will receive a `titleParametersDidChange` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    open func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo) {
        
    }
    
    /// When a device is plugged to the computer, the plugin will receive a `deviceDidConnect` event.
    /// - Parameters:
    ///   - action: The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    open func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) {
        
    }
    
    /// When a device is unplugged from the computer, the plugin will receive a `deviceDidDisconnect` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    open func deviceDidDisconnect(_ device: String) {
        
    }
    
    /// A plugin can request in its manifest.json to be notified when some applications are launched or terminated.
    ///
    /// In order to do so, the manifest.json should contain an `ApplicationsToMonitor` object specifying the list of application identifiers to monitor.
    /// On macOS the application bundle identifier is used while the exe filename is used on Windows.
    /// - Parameter application: The identifier of the application that has been launched.
    open func applicationDidLaunch(_ application: String) {
        
    }
    
    /// A plugin can request in its manifest.json to be notified when some applications are launched or terminated.
    ///
    /// In order to do so, the manifest.json should contain an `ApplicationsToMonitor` object specifying the list of application identifiers to monitor.
    /// On macOS the application bundle identifier is used while the exe filename is used on Windows.
    /// - Parameter application: The identifier of the application that has been launched.
    open func applicationDidTerminate(_ application: String) {
        
    }
    
    /// When the computer is wake up, the plugin will receive the `systemDidWakeUp` event.
    open func systemDidWakeUp() {
        
    }
    
    
}
