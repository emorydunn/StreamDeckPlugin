//
//  NSImage+Base64.swift
//  
//
//  Created by Emory Dunn on 7/25/21.
//

import Cocoa

public extension NSImage {
	
	/// Create a prefixed base64 string.
	var base64String: String? {
		guard let rep = NSBitmapImageRep(
			bitmapDataPlanes: nil,
			pixelsWide: Int(size.width),
			pixelsHigh: Int(size.height),
			bitsPerSample: 8,
			samplesPerPixel: 4,
			hasAlpha: true,
			isPlanar: false,
			colorSpaceName: .calibratedRGB,
			bytesPerRow: 0,
			bitsPerPixel: 0
		) else {
			print("Couldn't create bitmap representation")
			return nil
		}
		
		NSGraphicsContext.saveGraphicsState()
		NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
		draw(at: NSZeroPoint, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
		NSGraphicsContext.restoreGraphicsState()
		
		guard let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]) else {
			print("Couldn't create PNG")
			return nil
		}
		
		// With prefix
		return "data:image/png;base64,\(data.base64EncodedString(options: []))"
		// Without prefix
		//        return data.base64EncodedString(options: [])
	}
}
