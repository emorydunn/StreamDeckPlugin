//
//  CurrentTrack.swift
//
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation
import ArgumentParser

/// Manages a plugins lifecycle and handling launch from the Stream Deck application.
public struct PluginManager: ParsableCommand {
    
    /// The plugin to be used.
    public static var plugin: StreamDeckPlugin.Type?
    
    // CLI
    
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
    
    /// Manually initialize the manager. 
    init(port: Int32, uuid: String, event: String, info: String) {
        self.port = port
        self.uuid = uuid
        self.event = event
        self.info = info
    }
    
    /// The default init
    public init() { }

    /// Initialize an instance of the plugin with the properties provided by the command line. 
    public func run() throws {
        NSLog("Starting macOS plugin")
        StreamDeckPlugin.shared = try PluginManager.plugin?.init(properties: self)
    }
    
    /// A convenience method for registering the plugin, reading the CLI options, 
    /// and dispatching on the main thread. 
    public static func main(plugin: StreamDeckPlugin.Type) {
        PluginManager.plugin = plugin
        PluginManager.main()

        dispatchMain()
    }
       
}

