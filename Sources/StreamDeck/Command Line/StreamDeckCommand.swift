//
//  StreamDeckCommand.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation
import ArgumentParser

struct StreamDeckCommand: ParsableCommand {
    /// The port that should be used to create the WebSocket
    @Option(name: .customLong("port", withSingleDash: true), help: "")
    public var port: Int32
    
    /// A unique identifier string that should be used to register the plugin once the WebSocket is opened.
    @Option(name: .customLong("pluginUUID", withSingleDash: true), help: "")
    public var uuid: String
    
    /// The event type that should be used to register the plugin once the WebSocket is opened
    @Option(name: .customLong("registerEvent", withSingleDash: true), help: "")
    public var event: String

    /// A stringified json containing the Stream Deck application information and devices information.
    @Option(name: .customLong("info", withSingleDash: true), help: "")
    public var info: String
    
    /// Initialize an instance of the plugin with the properties provided by the command line.
    public func run() throws {
        NSLog("Starting macOS plugin")
        
        let pluginInfo = try PluginRegistrationInfo(string: info)
        StreamDeckPlugin.shared = try PluginManager.plugin?.init(port: port, uuid: uuid, event: event, info: pluginInfo)
        
        NSLog("Plugin started. Dispatching on main thread.")
        
        dispatchMain()
    }
    
}
