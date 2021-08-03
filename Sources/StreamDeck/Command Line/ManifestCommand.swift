//
//  File.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation
import ArgumentParser

/// The command used to generate a `manifest.json` file.
struct GenerateManifest: ParsableCommand {
    
    /// Output location for the manifest file.
    @Option(help: "Output location of the manifest file.")
    var output: String
    
    /// Whether or not to print the manifest to the console.
    @Flag(help: "Print the manifest to console instead of saving to a file")
    var preview = false
    
    func run() throws {
        guard let manifest = PluginManager.manifest else {
            print("Call `PluginManager.main(plugin:manifest:)` with a PluginManifest.")
            return
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(manifest)
        
        if preview {
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            } else {
                print("Could not encode manifest to JSON string.")
            }
            
            return
        }
        
        try data.write(to: URL(fileURLWithPath: output))
    }
}
