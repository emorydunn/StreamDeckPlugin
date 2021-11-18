//
//  StreamDeckKey.swift
//  
//
//  Created by Emory Dunn on 8/2/21.
//

import Foundation
import ArgumentParser

struct StreamDeckKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(key: CodingKey) {
        self.init(stringValue: key.stringValue)!
    }
    
    init?(stringValue: String) {
        switch stringValue {
        case "sdkVersion":
            self.stringValue = "SDKVersion"
        case "uuid", "url", "os":
            self.stringValue = stringValue.uppercased()
        default:
            let firstLetter = stringValue.first!.uppercased()
            self.stringValue = firstLetter + stringValue.dropFirst()
        }
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
