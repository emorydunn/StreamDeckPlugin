//
//  Action.swift
//  
//
//  Created by Emory Dunn on 12/13/21.
//

import Foundation

public protocol Action {
    
    // TODO: Figure out how to get this working
    // associatedtype Plugin: RoutingPlugin
    
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
    /// In addition, it is possible to force the action to switch its state by sending a setState event.
    static var states: [PluginActionState] { get }
    
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
    
    func keyDown(device: String, payload: KeyEvent)
    
    func keyUp(device: String, payload: KeyEvent)
}


extension Action {
    func keyDown(device: String, payload: KeyEvent) { }
    
    func keyUp(device: String, payload: KeyEvent) { }
}
