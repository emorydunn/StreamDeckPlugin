//
//  PluginInfo.swift
//  
//
//  Created by Emory Dunn on 11/14/21.
//

import Foundation

public struct PluginRegistrationInfo: Decodable, CustomStringConvertible {
    
    /// A json object containing information about the application.
    public let application: StreamDeckApp
    
    /// A json object containing information about the plugin.
    public let plugin: PluginInfo
    
    /// Pixel ratio value to indicate if the Stream Deck application is running on a HiDPI screen.
    public let devicePixelRatio: Int
    
    /// A json object containing information about the preferred user colors.
    public let colors: [String: String]
    
    public var description: String {
        """
        \(application)
        \(plugin)
        Device Pixel Ratio: \(devicePixelRatio)
        Colors: \(colors)
        """
    }
}

extension PluginRegistrationInfo {
    public init(string: String) throws {
        let data = string.data(using: .utf8) ?? Data()
        
        self = try JSONDecoder().decode(PluginRegistrationInfo.self, from: data)
    }
}

public struct StreamDeckApp: Decodable, CustomStringConvertible {
    public let language: Language
    public let platform: Platform
    public let platformVersion: String
    public let version: String
    
    public var description: String {
        """
        Language: \(language)
        Platform: \(platform)
        Platform Version: \(platformVersion)
        App Version: \(version)
        """
    }
}

public enum Language: String, Decodable {
    case english = "en"
    case french = "fr"
    case german = "de"
    case spanish = "es"
    case japanese = "ja"
    case chinese = "zh_CN"
}

public enum Platform: String, Decodable {
    case mac // "kESDSDKApplicationInfoPlatformMac"
    case windows // "kESDSDKApplicationInfoPlatformWindows"
}

public struct PluginInfo: Decodable, CustomStringConvertible {
    public let version: String
    public let uuid: String
    
    public var description: String {
        """
        Plugin Version: \(version)
        Plugin UUID: \(uuid)
        """
    }
}
