//
//  File.swift
//  
//
//  Created by Emory Dunn on 11/17/21.
//

import Foundation
import ArgumentParser



struct ExportCommand: ParsableCommand {
    
    public static var configuration = CommandConfiguration(
        commandName: "export",
        discussion: "Conveniently export the plugin.")
    
    @Argument(help: "The URI for your plugin")
    var uri: String
    
    @Option(help: "Output folder")
    var output: URL?
    
    @Flag(name: .shortAndLong, help: "Generate the plugin manifest file.")
    var generateManifest: Bool = true
    
    @Flag(name: .shortAndLong, help: "Generate the plugin manifest file.")
    var previewManifest: Bool = true
    
    @Option(name: .shortAndLong, help: "The name of the manifest file.")
    var manifestName: String = "manifest.json"
    
    @Flag(name: .shortAndLong, help: "Copy the executable file.")
    var copyExecutable: Bool = true
    
    @Option(name: .shortAndLong, help: "The name of the executable file.")
    var executableName: String?
    
    func pluginsDir() throws -> URL {
        if let url = output {
            return url
        }
        
        var appSupport = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        appSupport.appendPathComponent("com.elgato.StreamDeck/Plugins")
        
        return appSupport
    }
    
    func run() throws {
        
        // Determine the root folder for the plugin
        let root = try pluginsDir().appendingPathComponent(uri)
        
        // Create the plugin directory
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true, attributes: nil)
        
        
        try generateManifestFile(in: root)
        try copyExecutable(to: root)
        
    }
    
    /// Copy the current executable to the plugin folder.
    /// - Parameter folder: The folder in which to copy the executable.
    func copyExecutable(to folder: URL) throws {
        
        // Get the current executable
        guard let exePath = Bundle.main.executableURL else {
            print("ERROR: Could not determine the current executable's path.")
            return
        }
        
        let newName: String
        if let name = executableName {
            newName = name
        } else {
            newName = exePath.lastPathComponent
        }
        
        let newPath = folder.appendingPathComponent(newName)
        
        try FileManager.default.copyItem(at: exePath, to: newPath)
    }
    
    /// Generate the plugin manifest file.
    /// - Parameter folder: The folder in which to write the manifest.
    func generateManifestFile(in folder: URL) throws {
        guard generateManifest else { return }
        
        guard let manifest = PluginManager.manifest else {
            print("Call `PluginManager.main(plugin:manifest:)` with a PluginManifest.")
            return
        }
        
        let data = try encode(manifest: manifest)
        
        if previewManifest {
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            } else {
                print("Could not encode manifest to JSON string.")
            }
            
            return
        }
        
        var outputURL = folder.appendingPathComponent(manifestName)
        
        if outputURL.pathExtension != "json" {
            outputURL.appendPathExtension("json")
        }
        
        // Attempt to write the file
        try data.write(to: outputURL)
    }
    
    func encode(manifest: PluginManifest,
                outputFormatting: JSONEncoder.OutputFormatting = [
                    .prettyPrinted,
                    .withoutEscapingSlashes]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        
        encoder.keyEncodingStrategy = .custom { keys -> CodingKey in
            StreamDeckKey(key: keys.last!)
        }
        
        return try encoder.encode(manifest)
    }
    
}
