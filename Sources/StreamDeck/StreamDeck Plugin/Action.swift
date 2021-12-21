//
//  Action.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation
import AppKit

public protocol Action {

    // MARK: - Action Properties
    
    /// The name of the action. This string is visible to the user in the actions list.
    static var name: String { get }
    
    /// The unique identifier of the action.
    ///
    /// It must be a uniform type identifier (UTI) that contains only lowercase alphanumeric characters (a-z, 0-9), hyphen (-), and period (.).
    ///
    /// The string must be in reverse-DNS format.
    ///
    /// For example, if your domain is elgato.com and you create a plugin named Hello with the action My Action, you could assign the string com.elgato.hello.myaction as your action's Unique Identifier.
    static var uuid: String { get }
    
    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is displayed in the actions list. The PNG image should be a 20pt x 20pt image. You should provide @1x and @2x versions of the image.
    /// The Stream Deck application take care of loaded the appropriate version of the image.
    ///
    /// - Note: This icon is not required for actions not visible in the actions list (`VisibleInActionsList` set to false).
    static var icon: String { get }
    
    /// Specifies an array of states.
    ///
    /// Each action can have one state or 2 states (on/off).
    ///
    /// For example the Hotkey action has a single state. However the Game Capture Record action has 2 states, active and inactive.
    ///
    /// The state of an action, supporting multiple states, is always automatically toggled whenever the action's key is released (after being pressed).
    ///
    /// In addition, it is possible to force the action to switch its state by sending a `setState` event.
    ///
    /// - Note: If no states are specified the manifest will generate a single state using the `Action`'s icon. 
    static var states: [PluginActionState]? { get }
    
    /// This can override PropertyInspectorPath member from the plugin if you wish to have different PropertyInspectorPath based on the action.
    ///
    /// The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
    static var propertyInspectorPath: String? { get }
    
    /// Boolean to prevent the action from being used in a Multi Action.
    ///
    /// True by default.
    static var supportedInMultiActions: Bool? { get }
    
    
    /// The string displayed as tooltip when the user leaves the mouse over your action in the actions list.
    static var tooltip: String? { get }
    
    /// Boolean to hide the action in the actions list.
    ///
    /// This can be used for plugin that only works with a specific profile. True by default.
    static var visibleInActionsList: Bool? { get }
    
    // MARK: - Instance Properties

    /// The context value for the instance.
    var context: String { get }
    
    /// The coordinates of the instance.
    var coordinates: Coordinates { get }
    
    init(context: String, coordinates: Coordinates)
    
    // MARK: - Events
    
    /// Event received after calling the `getSettings` API to retrieve the persistent data stored for the action.
    func didReceiveSettings(device: String, payload: SettingsEvent.Payload)
    
    /// When an instance of an action is displayed on the Stream Deck, for example when the hardware is first plugged in, or when a folder containing that action is entered, the plugin will receive a `willAppear` event.
    ///
    /// You will see such an event when:
    /// - the Stream Deck application is started
    /// - the user switches between profiles
    /// - the user sets a key to use your action
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func willAppear(device: String, payload: AppearEvent)
    
    /// When an instance of an action ceases to be displayed on Stream Deck, for example when switching profiles or folders, the plugin will receive a `willDisappear` event.
    ///
    /// You will see such an event when:
    /// - the user switches between profiles
    /// - the user deletes an action
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func willDisappear(device: String, payload: AppearEvent)
    
    /// When the user presses a key, the plugin will receive the `keyDown` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func keyDown(device: String, payload: KeyEvent)
    
    /// When the user releases a key, the plugin will receive the `keyUp` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func keyUp(device: String, payload: KeyEvent)
    
    /// When the user changes the title or title parameters of the instance of an action, the plugin will receive a `titleParametersDidChange` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func titleParametersDidChange(device: String, info: TitleInfo)

    /// The plugin will receive a `propertyInspectorDidAppear` event when the Property Inspector appears.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    func propertyInspectorDidAppear(device: String)
    
    /// The plugin will receive a `propertyInspectorDidDisappear` event when the Property Inspector appears.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    func propertyInspectorDidDisappear(device: String)
    
    /// The plugin will receive a `sendToPlugin` event when the Property Inspector sends a `sendToPlugin` event.
    /// - Parameters:
    ///   - payload: A json object that will be received by the plugin.
    func sentToPlugin(payload: [String: String])
}


public extension Action {
    
    /// The Action's UUID.
    var uuid: String {
        type(of: self).uuid
    }
    
    /// Event received after calling the `getSettings` API to retrieve the persistent data stored for the action.
    func didReceiveSettings(device: String, payload: SettingsEvent.Payload) { }
    
    /// When an instance of an action is displayed on the Stream Deck, for example when the hardware is first plugged in, or when a folder containing that action is entered, the plugin will receive a `willAppear` event.
    ///
    /// You will see such an event when:
    /// - the Stream Deck application is started
    /// - the user switches between profiles
    /// - the user sets a key to use your action
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func willAppear(device: String, payload: AppearEvent) { }
    
    /// When an instance of an action ceases to be displayed on Stream Deck, for example when switching profiles or folders, the plugin will receive a `willDisappear` event.
    ///
    /// You will see such an event when:
    /// - the user switches between profiles
    /// - the user deletes an action
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func willDisappear(device: String, payload: AppearEvent) { }
    
    /// When the user presses a key, the plugin will receive the `keyDown` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func keyDown(device: String, payload: KeyEvent) { }
    
