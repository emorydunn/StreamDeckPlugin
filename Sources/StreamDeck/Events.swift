//
//  ReceivableEvent.swift
//  
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation

// MARK: Sent

/// Keys for sent events.
public enum SendableEventKey: String, Codable {
    case setSettings
    case getSettings
    case setGlobalSettings
    case getGlobalSettings
    case openURL = "openUrl"
    case logMessage
    case setTitle
    case setImage
    case showAlert
    case showOK = "showOk"
    case setState
    case switchToProfile
    case sendToPropertyInspector
    case sendToPlugin
}

/// Where to display information.
public enum Target: Int, Encodable {
    case both = 0
    case hardwareOnly = 1
    case softwareOnly = 2
}

// MARK: - Received

/// The root object to decode a received event.
public struct ReceivableEvent: Decodable {
    let event: EventKey
}

/// Keys for received events.
extension ReceivableEvent {
    public enum EventKey: String, Codable {
        case didReceiveSettings
        case didReceiveGlobalSettings
        case keyDown
        case keyUp
        case willAppear
        case willDisappear
        case titleParametersDidChange
        case deviceDidConnect
        case deviceDidDisconnect
        case applicationDidLaunch
        case applicationDidTerminate
        case systemDidWakeUp
        case propertyInspectorDidAppear
        case propertyInspectorDidDisappear
        case sendToPlugin
        case sendToPropertyInspector
    }
}

protocol Locatable {
    var coordinates: Coordinates { get }
}

/// Events sent by the server in response to actions.
public struct ActionEvent<Payload: Decodable>: Decodable {
    
    /// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    public let action: String
    
    /// An opaque value identifying the instance's action.
    public let context: String
    
    /// An opaque value identifying the device.
    public let device: String
    
    /// The payload of the event.
    public let payload: Payload
}

/// Events sent by the server that do not have an associated action instance.
public struct Event<Payload: Decodable>: Decodable {
    
    /// An opaque value identifying the device.
    public let device: String
    
    /// The payload of the event.
    public let payload: Payload
}

/// Device connection events sent by the server. 
public struct DeviceConnectionEvent: Decodable {
    
    /// An opaque value identifying the device.
    public let device: String
    
    /// The payload of the event.
    public let deviceInfo: DeviceInfo?
}

/// The coordinates of the action triggered.
public struct Coordinates: Decodable, Hashable {
    
    /// The column.
    public let column: Int
    
    /// The row.
    public let row: Int
}

// MARK: Settings Events

/// Action instance settings received after calling `getSettings()`.
public struct SettingsEvent: Decodable {
    /// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    public let action: String
    
    /// An opaque value identifying the instance's action.
    public let context: String
    
    /// An opaque value identifying the device.
    public let device: String
    
    /// The payload of the event.
    public let payload: Payload
    
    /// Container for the settings data.
    public struct Payload: Decodable, Locatable {
        /// This json object contains data that you can set and are stored persistently.
        public let settings: [String: String]
        
        /// The coordinates of the action triggered.
        public let coordinates: Coordinates
        
        /// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
        ///
        /// The 0-based value contains the current state of the action.
        public let state: Int

        /// Boolean indicating if the action is inside a Multi Action.
        public let isInMultiAction: Bool
    }
}

/// Global settings received after calling `getGlobalSettings()`.
public struct GlobalSettingsEvent: Decodable {
    /// The payload of the event.
    public let payload: Payload
    
    /// Container for the settings data.
    public struct Payload: Decodable {
        /// This json object contains data that you can set and are stored persistently.
        public let settings: [String: String]
    }
}

// MARK: Appear Events

/// Information received about a `willAppear` or `willDisappear` event.
public struct AppearEvent: Decodable, Hashable, Locatable {
    
    /// This json object contains data that you can set and are stored persistently.
    public let settings: [String: String]
    
    /// The coordinates of the action triggered.
    public let coordinates: Coordinates
    
    /// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
    ///
    /// The 0-based value contains the current state of the action.
    public let state: Int?

    /// Boolean indicating if the action is inside a Multi Action.
    public let isInMultiAction: Bool
    
}

// MARK: Key Events
/// Information received about a `keyUp` or `keyDown` event.
public struct KeyEvent: Decodable, Hashable, Locatable {
    
    /// This json object contains data that you can set and are stored persistently.
    public let settings: [String: String]
    
    /// The coordinates of the action triggered.
    public let coordinates: Coordinates
    
    /// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
    ///
    /// The 0-based value contains the current state of the action.
    public let state: Int?
    
    /// This is a parameter that is only set when the action is triggered with a specific value from a Multi Action.
    ///
    /// For example if the user sets the Game Capture Record action to be disabled in a Multi Action, you would see the value 1.
    ///
    /// - Important: Only the value 0 and 1 are valid.
    public let userDesiredState: Int?
    
    /// Boolean indicating if the action is inside a Multi Action.
    public let isInMultiAction: Bool
    
}

/// Information about the title of an action.
public struct TitleInfo: Decodable, Locatable {
    
    /// The new title.
    public let title: String
    
    /// This value indicates for which state of the action the title or title parameters have been changed.
    public let state: Int
    
    /// A json object describing the new title parameters.
    public let titleParameters: Parameters
    
    /// The coordinates of the action triggered.
    public let coordinates: Coordinates
    
    /// This json object contains data that you can set and is stored persistently.
    public let settings: [String: String]
    
    /// Font parameters.
    public struct Parameters: Decodable {
        
        /// The font family for the title.
        public let fontFamily: FontFamily
        
        /// The font size for the title.
        public let fontSize: Int
        
        /// The font style for the title.
        public let fontStyle: FontStyle
        
        /// Boolean indicating an underline under the title.
        public let fontUnderline: Bool
        
        /// Boolean indicating if the title is visible.
        public let showTitle: Bool
        
        /// Vertical alignment of the title.
        public let titleAlignment: Alignment
        
        /// Title color.
        public let titleColor: String
    }
    
}

/// Title alignment.
public enum Alignment: String, Codable {
    case top, bottom, middle
}

/// Title font families.
public enum FontFamily: String, Codable {
    case unknown = ""
    case arial = "Arial"
    case arialBlack = "Arial Black"
    case comicSansMS = "Comic Sans MS"
    case courier = "Courier"
    case courierNew = "Courier New"
    case georgia = "Georgia"
    case impact = "Impact"
    case microsoftSansSerif = "Microsoft Sans Serif"
    case symbol = "Symbol"
    case tahoma = "Tahoma"
    case timesNewRoman = "Times New Roman"
    case trebuchetMS = "Trebuchet MS"
    case verdana = "Verdana"
    case webdings = "Webdings"
    case wingdings = "Wingdings"
}

/// Title font styles.
public enum FontStyle: String, Codable {
    case unknown = ""
    case regular = "Regular"
    case bold = "Bold"
    case italic = "Italic"
    case boldItalic = "Bold Italic"
}


/// Information received about the Stream Deck device.
public struct DeviceInfo: Decodable {
    
    /// The name of the device set by the user.
    public let name: String
    
    /// Type of device.
    public let type: DeviceType
    
    /// The number of columns and rows of keys that the device owns.
    public let size: Size
    
    /// The size of a device.
    public struct Size: Decodable {
        
        /// Number of columns a device has.
        public let columns: Int
        
        /// Number of rows a device has.
        public let rows: Int
    }
    
}

/// The available Stream Deck devices.
public enum DeviceType: Int, Codable {
    case streamDeck
    case mini
    case xl
    case mobile
    case corsiarGKeys
}
