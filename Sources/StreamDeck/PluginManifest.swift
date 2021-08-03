//
//  PluginManifest.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation

/// The manifest file providing plugin details.
///
/// See the [SDK documentation](https://developer.elgato.com/documentation/stream-deck/sdk/manifest/) for more information.
public struct PluginManifest: Codable {

    /// The name of the plugin.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    public var name: String
    
    /// Provides a general description of what the plugin does.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    public var description: String
    
    /// The name of the custom category in which the actions should be listed.
    ///
    /// This string is visible to the user in the actions list. If you don't provide a category, the actions will appear inside a "Custom" category.
    public var category: String?
    
    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is used in the actions list. The PNG image should be a 28pt x 28pt image.
    /// You should provide @1x and @2x versions of the image.
    /// The Stream Deck application takes care of loading the appropriate version of the image.
    public var categoryIcon: String?
    
    /// The author of the plugin.
    ///
    /// This string is displayed to the user in the Stream Deck store.
    public var author: String
    
    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is displayed in the Plugin Store window. The PNG image should be a 72pt x 72pt image.
    /// You should provide @1x and @2x versions of the image.
    /// The Stream Deck application takes care of loading the appropriate version of the image.
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
    
    /// Specifies an array of actions.
    ///
    /// A plugin can indeed have one or multiple actions.
    ///
    /// For example the Game Capture plugin has 6 actions: Scene, Record, Screenshot, Flashback Recording, Stream, Live Commentary.
    public var actions: [PluginAction]
    
    /// Initialize a new manifest.
    /// - Parameters:
    ///   - name: The name of the plugin.
    ///   - description: Provides a general description of what the plugin does.
    ///   - category: The name of the custom category in which the actions should be listed.
    ///   - categoryIcon: The relative path to a PNG image without the .png extension.
    ///   - author: The author of the plugin.
    ///   - icon: The relative path to a PNG image without the .png extension.
    ///   - url: A URL displayed to the user if he wants to get more info about the plugin.
    ///   - version: The version of the plugin which can only contain digits and periods.
    ///   - os: The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
    ///   - applicationsToMonitor: List of application identifiers to monitor (applications launched or terminated).
    ///   - software: Indicates which version of the Stream Deck application is required to install the plugin.
    ///   - sdkVersion: This value should be set to 2.
    ///   - codePath: The relative path to the HTML/binary file containing the code of the plugin.
    ///   - codePathMac: Override CodePath for macOS.
    ///   - codePathWin: Override CodePath for Windows.
    ///   - actions: Specifies an array of actions.
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
                sdkVersion: Int = 2,
                codePath: String,
                codePathMac: String? = nil,
                codePathWin: String? = nil,
                actions: [PluginAction]) {
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
        self.actions = actions
    }
    
}


/// An action a plugin can provide for the user.
public struct PluginAction: Codable {
    
    /// The name of the action. This string is visible to the user in the actions list.
    public let name: String
    
    /// The unique identifier of the action.
    ///
    /// It must be a uniform type identifier (UTI) that contains only lowercase alphanumeric characters (a-z, 0-9), hyphen (-), and period (.).
    ///
    /// The string must be in reverse-DNS format.
    ///
    /// For example, if your domain is elgato.com and you create a plugin named Hello with the action My Action, you could assign the string com.elgato.hello.myaction as your action's Unique Identifier.
    public let uuid: String
    
    /// The relative path to a PNG image without the .png extension.
    ///
    /// This image is displayed in the actions list. The PNG image should be a 20pt x 20pt image. You should provide @1x and @2x versions of the image.
    /// The Stream Deck application take care of loaded the appropriate version of the image.
    ///
    /// - Note: This icon is not required for actions not visible in the actions list (`VisibleInActionsList` set to false).
    public let icon: String
    
    /// Specifies an array of states.
    ///
    /// Each action can have one state or 2 states (on/off).
    ///
    /// For example the Hotkey action has a single state. However the Game Capture Record action has 2 states, active and inactive.
    ///
    /// The state of an action, supporting multiple states, is always automatically toggled whenever the action's key is released (after being pressed).
    ///
    /// In addition, it is possible to force the action to switch its state by sending a setState event.
    public let states: [PluginActionState]
    
    /// This can override PropertyInspectorPath member from the plugin if you wish to have different PropertyInspectorPath based on the action.
    ///
    /// The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
    public let propertyInspectorPath: String?
    
    /// Boolean to prevent the action from being used in a Multi Action.
    ///
    /// True by default.
    public let supportedInMultiActions: Bool?
    
    
    /// The string displayed as tooltip when the user leaves the mouse over your action in the actions list.
    public let tooltop: String?
    
    /// Boolean to hide the action in the actions list.
    ///
    /// This can be used for plugin that only works with a specific profile. True by default.
    public let visibleInActionsList: Bool?
    
