//
//  File.swift
//  
//
//  Created by Emory Dunn on 1/20/24.
//

import Foundation

@resultBuilder
public struct ActionBuilder {

	public static func buildBlock(_ actions: any Action.Type...) -> [any Action.Type] {
		actions
	}

}
