//
//  URL+Argument.swift
//  
//
//  Created by Emory Dunn on 11/17/21.
//

import Foundation
import ArgumentParser

extension URL: @retroactive ExpressibleByArgument {

	/// Create a URL from a command line argument.
	///
	/// Calls `URL.init(fileURLWithPath:)`
	public init?(argument: String) {
		self = URL(fileURLWithPath: argument)
	}
}
