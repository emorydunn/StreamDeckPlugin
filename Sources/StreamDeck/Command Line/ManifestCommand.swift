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
        
        let data = try encode(manifest: manifest)
        
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
    
    func encode(manifest: PluginManifest) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .prettyPrinted,
            .withoutEscapingSlashes
        ]
        
        encoder.keyEncodingStrategy = .custom { keys -> CodingKey in
            StreamDeckKey(key: keys.last!)
        }
        
        return try encoder.encode(manifest)
    }
}

struct StreamDeckKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(key: CodingKey) {
        self.init(stringValue: key.stringValue)!
    }
    
    init?(stringValue: String) {
        switch stringValue {
        case "sdkVersion":
            self.stringValue = "SDKVersion"
        case "uuid", "url", "os":
            self.stringValue = stringValue.uppercased()
        default:
            let firstLetter = stringValue.first!.uppercased()
            self.stringValue = firstLetter + stringValue.dropFirst()
        }
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
