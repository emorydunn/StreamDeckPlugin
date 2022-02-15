//
//  PluginCommand.swift
//
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation
import ArgumentParser

/// Manages a plugins lifecycle and handling launch from the Stream Deck application.
public struct PluginCommand: ParsableCommand {
    
    /// The command's configuration.
    public static var configuration = CommandConfiguration(
        subcommands: [
            StreamDeckCommand.self,
            ExportCommand.self
        ],
        defaultSubcommand: StreamDeckCommand.self
        )
    
    /// The plugin to be used.
    public static var plugin: PluginDelegate.Type?

    /// The default init
    public init() { }
    
    /// Add a subcommand to the plugin executable.
    /// - Parameter command: The additional subcommand.
    public static func addCommand(_ command: ParsableCommand.Type) {
        configuration.subcommands.append(command)
    }
    
}

