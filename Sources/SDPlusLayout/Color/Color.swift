//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation
//import Silica

/// A set of components that define a color. The color space is defined by the drawing context.
public struct Color: Equatable, Hashable, Codable {
    
    /// Red value
    public let red: Double
    
    /// Green value
    public let green: Double
    
    /// Blue value
    public let blue: Double
    
    /// Alpha value
    public let alpha: Double
    
    /// The grey value of the color, determined by averaging the channels.
    public var grey: Double {
        return (red + green + blue) / 3
    }

    /// Instantiate a new Color
    ///
    /// /// This method expects color values between `0` and `1`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red.clamped(to: 0...1)
        self.green = green.clamped(to: 0...1)
        self.blue = blue.clamped(to: 0...1)
        self.alpha = alpha.clamped(to: 0...1)
    }

    /// Instantiate a new Color
    ///
    /// This method expects color values between `0` and `255`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Double = 1) {
        self.init(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            alpha: alpha
        )
    }

    /// Create a grey
    /// - Parameters:
    ///   - grey: Decimal grey value
    ///   - a: Alpha value, from 0 to 1
    public init(grey: Double, _ alpha: Double = 1) {
        self.init(red: grey, green: grey, blue: grey, alpha: alpha)
    }

    /// Create  a color from a hex string
    /// From: https://stackoverflow.com/a/26341062
    public init(hexString: String, alpha: Double) {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "")

        self.alpha = alpha
        self.red = Color.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        self.green = Color.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        self.blue = Color.colorComponentFrom(colorString: colorString, start: 4, length: 2)
    }

	/// Create  a color from a hex string
	/// From: https://stackoverflow.com/a/26341062
	public init(hexString: String) {
		var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
		colorString = colorString.replacingOccurrences(of: "#", with: "")

		self.red = Color.colorComponentFrom(colorString: colorString, start: 0, length: 2)
		self.green = Color.colorComponentFrom(colorString: colorString, start: 2, length: 2)
		self.blue = Color.colorComponentFrom(colorString: colorString, start: 4, length: 2)

		if colorString.count == 8 {
			self.alpha = Color.colorComponentFrom(colorString: colorString, start: 6, length: 2)
		} else {
			self.alpha = 1
		}
	}

	/// Create a Color from the specified color components.
	///
	/// Depending on the number of components given either a greyscale or RGB color will be initialized.
	///
	/// | Count | Colorspace | Alpha          |
	/// | ----- | ---------- | -------------- |
	/// | 1     | Greyscale  | 1              |
	/// | 2     | Greyscale  | last component |
	/// | 3     | RGB        | 1              |
	/// | 4     | RGB        | last component |
	///
	/// - Parameter components: The color components.
	public init(fromComponents components: [Double]) {
		switch components.count {
			case 0:
				// No components given, default to black
				self = Color.black
			case 1: // Greyscale Colorspace
				self.init(grey: components[0], 1)
			case 2: // Greyscale Colorspace
				self.init(grey: components[0], components[1])
			case 3:
				self.init(red: components[0],
								 green: components[1],
								 blue: components[2],
								 alpha: 1)
			case 4:
				self.init(red: components[0],
									 green: components[1],
									 blue: components[2],
									 alpha: components[3])
			default:
				// Extra components given, just grab the first four
				self.init(red: components[0],
								 green: components[1],
								 blue: components[2],
								 alpha: components[3])

		}
	}
    
    /// Determine the float value of a color component from it's hex representation in a string
    /// - Parameters:
    ///   - colorString: The full hex color value
    ///   - start: The starting position of the component value
    ///   - length: The length of the component value
    /// - Returns: The floating point value of the color component
    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> Double {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0


        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat = Double(hexComponent)
        let floatValue = Double(hexFloat / 255.0)
        return floatValue
    }

	@available(macOS, deprecated: 12.0, message: "Use .formatted(.hex)")
    /// Convert to a hex string
    /// From: https://stackoverflow.com/a/26341062
    public func toHex() -> String {
        let r = lround(red * 255) // swiftlint:disable:this identifier_name
        let g = lround(green * 255) // swiftlint:disable:this identifier_name
        let b = lround(blue * 255) // swiftlint:disable:this identifier_name

        let hexString = String.init(format: "#%02lX%02lX%02lX", r, g, b)
        return hexString
    }

	@available(macOS, deprecated: 12.0, message: "Use .formatted(.rgba)")
    /// Returns an RGBA string
    public func toRGBA() -> String {
        let r = lround(red * 255) // swiftlint:disable:this identifier_name
        let g = lround(green * 255) // swiftlint:disable:this identifier_name
        let b = lround(blue * 255) // swiftlint:disable:this identifier_name

        return "rgba(\(r),\(g),\(b),\(alpha))"
    }

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self.formatted(.hex))
	}


	// MARK: Opacity Modification
	/// Return the color without transparency.
	public var withoutAlpha: Color {
		Color(red: red, green: green, blue: blue)
	}

	public func withAlpha(_ alpha: Double) -> Color {
		Color(red: red, green: green, blue: blue, alpha: alpha)
	}

	// MARK: - Default Colors

	/// Clear
	public static let clear = Color(grey: 0, 0)
    
	/// CSS `aliceblue`
	public static let aliceblue = Color(hexString: "#F0F8FF")
	/// CSS `antiquewhite`
	public static let antiquewhite = Color(hexString: "#FAEBD7")
	/// CSS `aqua`
	public static let aqua = Color(hexString: "#00FFFF")
	/// CSS `aquamarine`
	public static let aquamarine = Color(hexString: "#7FFFD4")
	/// CSS `azure`
	public static let azure = Color(hexString: "#F0FFFF")
	/// CSS `beige`
	public static let beige = Color(hexString: "#F5F5DC")
	/// CSS `bisque`
	public static let bisque = Color(hexString: "#FFE4C4")
	/// CSS `black`
	public static let black = Color(hexString: "#000000")
	/// CSS `blanchedalmond`
	public static let blanchedalmond = Color(hexString: "#FFEBCD")
	/// CSS `blue`
	public static let blue = Color(hexString: "#0000FF")
	/// CSS `blueviolet`
	public static let blueviolet = Color(hexString: "#8A2BE2")
	/// CSS `brown`
	public static let brown = Color(hexString: "#A52A2A")
	/// CSS `burlywood`
	public static let burlywood = Color(hexString: "#DEB887")
	/// CSS `cadetblue`
	public static let cadetblue = Color(hexString: "#5F9EA0")
	/// CSS `chartreuse`
	public static let chartreuse = Color(hexString: "#7FFF00")
	/// CSS `chocolate`
	public static let chocolate = Color(hexString: "#D2691E")
	/// CSS `coral`
	public static let coral = Color(hexString: "#FF7F50")
	/// CSS `cornflowerblue`
	public static let cornflowerblue = Color(hexString: "#6495ED")
	/// CSS `cornsilk`
	public static let cornsilk = Color(hexString: "#FFF8DC")
	/// CSS `crimson`
	public static let crimson = Color(hexString: "#DC143C")
	/// CSS `cyan`
	public static let cyan = Color(hexString: "#00FFFF")
	/// CSS `darkblue`
	public static let darkblue = Color(hexString: "#00008B")
	/// CSS `darkcyan`
	public static let darkcyan = Color(hexString: "#008B8B")
	/// CSS `darkgoldenrod`
	public static let darkgoldenrod = Color(hexString: "#B8860B")
	/// CSS `darkgray`
	public static let darkgray = Color(hexString: "#A9A9A9")
	/// CSS `darkgreen`
	public static let darkgreen = Color(hexString: "#006400")
	/// CSS `darkgrey`
	public static let darkgrey = Color(hexString: "#A9A9A9")
	/// CSS `darkkhaki`
	public static let darkkhaki = Color(hexString: "#BDB76B")
	/// CSS `darkmagenta`
	public static let darkmagenta = Color(hexString: "#8B008B")
	/// CSS `darkolivegreen`
	public static let darkolivegreen = Color(hexString: "#556B2F")
	/// CSS `darkorange`
	public static let darkorange = Color(hexString: "#FF8C00")
	/// CSS `darkorchid`
	public static let darkorchid = Color(hexString: "#9932CC")
	/// CSS `darkred`
	public static let darkred = Color(hexString: "#8B0000")
	/// CSS `darksalmon`
	public static let darksalmon = Color(hexString: "#E9967A")
	/// CSS `darkseagreen`
	public static let darkseagreen = Color(hexString: "#8FBC8F")
	/// CSS `darkslateblue`
	public static let darkslateblue = Color(hexString: "#483D8B")
	/// CSS `darkslategray`
	public static let darkslategray = Color(hexString: "#2F4F4F")
	/// CSS `darkslategrey`
	public static let darkslategrey = Color(hexString: "#2F4F4F")
	/// CSS `darkturquoise`
	public static let darkturquoise = Color(hexString: "#00CED1")
	/// CSS `darkviolet`
	public static let darkviolet = Color(hexString: "#9400D3")
	/// CSS `deeppink`
	public static let deeppink = Color(hexString: "#FF1493")
	/// CSS `deepskyblue`
	public static let deepskyblue = Color(hexString: "#00BFFF")
	/// CSS `dimgray`
	public static let dimgray = Color(hexString: "#696969")
	/// CSS `dimgrey`
	public static let dimgrey = Color(hexString: "#696969")
	/// CSS `dodgerblue`
	public static let dodgerblue = Color(hexString: "#1E90FF")
	/// CSS `firebrick`
	public static let firebrick = Color(hexString: "#B22222")
	/// CSS `floralwhite`
	public static let floralwhite = Color(hexString: "#FFFAF0")
	/// CSS `forestgreen`
	public static let forestgreen = Color(hexString: "#228B22")
	/// CSS `fuchsia`
	public static let fuchsia = Color(hexString: "#FF00FF")
	/// CSS `gainsboro`
	public static let gainsboro = Color(hexString: "#DCDCDC")
	/// CSS `ghostwhite`
	public static let ghostwhite = Color(hexString: "#F8F8FF")
	/// CSS `gold`
	public static let gold = Color(hexString: "#FFD700")
	/// CSS `goldenrod`
	public static let goldenrod = Color(hexString: "#DAA520")
	/// CSS `gray`
	public static let gray = Color(hexString: "#808080")
	/// CSS `grey`
	public static let grey = Color(hexString: "#808080")
	/// CSS `green`
	public static let green = Color(hexString: "#008000")
	/// CSS `greenyellow`
	public static let greenyellow = Color(hexString: "#ADFF2F")
	/// CSS `honeydew`
	public static let honeydew = Color(hexString: "#F0FFF0")
	/// CSS `hotpink`
	public static let hotpink = Color(hexString: "#FF69B4")
	/// CSS `indianred`
	public static let indianred = Color(hexString: "#CD5C5C")
	/// CSS `indigo`
	public static let indigo = Color(hexString: "#4B0082")
	/// CSS `ivory`
	public static let ivory = Color(hexString: "#FFFFF0")
	/// CSS `khaki`
	public static let khaki = Color(hexString: "#F0E68C")
	/// CSS `lavender`
	public static let lavender = Color(hexString: "#E6E6FA")
	/// CSS `lavenderblush`
	public static let lavenderblush = Color(hexString: "#FFF0F5")
	/// CSS `lawngreen`
	public static let lawngreen = Color(hexString: "#7CFC00")
	/// CSS `lemonchiffon`
	public static let lemonchiffon = Color(hexString: "#FFFACD")
	/// CSS `lightblue`
	public static let lightblue = Color(hexString: "#ADD8E6")
	/// CSS `lightcoral`
	public static let lightcoral = Color(hexString: "#F08080")
	/// CSS `lightcyan`
	public static let lightcyan = Color(hexString: "#E0FFFF")
	/// CSS `lightgoldenrodyellow`
	public static let lightgoldenrodyellow = Color(hexString: "#FAFAD2")
	/// CSS `lightgray`
	public static let lightgray = Color(hexString: "#D3D3D3")
	/// CSS `lightgreen`
	public static let lightgreen = Color(hexString: "#90EE90")
	/// CSS `lightgrey`
	public static let lightgrey = Color(hexString: "#D3D3D3")
	/// CSS `lightpink`
	public static let lightpink = Color(hexString: "#FFB6C1")
	/// CSS `lightsalmon`
	public static let lightsalmon = Color(hexString: "#FFA07A")
	/// CSS `lightseagreen`
	public static let lightseagreen = Color(hexString: "#20B2AA")
	/// CSS `lightskyblue`
	public static let lightskyblue = Color(hexString: "#87CEFA")
	/// CSS `lightslategray`
	public static let lightslategray = Color(hexString: "#778899")
	/// CSS `lightslategrey`
	public static let lightslategrey = Color(hexString: "#778899")
	/// CSS `lightsteelblue`
	public static let lightsteelblue = Color(hexString: "#B0C4DE")
	/// CSS `lightyellow`
	public static let lightyellow = Color(hexString: "#FFFFE0")
	/// CSS `lime`
	public static let lime = Color(hexString: "#00FF00")
	/// CSS `limegreen`
	public static let limegreen = Color(hexString: "#32CD32")
	/// CSS `linen`
	public static let linen = Color(hexString: "#FAF0E6")
	/// CSS `magenta`
	public static let magenta = Color(hexString: "#FF00FF")
	/// CSS `maroon`
	public static let maroon = Color(hexString: "#800000")
	/// CSS `mediumaquamarine`
	public static let mediumaquamarine = Color(hexString: "#66CDAA")
	/// CSS `mediumblue`
	public static let mediumblue = Color(hexString: "#0000CD")
	/// CSS `mediumorchid`
	public static let mediumorchid = Color(hexString: "#BA55D3")
	/// CSS `mediumpurple`
	public static let mediumpurple = Color(hexString: "#9370DB")
	/// CSS `mediumseagreen`
	public static let mediumseagreen = Color(hexString: "#3CB371")
	/// CSS `mediumslateblue`
	public static let mediumslateblue = Color(hexString: "#7B68EE")
	/// CSS `mediumspringgreen`
	public static let mediumspringgreen = Color(hexString: "#00FA9A")
	/// CSS `mediumturquoise`
	public static let mediumturquoise = Color(hexString: "#48D1CC")
	/// CSS `mediumvioletred`
	public static let mediumvioletred = Color(hexString: "#C71585")
	/// CSS `midnightblue`
	public static let midnightblue = Color(hexString: "#191970")
	/// CSS `mintcream`
	public static let mintcream = Color(hexString: "#F5FFFA")
	/// CSS `mistyrose`
	public static let mistyrose = Color(hexString: "#FFE4E1")
	/// CSS `moccasin`
	public static let moccasin = Color(hexString: "#FFE4B5")
	/// CSS `navajowhite`
	public static let navajowhite = Color(hexString: "#FFDEAD")
	/// CSS `navy`
	public static let navy = Color(hexString: "#000080")
	/// CSS `oldlace`
	public static let oldlace = Color(hexString: "#FDF5E6")
	/// CSS `olive`
	public static let olive = Color(hexString: "#808000")
	/// CSS `olivedrab`
	public static let olivedrab = Color(hexString: "#6B8E23")
	/// CSS `orange`
	public static let orange = Color(hexString: "#FFA500")
	/// CSS `orangered`
	public static let orangered = Color(hexString: "#FF4500")
	/// CSS `orchid`
	public static let orchid = Color(hexString: "#DA70D6")
	/// CSS `palegoldenrod`
	public static let palegoldenrod = Color(hexString: "#EEE8AA")
	/// CSS `palegreen`
	public static let palegreen = Color(hexString: "#98FB98")
	/// CSS `paleturquoise`
	public static let paleturquoise = Color(hexString: "#AFEEEE")
	/// CSS `palevioletred`
	public static let palevioletred = Color(hexString: "#DB7093")
	/// CSS `papayawhip`
	public static let papayawhip = Color(hexString: "#FFEFD5")
	/// CSS `peachpuff`
	public static let peachpuff = Color(hexString: "#FFDAB9")
	/// CSS `peru`
	public static let peru = Color(hexString: "#CD853F")
	/// CSS `pink`
	public static let pink = Color(hexString: "#FFC0CB")
	/// CSS `plum`
	public static let plum = Color(hexString: "#DDA0DD")
	/// CSS `powderblue`
	public static let powderblue = Color(hexString: "#B0E0E6")
	/// CSS `purple`
	public static let purple = Color(hexString: "#800080")
	/// CSS `red`
	public static let red = Color(hexString: "#FF0000")
	/// CSS `rosybrown`
	public static let rosybrown = Color(hexString: "#BC8F8F")
	/// CSS `royalblue`
	public static let royalblue = Color(hexString: "#4169E1")
	/// CSS `saddlebrown`
	public static let saddlebrown = Color(hexString: "#8B4513")
	/// CSS `salmon`
	public static let salmon = Color(hexString: "#FA8072")
	/// CSS `sandybrown`
	public static let sandybrown = Color(hexString: "#F4A460")
	/// CSS `seagreen`
	public static let seagreen = Color(hexString: "#2E8B57")
	/// CSS `seashell`
	public static let seashell = Color(hexString: "#2E8B57")
	/// CSS `sienna`
	public static let sienna = Color(hexString: "#A0522D")
	/// CSS `silver`
	public static let silver = Color(hexString: "#C0C0C0")
	/// CSS `skyblue`
	public static let skyblue = Color(hexString: "#87CEEB")
	/// CSS `slateblue`
	public static let slateblue = Color(hexString: "#6A5ACD")
	/// CSS `slategray`
	public static let slategray = Color(hexString: "#708090")
	/// CSS `slategrey`
	public static let slategrey = Color(hexString: "#708090")
	/// CSS `snow`
	public static let snow = Color(hexString: "#FFFAFA")
	/// CSS `springgreen`
	public static let springgreen = Color(hexString: "#00FF7F")
	/// CSS `steelblue`
	public static let steelblue = Color(hexString: "#4682B4")
	/// CSS `tan`
	public static let tan = Color(hexString: "#D2B48C")
	/// CSS `teal`
	public static let teal = Color(hexString: "#008080")
	/// CSS `thistle`
	public static let thistle = Color(hexString: "#D8BFD8")
	/// CSS `tomato`
	public static let tomato = Color(hexString: "#FF6347")
	/// CSS `turquoise`
	public static let turquoise = Color(hexString: "#40E0D0")
	/// CSS `violet`
	public static let violet = Color(hexString: "#EE82EE")
	/// CSS `wheat`
	public static let wheat = Color(hexString: "#F5DEB3")
	/// CSS `white`
	public static let white = Color(hexString: "#FFFFFF")
	/// CSS `whitesmoke`
	public static let whitesmoke = Color(hexString: "#F5F5F5")
	/// CSS `yellow`
	public static let yellow = Color(hexString: "#FFFF00")
	/// CSS `yellowgreen`
	public static let yellowgreen = Color(hexString: "#9ACD32")

}

