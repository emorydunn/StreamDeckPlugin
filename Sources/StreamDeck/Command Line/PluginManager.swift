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
    
    public static var configuration = CommandConfiguration(
        subcommands: [
            StreamDeckCommand.self,
            GenerateManifest.self
        ],
        defaultSubcommand: StreamDeckCommand.self
        )
    
    /// The plugin to be used.
    public static var plugin: StreamDeckPlugin.Type?
    public static var manifest: PluginManifest?

    /// The default init
    public init() { }

    /// A convenience method for registering the plugin, reading the CLI options, 
    /// and dispatching on the main thread. 
    public static func main(plugin: StreamDeckPlugin.Type, manifest: PluginManifest? = nil) {
        PluginManager.plugin = plugin
        PluginManager.manifest = manifest
        PluginManager.main()
    }
       
}

