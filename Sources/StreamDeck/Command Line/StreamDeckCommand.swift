//
//  StreamDeckCommand.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation
import ArgumentParser
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "StreamDeckCommand")

/// The command called by the Stream Deck application to run the plugin.
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
		let pluginType = PluginCommand.plugin!
		let pluginInfo = try PluginRegistrationInfo(string: info)
		
		log.log("Initializing plugin '\(pluginType.name)'")
		log.log("""
		CLI Port: \(port)
		CLI UUID: \(uuid)
		CLI Event: \(event)
		""")
		log.log("\(pluginInfo.description)")

		StreamDeckPlugin.shared = StreamDeckPlugin(plugin: pluginType.init(), port: port, uuid: uuid, event: event, info: pluginInfo)
		
		StreamDeckPlugin.shared.monitorSocket()
		
		try StreamDeckPlugin.shared.registerPlugin()
		
		log.log("Plugin started. Dispatching on main thread.")

		dispatchMain()
	}
	
}
