//
//  ProfilePage.swift
//  StreamDeck
//
//  Created by Emory Dunn on 8/17/26.
//

import Foundation

/// The payload used when sending the `SwitchToProfile` event.
struct ProfilePage: Codable {
	let profile: String
	let page: Int?
}
