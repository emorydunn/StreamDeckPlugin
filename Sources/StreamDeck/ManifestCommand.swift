//
//  File.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation
import ArgumentParser

struct GenerateManifest: ParsableCommand {
    
    @Option(help: "Output location of the manifest file.")
    var output: String
    
    @Flag(help: "Print the manifest to console instead of saving to a file")
    var preview = false
    
    func run() throws {
        guard let manifest = PluginManager.manifest else {
            print("Please set `PluginManager.manifest`.")
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
