//
//  File.swift
//  
//
//  Created by Emory Dunn on 11/17/21.
//

import Foundation
import ArgumentParser

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self = URL(fileURLWithPath: argument)
    }
}
