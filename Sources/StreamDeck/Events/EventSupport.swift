//
//  EventSupport.swift
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

/// The coordinates of the action triggered.
public struct Coordinates: Decodable, Hashable {
    
    /// The column.
    public let column: Int
    
    /// The row.
    public let row: Int
}

/// Information about the title of an action.
public struct TitleInfo: Decodable, Locatable, EventSettings {
    
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
    case corsairGKeys
}
