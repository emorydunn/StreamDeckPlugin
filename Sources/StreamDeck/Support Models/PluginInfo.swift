//
//  PluginInfo.swift
//  
//
//  Created by Emory Dunn on 11/14/21.
//

import Foundation

/// The registration information sent by the Stream Deck application when launching the plugin.
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
    /// Create an object from a JSON string.
    /// - Parameter string: A UTF-8 encoded JSON string.
    public init(string: String) throws {
        let data = string.data(using: .utf8) ?? Data()
        
        self = try JSONDecoder().decode(PluginRegistrationInfo.self, from: data)
    }
}

/// Information about the Stream Deck application.
public struct StreamDeckApp: Decodable, CustomStringConvertible {
    /// In which language the Stream Deck application is running.
    public let language: Language
    
    /// On which platform the Stream Deck application is running.
    public let platform: Platform
    
    /// The operating system version.
    public let platformVersion: String
    
    /// The Stream Deck application version.
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

/// In which language the Stream Deck application is running.
public enum Language: String, Decodable {
    case english = "en"
    case french = "fr"
    case german = "de"
    case spanish = "es"
    case japanese = "ja"
    case chinese = "zh_CN"
}

/// On which platform the Stream Deck application is running.
public enum Platform: String, Decodable {
    case mac // "kESDSDKApplicationInfoPlatformMac"
    case windows // "kESDSDKApplicationInfoPlatformWindows"
}

/// Information about the plugin.
public struct PluginInfo: Decodable, CustomStringConvertible {
    /// The plugin version as written in the manifest.json.
    public let version: String
    
    /// The unique identifier of the plugin.
    public let uuid: String
    
    public var description: String {
        """
        Plugin Version: \(version)
        Plugin UUID: \(uuid)
        """
    }
}
