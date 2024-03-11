//
//  Color+FormatStyle.swift
//  
//
//  Created by Emory Dunn on 9/3/22.
//

import Foundation

@available(macOS 12.0, *)
extension Color {
	public struct FormatStyle: Codable, Equatable, Hashable {
		public enum Format: Codable, Equatable, Hashable {
			case hex, hexAlpha, rgba
		}

		let format: Format

		public init(_ format: Format) {
			self.format = format
		}
	}

	/// Converts `self` to another representation.
	/// - Parameter style: The format for formatting `self`
	/// - Returns: A representations of `self` using the given `style`. The type of the return is determined by the FormatStyle.FormatOutput
	public func formatted<F: Foundation.FormatStyle>(_ style: F) -> F.FormatOutput where F.FormatInput == Color {
		style.format(self)
	}

}

@available(macOS 12.0, *)
extension Color.FormatStyle: Foundation.FormatStyle {
	public func format(_ value: Color) -> String {

		let r = lround(value.red * 255)
		let g = lround(value.green * 255)
		let b = lround(value.blue * 255)

		switch format {
		case .hex:
			return String(format: "#%02lX%02lX%02lX", r, g, b)
		case .hexAlpha:
			let a = lround(value.alpha * 255)
			return String(format: "#%02lX%02lX%02lX%02lX", r, g, b, a)
		case .rgba:
			return "rgba(\(r),\(g),\(b),\(value.alpha))"
		}
	}
}

@available(macOS 12.0, *)
public extension FormatStyle where Self == Color.FormatStyle {
	static var hex: Self { .init(.hex) }
	static var hexAlpha: Self { .init(.hexAlpha) }
	static var rgba: Self { .init(.rgba) }
}
