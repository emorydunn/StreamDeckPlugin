//
//  ApplicationsToMonitor.swift
//  
//
//  Created by Emory Dunn on 12/18/23.
//

import Foundation

/// A plugin can request to be notified when some applications are launched or terminated.
///
/// In order to do so, the ApplicationsToMonitor object should contain for each platform an array specifying the list of application identifiers to monitor.
///
/// - Note: On macOS the application bundle identifier is used while the exe filename is used on Windows.
public struct ApplicationsToMonitor: Codable, ExpressibleByArrayLiteral {

	/// Mac applications to monitor
	public let mac: [String]

	/// Windows applications to monitor
	public let windows: [String]

	/// Initialize new applications to monitor.
	public init(mac: [String] = [], windows: [String] = []) {
		self.mac = mac
		self.windows = windows
	}

	/// Initialize new applications to monitor.
	///
	/// - Note: Using the array literal will set the same applications to both macOS and Windows.
	/// - Parameter elements: The applications to monitor.
	public init(arrayLiteral elements: String...) {
		self.init(mac: elements, windows: elements)
	}
}
