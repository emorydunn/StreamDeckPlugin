//
//  CharSet+DNS.swift
//
//
//  Created by Emory Dunn on 12/29/23.
//

import Foundation


public extension CharacterSet {
	static var reverseDNS = CharacterSet
		.lowercaseLetters
		.union(.decimalDigits)
		.union(CharacterSet(arrayLiteral: ".", "-"))
}