extension Color {
	/// Create a color from an SVG color name.
	///
	/// - Parameter name: The name of the color.
	public init?(name: String) {

		switch name {
		case "aliceblue":
			self = Color.aliceblue
		case "antiquewhite":
			self = Color.antiquewhite
		case "aqua":
			self = Color.aqua
		case "aquamarine":
			self = Color.aquamarine
		case "azure":
			self = Color.azure
		case "beige":
			self = Color.beige
		case "bisque":
			self = Color.bisque
		case "black":
			self = Color.black
		case "blanchedalmond":
			self = Color.blanchedalmond
		case "blue":
			self = Color.blue
		case "blueviolet":
			self = Color.blueviolet
		case "brown":
			self = Color.brown
		case "burlywood":
			self = Color.burlywood
		case "cadetblue":
			self = Color.cadetblue
		case "chartreuse":
			self = Color.chartreuse
		case "chocolate":
			self = Color.chocolate
		case "coral":
			self = Color.coral
		case "cornflowerblue":
			self = Color.cornflowerblue
		case "cornsilk":
			self = Color.cornsilk
		case "crimson":
			self = Color.crimson
		case "cyan":
			self = Color.cyan
		case "darkblue":
			self = Color.darkblue
		case "darkcyan":
			self = Color.darkcyan
		case "darkgoldenrod":
			self = Color.darkgoldenrod
		case "darkgray":
			self = Color.darkgray
		case "darkgreen":
			self = Color.darkgreen
		case "darkgrey":
			self = Color.darkgrey
		case "darkkhaki":
			self = Color.darkkhaki
		case "darkmagenta":
			self = Color.darkmagenta
		case "darkolivegreen":
			self = Color.darkolivegreen
		case "darkorange":
			self = Color.darkorange
		case "darkorchid":
			self = Color.darkorchid
		case "darkred":
			self = Color.darkred
		case "darksalmon":
			self = Color.darksalmon
		case "darkseagreen":
			self = Color.darkseagreen
		case "darkslateblue":
			self = Color.darkslateblue
		case "darkslategray":
			self = Color.darkslategray
		case "darkslategrey":
			self = Color.darkslategrey
		case "darkturquoise":
			self = Color.darkturquoise
		case "darkviolet":
			self = Color.darkviolet
		case "deeppink":
			self = Color.deeppink
		case "deepskyblue":
			self = Color.deepskyblue
		case "dimgray":
			self = Color.dimgray
		case "dimgrey":
			self = Color.dimgrey
		case "dodgerblue":
			self = Color.dodgerblue
		case "firebrick":
			self = Color.firebrick
		case "floralwhite":
			self = Color.floralwhite
		case "forestgreen":
			self = Color.forestgreen
		case "fuchsia":
			self = Color.fuchsia
		case "gainsboro":
			self = Color.gainsboro
		case "ghostwhite":
			self = Color.ghostwhite
		case "gold":
			self = Color.gold
		case "goldenrod":
			self = Color.goldenrod
		case "gray":
			self = Color.gray
		case "grey":
			self = Color.grey
		case "green":
			self = Color.green
		case "greenyellow":
			self = Color.greenyellow
		case "honeydew":
			self = Color.honeydew
		case "hotpink":
			self = Color.hotpink
		case "indianred":
			self = Color.indianred
		case "indigo":
			self = Color.indigo
		case "ivory":
			self = Color.ivory
		case "khaki":
			self = Color.khaki
		case "lavender":
			self = Color.lavender
		case "lavenderblush":
			self = Color.lavenderblush
		case "lawngreen":
			self = Color.lawngreen
		case "lemonchiffon":
			self = Color.lemonchiffon
		case "lightblue":
			self = Color.lightblue
		case "lightcoral":
			self = Color.lightcoral
		case "lightcyan":
			self = Color.lightcyan
		case "lightgoldenrodyellow":
			self = Color.lightgoldenrodyellow
		case "lightgray":
			self = Color.lightgray
		case "lightgreen":
			self = Color.lightgreen
		case "lightgrey":
			self = Color.lightgrey
		case "lightpink":
			self = Color.lightpink
		case "lightsalmon":
			self = Color.lightsalmon
		case "lightseagreen":
			self = Color.lightseagreen
		case "lightskyblue":
			self = Color.lightskyblue
		case "lightslategray":
			self = Color.lightslategray
		case "lightslategrey":
			self = Color.lightslategrey
		case "lightsteelblue":
			self = Color.lightsteelblue
		case "lightyellow":
			self = Color.lightyellow
		case "lime":
			self = Color.lime
		case "limegreen":
			self = Color.limegreen
		case "linen":
			self = Color.linen
		case "magenta":
			self = Color.magenta
		case "maroon":
			self = Color.maroon
		case "mediumaquamarine":
			self = Color.mediumaquamarine
		case "mediumblue":
			self = Color.mediumblue
		case "mediumorchid":
			self = Color.mediumorchid
		case "mediumpurple":
			self = Color.mediumpurple
		case "mediumseagreen":
			self = Color.mediumseagreen
		case "mediumslateblue":
			self = Color.mediumslateblue
		case "mediumspringgreen":
			self = Color.mediumspringgreen
		case "mediumturquoise":
			self = Color.mediumturquoise
		case "mediumvioletred":
			self = Color.mediumvioletred
		case "midnightblue":
			self = Color.midnightblue
		case "mintcream":
			self = Color.mintcream
		case "mistyrose":
			self = Color.mistyrose
		case "moccasin":
			self = Color.moccasin
		case "navajowhite":
			self = Color.navajowhite
		case "navy":
			self = Color.navy
		case "oldlace":
			self = Color.oldlace
		case "olive":
			self = Color.olive
		case "olivedrab":
			self = Color.olivedrab
		case "orange":
			self = Color.orange
		case "orangered":
			self = Color.orangered
		case "orchid":
			self = Color.orchid
		case "palegoldenrod":
			self = Color.palegoldenrod
		case "palegreen":
			self = Color.palegreen
		case "paleturquoise":
			self = Color.paleturquoise
		case "palevioletred":
			self = Color.palevioletred
		case "papayawhip":
			self = Color.papayawhip
		case "peachpuff":
			self = Color.peachpuff
		case "peru":
			self = Color.peru
		case "pink":
			self = Color.pink
		case "plum":
			self = Color.plum
		case "powderblue":
			self = Color.powderblue
		case "purple":
			self = Color.purple
		case "red":
			self = Color.red
		case "rosybrown":
			self = Color.rosybrown
		case "royalblue":
			self = Color.royalblue
		case "saddlebrown":
			self = Color.saddlebrown
		case "salmon":
			self = Color.salmon
		case "sandybrown":
			self = Color.sandybrown
		case "seagreen":
			self = Color.seagreen
		case "seashell":
			self = Color.seashell
		case "sienna":
			self = Color.sienna
		case "silver":
			self = Color.silver
		case "skyblue":
			self = Color.skyblue
		case "slateblue":
			self = Color.slateblue
		case "slategray":
			self = Color.slategray
		case "slategrey":
			self = Color.slategrey
		case "snow":
			self = Color.snow
		case "springgreen":
			self = Color.springgreen
		case "steelblue":
			self = Color.steelblue
		case "tan":
			self = Color.tan
		case "teal":
			self = Color.teal
		case "thistle":
			self = Color.thistle
		case "tomato":
			self = Color.tomato
		case "turquoise":
			self = Color.turquoise
		case "violet":
			self = Color.violet
		case "wheat":
			self = Color.wheat
		case "white":
			self = Color.white
		case "whitesmoke":
			self = Color.whitesmoke
		case "yellow":
			self = Color.yellow
		case "yellowgreen":
			self = Color.yellowgreen
		default:
			return nil
		}
	}
}
