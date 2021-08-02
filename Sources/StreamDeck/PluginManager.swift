//
//  CurrentTrack.swift
//
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation
import ArgumentParser

public struct PluginManager: ParsableCommand {
    
    public static var plugin: StreamDeckPlugin.Type?
    
    // CLI
    @Option(name: .customLong("port", withSingleDash: true), help: "")
    public var port: Int32
    
    @Option(name: .customLong("pluginUUID", withSingleDash: true), help: "")
    public var uuid: String
    
    @Option(name: .customLong("registerEvent", withSingleDash: true), help: "")
    public var event: String

    @Option(name: .customLong("info", withSingleDash: true), help: "")
    public var info: String
    
    init(port: Int32, uuid: String, event: String, info: String) {
        self.port = port
        self.uuid = uuid
        self.event = event
        self.info = info
    }
    
    public init() { }

    public func run() throws {
        NSLog("Starting macOS plugin")
        StreamDeckPlugin.shared = try PluginManager.plugin?.init(properties: self)
    }
    
    static func main(plugin: StreamDeckPlugin.Type) {
        PluginManager.plugin = plugin
        PluginManager.main()

        dispatchMain()
    }
       
}

