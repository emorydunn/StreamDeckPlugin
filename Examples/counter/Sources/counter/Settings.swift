//
//  Settings.swift
//  
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import StreamDeck

struct PluginCount: GlobalSettingKey {
	static let defaultValue: Int = 0
}


extension GlobalSettings {
	@MainActor
	var count: Int {
		get { self[PluginCount.self] }
		set { self[PluginCount.self] = newValue }
	}
}
