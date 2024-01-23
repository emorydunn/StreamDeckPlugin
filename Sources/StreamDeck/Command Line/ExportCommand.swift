//
//  ExportCommand.swift
//  
//
//  Created by Emory Dunn on 11/17/21.
//

import Foundation
import ArgumentParser

/// Conveniently export the plugin.
///
/// The `export` command generates the plugin's manifest and copies the binary to the Plugins Folder.
struct ExportCommand: ParsableCommand {

	/// Export command configuration.
	public static var configuration = CommandConfiguration(
		commandName: "export",
		abstract: "Conveniently export the plugin.",
		discussion: "Automatically generate the manifest and copy the executable to the Plugins folder.")

	/// Flags for manifest generation.
	enum ManifestGeneration: String, EnumerableFlag {
		case generateManifest
		case previewManifest
	}

	@Argument(help: "The URI for your plugin")
	/// The URI for your plugin
	var uri: String

	@Option(name: .shortAndLong,
			help: "The folder in which to create the plugin's directory. (default: ~/Library/Application Support/com.elgato.StreamDeck/Plugins)",
			completion: .directory)
	/// The folder in which to create the plugin's directory
	var output: URL?

	@Flag(exclusivity: FlagExclusivity.exclusive, help: "Encode the manifest for the plugin and either save or preview it.")
	/// Encode the manifest for the plugin and either save or preview it.
	var manifest: ManifestGeneration?

	@Option(name: .shortAndLong, help: "The name of the manifest file.")
	/// The name of the manifest file.
	var manifestName: String = "manifest.json"

	@Flag(name: .shortAndLong, help: "Copy the executable file.")
	/// Copy the executable file.
	var copyExecutable: Bool = false

	@Option(name: .shortAndLong, help: "The name of the executable file.")
	/// The name of the executable file.
	var executableName: String?

	var manifestEncoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [
			.prettyPrinted,
			.withoutEscapingSlashes,
			.sortedKeys]

		encoder.keyEncodingStrategy = .custom { keys -> CodingKey in
			StreamDeckKey(key: keys.last!)
		}
	}()

	var standardEncoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [
			.prettyPrinted,
			.withoutEscapingSlashes,
			.sortedKeys]
	}()

	/// Determine the location of the plugins directory.
	///
	/// If `--url` was specified this method returns that URL. Otherwise it constructs `~/Library/Application Support/com.elgato.StreamDeck/Plugins`
	/// - Returns: The URL for the Stream Deck Plugins directory.
	func pluginsDir() throws -> URL {
		if let url = output {
			return url
		}

		var appSupport = try FileManager.default.url(
			for: .applicationSupportDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true)

		appSupport.appendPathComponent("com.elgato.StreamDeck/Plugins")

		return appSupport
	}

	/// Run the command.
	func run() throws {

		// Determine the root folder for the plugin
		var root = try pluginsDir().appendingPathComponent(uri)

		// Add the plugin extension if needed
		if root.pathExtension != "sdPlugin" {
			root.appendPathExtension("sdPlugin")
		}

		// Create the plugin directory
		try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true, attributes: nil)

		try generateManifestFile(in: root)
		try copyExecutable(to: root)

	}

	/// Copy the current executable to the plugin folder.
	/// - Parameter folder: The folder in which to copy the executable.
	func copyExecutable(to folder: URL) throws {

		guard copyExecutable else { return }

		// Get the current executable
		guard let exePath = Bundle.main.executableURL else {
			print("ERROR: Could not determine the current executable's path.")
			return
		}

		let newName: String
		if let name = executableName {
			newName = name
		} else {
			newName = exePath.lastPathComponent
		}

		let newPath = folder.appendingPathComponent(newName)

		try? FileManager.default.removeItem(at: newPath)
		try FileManager.default.copyItem(at: exePath, to: newPath)

		print("Copied \(exePath.lastPathComponent) -> \(newPath.path)")
	}

	/// Generate the plugin manifest file.
	/// - Parameter folder: The folder in which to write the manifest.
	func generateManifestFile(in folder: URL) throws {

		guard let plugin = PluginCommand.plugin else {
			print("Call `PluginManager.main(plugin:manifest:)` with a PluginManifest.")
			return
		}

		// Check actions for duplicate UUIDs
		let actionIDs = Dictionary(grouping: plugin.actions) { $0.uuid }
		try actionIDs.forEach { uuid, actions in
			if actions.count != 1 {
				throw StreamDeckError.duplicateUUIDs(uuid)
			}
		}

		// Encode the manifest
		let pluginManifest = PluginManifest(plugin: plugin)
		let data = try manifestEncoder.encode(pluginManifest)

		switch manifest {
		case .generateManifest:
			var outputURL = folder.appendingPathComponent(manifestName)

			if outputURL.pathExtension != "json" {
				outputURL.appendPathExtension("json")
			}

			// Attempt to write the file
			try data.write(to: outputURL)

			print("Wrote manifest to \(outputURL.path)")

			// Encode the layouts
			let layoutFolder = folder.appendingPathComponent("Layouts")
			try FileManager.default.createDirectory(at: layoutFolder, withIntermediateDirectories: true)

			for layout in plugin.layouts {
				let data =  try standardEncoder.encode(layout)
				let url = layoutFolder.appendingPathComponent("\(layout.id).json")
				try data.write(to: url)
				print("Wrote layout '\(layout.id)'")
			}

		case .previewManifest:
			print(String(decoding: data, as: UTF8.self))
		case nil:
			break
		}

	}

}