    /// When the user releases a key, the plugin will receive the `keyUp` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func keyUp(device: String, payload: KeyEvent) { }
    
    /// When the user changes the title or title parameters of the instance of an action, the plugin will receive a `titleParametersDidChange` event.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    ///   - payload: The event payload sent by the server.
    func titleParametersDidChange(device: String, info: TitleInfo) { }

    /// The plugin will receive a `propertyInspectorDidAppear` event when the Property Inspector appears.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    func propertyInspectorDidAppear(device: String) { }
    
    /// The plugin will receive a `propertyInspectorDidDisappear` event when the Property Inspector appears.
    /// - Parameters:
    ///   - device: An opaque value identifying the device.
    func propertyInspectorDidDisappear(device: String) { }
    
    /// The plugin will receive a `sendToPlugin` event when the Property Inspector sends a `sendToPlugin` event.
    /// - Parameters:
    ///   - payload: A json object that will be received by the plugin.
    func sentToPlugin(payload: [String: String]) { }
}


public extension Action {
    
    // MARK: Sent
    
    /// Save data persistently for the action's instance.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - settings: A json object which is persistently saved for the action's instance.
    func setSettings(to settings: [String: Any]) {
        
        StreamDeckPlugin.shared.sendEvent(.setSettings,
                      context: context,
                      payload: settings)
    }
    
    /// Request the persistent data for the action's instance.
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    func getSettings() {
        StreamDeckPlugin.shared.sendEvent(.getSettings,
                      context: context,
                      payload: nil)
    }

    /// Write a debug log to the logs file.
    /// - Parameter message: A string to write to the logs file.
    func logMessage(_ message: String) {
        NSLog("EVENT: Sending log message: \(message)")
        StreamDeckPlugin.shared.sendEvent(.logMessage, context: nil, payload: ["message": message])
    }
    
    /// Write a debug log to the logs file.
    /// - Parameters:
    ///   - items: Zero or more items to print.
    ///   - separator: A string to print between each item. The default is a single space (" ").
    func logMessage(_ items: Any..., separator: String = " ") {
        let message = items.map {
            String(describing: $0)
        }.joined(separator: separator)
        
        logMessage(message)
    }
    
    /// Dynamically change the title of an instance of an action.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - title: The title to display. If there is no title parameter, the title is reset to the title set by the user.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setTitle(to title: String?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        payload["title"] = title
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        StreamDeckPlugin.shared.sendEvent(.setTitle,
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
    func setImage(to image: NSImage?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        payload["image"] = image?.base64String
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        StreamDeckPlugin.shared.sendEvent(.setImage,
                      context: context,
                      payload: payload)
    }
    
    /// Dynamically change the image displayed by an instance of an action.
    ///
    /// The image is automatically encoded to a prefixed base64 string.
    ///
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - image: The name of an image to display.
    ///   - ext: The filename extension of the file to locate.
    ///   - subpath: The subdirectory in the plugin bundle in which to search for images.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setImage(toImage image: String?, withExtension ext: String, subdirectory subpath: String?, target: Target? = nil, state: Int? = nil) {
        guard
            let imageURL = Bundle.main.url(forResource: image, withExtension: ext, subdirectory: subpath)
        else {
            logMessage("Could not find \(image ?? "unnamed").\(ext)")
            return
        }
        
        let image = NSImage(contentsOf: imageURL)
        
        setImage(to: image)
    }
    
    
    /// Dynamically change the image displayed by an instance of an action.
    ///
    /// The image is automatically encoded to a prefixed base64 string.
    ///
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - image: The SVG to display.
    ///   - target: Specify if you want to display the title on hardware, software, or both.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setImage(toSVG svg: String?, target: Target? = nil, state: Int? = nil) {
        var payload: [String: Any] = [:]
        
        if let svg = svg {
            payload["image"] = "data:image/svg+xml;charset=utf8,\(svg)"
        }
        
        payload["target"] = target?.rawValue
        payload["state"] = state
        
        StreamDeckPlugin.shared.sendEvent(.setImage,
                      context: context,
                      payload: payload)
    }

    /// Temporarily show an alert icon on the image displayed by an instance of an action.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    func showAlert() {
        StreamDeckPlugin.shared.sendEvent(.showAlert, context: context, payload: nil)
    }
    
    /// Temporarily show an OK checkmark icon on the image displayed by an instance of an action.
    /// - Parameter context: An opaque value identifying the instance's action or Property Inspector.
    func showOk() {
        StreamDeckPlugin.shared.sendEvent(.showOK, context: context, payload: nil)
    }
    
    /// Change the state of the action's instance supporting multiple states.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - state: A 0-based integer value representing the state of an action with multiple states. This is an optional parameter. If not specified, the title is set to all states.
    func setState(to state: Int) {
        let payload: [String: Any] = ["state": state]

        StreamDeckPlugin.shared.sendEvent(.setState,
                      context: context,
                      payload: payload)
    }
    
    /// Send a payload to the Property Inspector.
    /// - Parameters:
    ///   - context: An opaque value identifying the instance's action or Property Inspector.
    ///   - action: The action unique identifier.
    ///   - payload: A json object that will be received by the Property Inspector.
    func sendToPropertyInspector(payload: [String: Any]) {
        StreamDeckPlugin.shared.sendEvent(.sendToPropertyInspector,
                                          action: uuid,
                                          context: context,
                                          payload: payload)
    }
}
