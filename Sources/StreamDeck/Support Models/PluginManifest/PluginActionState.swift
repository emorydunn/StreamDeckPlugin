//
//  PluginActionState.swift
//  
//
//  Created by Emory Dunn on 12/18/23.
//

import Foundation


/// The states an action can show.
public struct PluginActionState: Codable {

	/// The default image for the state.
	public var image: String

	/// The name of the state displayed in the dropdown menu in the Multi action.
	///
	/// For example Start or Stop for the states of the Game Capture Record action. If the name is not provided, the state will not appear in the Multi Action.
	public var name: String?

	/// Default title.
	public var title: String?

	/// Boolean to hide/show the title. True by default.
	public var showTitle: Bool?

	/// Default title color.
	public var titleColor: String?

	/// Default title vertical alignment.
	public var titleAlignment: Alignment?

	/// Default font family for the title.
	public var fontFamily: FontFamily?

	/// Default font style for the title.
	///
	/// - Note: Some fonts might not support all values.
	public var fontStyle: FontStyle?

	/// Default font size for the title.
	public var fontSize: Int?

	/// Boolean to have an underline under the title. False by default
	public var fontUnderline: Bool?

	public init(image: String,
				name: String? = nil,
				title: String? = nil,
				showTitle: Bool? = nil,
				titleColor: String? = nil,
				titleAlignment: Alignment? = nil,
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
