//
//  Hardware.swift
//  
//
//  Created by Emory Dunn on 10/25/21.
//

import Foundation

/// Where to display information.
public enum Target: Int, Encodable {
    case both = 0
    case hardwareOnly = 1
    case softwareOnly = 2
}

/// Information received about the Stream Deck device.
public struct DeviceInfo: Decodable {
    
    /// An opaque value identifying the device.
    public let id: String?
    
    /// The name of the device set by the user.
    public let name: String
    
    /// Type of device.
    public let type: DeviceType
    
    /// The number of columns and rows of keys that the device owns.
    public let size: Size
    
}

/// The available Stream Deck devices.
public enum DeviceType: Int, Codable {
    case streamDeck
    case mini
    case xl
    case mobile
    case corsairGKeys
}

/// The size of a device.
public struct Size: Decodable {
    
    /// Number of columns a device has.
    public let columns: Int
    
    /// Number of rows a device has.
    public let rows: Int
}
