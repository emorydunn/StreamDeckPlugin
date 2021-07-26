//
//  ReceivableEvent.swift
//  
//
//  Created by Emory Dunn on 7/24/21.
//

import Foundation

// MARK: Sent

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

public enum Target: Int, Encodable {
    case both = 0
    case hardwareOnly = 1
    case softwareOnly = 2
}

// MARK: Received

public struct ReceivableEvent: Decodable {
    let event: EventKey
}

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

public struct ActionEvent: Decodable {
    public let action: String
    public let context: String
    public let device: String
    public let payload: Payload
}

extension ActionEvent {

    public struct Payload: Decodable {
        public let settings: [String: String]
        public let coordinates: Coordinates
        public let state: Int?
        public let userDesiredState: Int?
        public let isInMultiAction: Bool
        
    }

    public struct Coordinates: Decodable {
        public let column: Int
        public let row: Int
    }
    
}
