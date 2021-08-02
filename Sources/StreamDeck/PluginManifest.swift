//
//  PluginManifest.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation

public struct PluginManifest: Codable {

    
    /// The name of the plugin. This string is displayed to the user in the Stream Deck store.
    public var name: String
    
    /// Provides a general description of what the plugin does. This string is displayed to the user in the Stream Deck store.
    public var description: String
    
    /// The name of the custom category in which the actions should be listed.
    ///
    /// This string is visible to the user in the actions list. If you don't provide a category, the actions will appear inside a "Custom" category.
    public var category: String?
    
    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is used in the actions list. The PNG image should be a 28pt x 28pt image. You should provide @1x and @2x versions of the image. The Stream Deck application takes care of loading the appropriate version of the image.
    public var categoryIcon: String?
    
    /// The author of the plugin. This string is displayed to the user in the Stream Deck store.
    public var author: String
    
    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is displayed in the Plugin Store window. The PNG image should be a 72pt x 72pt image. You should provide @1x and @2x versions of the image. The Stream Deck application takes care of loading the appropriate version of the image.
    public var icon: String
    
    /// A URL displayed to the user if he wants to get more info about the plugin.
    public var url: URL?
    
    /// The version of the plugin which can only contain digits and periods.
    ///
    /// This is used for the software update mechanism.
    public var version: String
    
    /// The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
    public var os: [PluginOS]
    
    /// List of application identifiers to monitor (applications launched or terminated).
    ///
    /// See the [applicationDidLaunch][launch] and [applicationDidTerminate][term] events.
    ///
    /// [launch]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidlaunch
    /// [term]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/#applicationdidterminate
    public var applicationsToMonitor: ApplicationsToMonitor?
    
    /// Indicates which version of the Stream Deck application is required to install the plugin.
    public var software: PluginSoftware
    
    /// This value should be set to 2.
    public var sdkVersion: Int
    
    /// The relative path to the HTML/binary file containing the code of the plugin.
    public var codePath: String
    
    /// Override CodePath for macOS.
    public var codePathMac: String?
    
    /// Override CodePath for Windows.
    public var codePathWin: String?
    
    public init(name: String,
                  description: String,
                  category: String? = nil,
                  categoryIcon: String? = nil,
                  author: String,
                  icon: String,
                  url: URL? = nil,
                  version: String,
                  os: [PluginOS],
                  applicationsToMonitor: ApplicationsToMonitor? = nil,
                  software: PluginSoftware,
                  sdkVersion: Int,
                  codePath: String,
                  codePathMac: String? = nil,
                  codePathWin: String? = nil) {
        self.name = name
        self.description = description
        self.category = category
        self.categoryIcon = categoryIcon
        self.author = author
        self.icon = icon
        self.url = url
        self.version = version
        self.os = os
        self.applicationsToMonitor = applicationsToMonitor
        self.software = software
        self.sdkVersion = sdkVersion
        self.codePath = codePath
        self.codePathMac = codePathMac
        self.codePathWin = codePathWin
    }
    
}

public struct PluginAction: Codable {
    
    public let name: String
    public let uuid: String
    public let icon: String
    public let states: [PluginActionState]
    public let propertyInspectorPath: String?
    public let supportedInMultiActions: Bool?
    public let tooltop: String?
    public let visibleInActionsList: Bool?
    
    public init(name: String,
                  uuid: String,
                  icon: String,
                  states: [PluginActionState],
                  propertyInspectorPath: String?,
                  supportedInMultiActions: Bool?,
                  tooltop: String?,
                  visibleInActionsList: Bool?) {
        self.name = name
        self.uuid = uuid
        self.icon = icon
        self.states = states
        self.propertyInspectorPath = propertyInspectorPath
        self.supportedInMultiActions = supportedInMultiActions
        self.tooltop = tooltop
        self.visibleInActionsList = visibleInActionsList
    }
    
}

public struct PluginActionState: Codable {
    public let image: String
    public let name: String?
    public let title: String?
    public let showTitle: Bool?
    public let titleColor: String?
    public let titleAlignment: String?
    public let fontFamily: FontFamily
    public let fontStyle: FontStyle
    public let fontSize: Int
    public let fontUnderline: Bool?
    
}



public struct PluginOS: Codable {
    public let platform: PluginPlatform
    public let minimumVersion: String
    
    public init(_ platform: PluginPlatform, minimumVersion: String) {
        self.platform = platform
        self.minimumVersion = minimumVersion
    }
}

public enum PluginPlatform: String, Codable {
    case mac
    case windows
}

public struct PluginSoftware: Codable {
    public let minimumVersion: String
    
    public init(minimumVersion: String) {
        self.minimumVersion = minimumVersion
    }
}

public struct ApplicationsToMonitor: Codable {
    
    public let mac: [String]
    public let windows: [String]
    
    public init(mac: [String], windows: [String]) {
        self.mac = mac
        self.windows = windows
    }
}

public struct PluginProfile: Codable {
    
    /// The filename of the profile.
    public let name: String
    
    /// Type of device.
    public let deviceType: DeviceType
    
    /// Boolean to mark the profile as read-only. False by default.
    public let readOnly: Bool?
    
    /// Boolean to prevent Stream Deck from automatically switching to this profile when installed. False by default.
    public let dontAutoSwitchWhenInstalled: Bool?
}