    /// Initialize a new action.
    public init(name: String,
                  uuid: String,
                  icon: String,
                  states: [PluginActionState],
                  propertyInspectorPath: String? = nil,
                  supportedInMultiActions: Bool? = nil,
                  tooltop: String? = nil,
                  visibleInActionsList: Bool? = nil) {
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

/// The states an action can show.
public struct PluginActionState: Codable {
    
    /// The default image for the state.
    public let image: String
    
    /// The name of the state displayed in the dropdown menu in the Multi action.
    ///
    /// For example Start or Stop for the states of the Game Capture Record action. If the name is not provided, the state will not appear in the Multi Action.
    public let name: String?
    
    /// Default title.
    public let title: String?
    
    /// Boolean to hide/show the title. True by default.
    public let showTitle: Bool?
    
    /// Default title color.
    public let titleColor: String?
    
    /// Default title vertical alignment.
    public let titleAlignment: String?
    
    /// Default font family for the title.
    public let fontFamily: FontFamily?
    
    /// Default font style for the title.
    ///
    /// - Note: Some fonts might not support all values.
    public let fontStyle: FontStyle?
    
    /// Default font size for the title.
    public let fontSize: Int?
    
    /// Boolean to have an underline under the title. False by default
    public let fontUnderline: Bool?
    
    public init(image: String,
                name: String? = nil,
                title: String? = nil,
                showTitle: Bool? = nil,
                titleColor: String? = nil,
                titleAlignment: String? = nil,
                fontFamily: FontFamily? = nil,
                fontStyle: FontStyle? = nil,
                fontSize: Int? = nil,
                fontUnderline: Bool? = nil) {
        self.image = image
        self.name = name
        self.title = title
        self.showTitle = showTitle
        self.titleColor = titleColor
        self.titleAlignment = titleAlignment
        self.fontFamily = fontFamily
        self.fontStyle = fontStyle
        self.fontSize = fontSize
        self.fontUnderline = fontUnderline
    }
    
}

/// Supported operating systems of a plugin.
///
/// See the [OS section](https://developer.elgato.com/documentation/stream-deck/sdk/manifest/#os) for more information
public struct PluginOS: Codable {
    
    /// The name of the platform, `mac` or `windows`.
    public let platform: PluginPlatform
    
    /// The minimum version of the operating system that the plugin requires.
    public let minimumVersion: String
    
    /// Initialize a new OS.
    public init(_ platform: PluginPlatform, minimumVersion: String) {
        self.platform = platform
        self.minimumVersion = minimumVersion
    }
    
    /// Initialize a `mac` OS with the specified minimum version
    public static func mac(minimumVersion: String) -> PluginOS {
        PluginOS(.mac, minimumVersion: minimumVersion)
    }
    
    /// Initialize a `windows` OS with the specified minimum version
    public static func win(minimumVersion: String) -> PluginOS {
        PluginOS(.windows, minimumVersion: minimumVersion)
    }
}

/// Supported operating systems.
public enum PluginPlatform: String, Codable {
    case mac
    case windows
}

/// The minimum version of the Stream Deck application supported.
public struct PluginSoftware: Codable {
    
    /// The minimum version of the Stream deck application that the plugin requires.
    ///
    /// - Important: This value should be set to only support Stream Deck 4.1 or later.
    public let minimumVersion: String
    
    /// Initialize a new software version.
    /// - Parameter minimumVersion: This value should be set to only support Stream Deck 4.1 or later.
    public init(minimumVersion: String) {
        self.minimumVersion = minimumVersion
    }
    
    /// Convenience method for setting the software version in a manifest.
    public static func minimumVersion(_ minimumVersion: String) -> PluginSoftware {
        PluginSoftware(minimumVersion: minimumVersion)
    }
}

/// A plugin can request to be notified when some applications are launched or terminated.
///
/// In order to do so, the ApplicationsToMonitor object should contain for each platform an array specifying the list of application identifiers to monitor.
///
/// - Note: On macOS the application bundle identifier is used while the exe filename is used on Windows.
public struct ApplicationsToMonitor: Codable {
    
    /// Mac applications to monitor
    public let mac: [String]
    
    /// Windows applications to monitor
    public let windows: [String]
    
    /// Initialize new applications to monitor.
    public init(mac: [String], windows: [String]) {
        self.mac = mac
        self.windows = windows
    }
}

/// Preconfigured plugin profiles. 
public struct PluginProfile: Codable {
    
    /// The filename of the profile.
    public let name: String
    
    /// Type of device.
    public let deviceType: DeviceType
    
    /// Boolean to mark the profile as read-only. False by default.
    public let readOnly: Bool?
    
    /// Boolean to prevent Stream Deck from automatically switching to this profile when installed. False by default.
    public let dontAutoSwitchWhenInstalled: Bool?
    
    public init(name: String,
                deviceType: DeviceType,
                readOnly: Bool? = nil,
                dontAutoSwitchWhenInstalled: Bool? = nil) {
        self.name = name
        self.deviceType = deviceType
        self.readOnly = readOnly
        self.dontAutoSwitchWhenInstalled = dontAutoSwitchWhenInstalled
    }
}
