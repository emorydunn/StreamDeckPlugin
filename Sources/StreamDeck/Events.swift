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

/// Actions sent by the server.
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

//extension ActionEvent {
//
//    public struct Payload: Decodable, Hashable {
//
//        /// This json object contains data that you can set and are stored persistently.
//        public let settings: [String: String]
//
//        /// The coordinates of the action triggered.
//        public let coordinates: Coordinates
//
//        /// This is a parameter that is only set when the action has multiple states defined in its manifest.json.
//        ///
//        /// The 0-based value contains the current state of the action.
//        public let state: Int?
//
//        /// This is a parameter that is only set when the action is triggered with a specific value from a Multi Action.
//        ///
//        /// For example if the user sets the Game Capture Record action to be disabled in a Multi Action, you would see the value 1.
//        ///
//        /// - Important: Only the value 0 and 1 are valid.
//        public let userDesiredState: Int?
//
//
//        /// Boolean indicating if the action is inside a Multi Action.
//        public let isInMultiAction: Bool
//
//    }
//
//    /// The coordinates of the action triggered.
//    public struct Coordinates: Decodable, Hashable {
//
//        /// The column.
//        public let column: Int
//
//
//        /// The row.
//        public let row: Int
//    }
//
//}

/// The coordinates of the action triggered.
public struct Coordinates: Decodable, Hashable {
    
    /// The column.
    public let column: Int
    
    /// The row.
    public let row: Int
}

// MARK: Settings Events
public struct SettingsEvent: Decodable {
    /// The action's unique identifier. If your plugin supports multiple actions, you should use this value to see which action was triggered.
    public let action: String
    
    /// An opaque value identifying the instance's action.
    public let context: String
    
    /// An opaque value identifying the device.
    public let device: String
    
    /// The payload of the event.
    public let payload: Payload
    
    public struct Payload: Decodable, Locatable {
        /// This json object contains data that you can set and are stored persistently.
        public let settings: Data
        
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

public struct GlobalSettingsEvent: Decodable {
    /// The payload of the event.
    public let payload: Payload
    
    public struct Payload: Decodable {
        /// This json object contains data that you can set and are stored persistently.
        public let settings: Data
    }
}

// MARK: Appear Events
/// Information received about a `willAppear` or `willDisappear` event.
public struct AppearEvent: Decodable, Hashable, Locatable {
    
    /// This json object contains data that you can set and are stored persistently.
    public let settings: Data
    
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
    public let settings: Data
    
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
    public let title: String
    public let state: Int
    public let titleParameters: String
    public let coordinates: Coordinates
    public let settings: Data
    
    public struct Parameters: Decodable {
        public let fontFamily: String
        public let fontSize: Int
        public let fontStyle: String
        public let fontUnderline: Bool
        public let showTitle: Bool
        public let titleAlignment: Alignment
        public let titleColor: String
    }
    
    public enum Alignment: String, Decodable {
        case top, bottom, middle
    }
}


/// Information received about the Stream Deck device.
public struct DeviceInfo: Decodable {
    public let name: String
    public let type: String
    public let size: Size
    
    public struct Size: Decodable {
        public let columns: Int
        public let rows: Int
    }
    
    public enum DeviceType: Int, Decodable {
        case streamDeck
        case mini
        case xl
        case mobile
        case corsiarGKeys
    }
}
