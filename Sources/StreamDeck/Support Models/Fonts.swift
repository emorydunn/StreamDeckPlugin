//
//  Fonts.swift
//  
//
//  Created by Emory Dunn on 11/14/21.
//

import Foundation


/// Information about the title of an action.
public struct TitleInfo<S: Decodable>: Decodable, Locatable {
	
	/// The new title.
	public let title: String
	
	/// This value indicates for which state of the action the title or title parameters have been changed.
	public let state: Int
	
	/// A json object describing the new title parameters.
	public let titleParameters: Parameters
	
	/// The coordinates of the action triggered.
	public let coordinates: Coordinates?
	
	/// This json object contains data that you can set and is stored persistently.
	public let settings: S
	
	/// Font parameters.
	public struct Parameters: Decodable {
		
		/// The font family for the title.
		public let fontFamily: FontFamily
		
		/// The font size for the title.
		public let fontSize: Int
		
		/// The font style for the title.
		///
		/// - Note: If an unknown font style is sent this property is `nil`.
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
