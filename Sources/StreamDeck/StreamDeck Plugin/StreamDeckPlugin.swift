//
//  StreamdeckPlugin.swift
//  
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "StreamDeckPlugin")

/// An object that manages a plugins’s main event loop.
public final class StreamDeckPlugin {

	/// The shared plugin.
	public static var shared: StreamDeckPlugin!

	/// The plugin's delegate object.
	public let plugin: any PluginDelegate

	/// The task used for communicating with the Stream Deck application.
	let task: URLSessionWebSocketTask

	/// Instances of actions.
	public private(set) var instances: [String: any Action] = [:]

	let encoder = JSONEncoder()
	let decoder = JSONDecoder()

	/// A flag indicating global settings need to be loaded.
	///
	/// The first event after registration will request the global settings and toggle this value.
	private var shouldLoadSettings = true

	/// The number of WebSocket errors encountered.
	///
	/// This is incremented on every error and reset on success.
	/// WebSocket errors most likely mean the plugin is still running after the 
	/// StreamDeck app has quit or crashed.
	private var webSocketErrorCount = 0

	// MARK: Streamdeck Properties

	/// The port that should be used to create the WebSocket
	public let port: Int32

	/// A unique identifier string that should be used to register the plugin once the WebSocket is opened.
	public let uuid: String

	/// The event type that should be used to register the plugin once the WebSocket is opened
	public let event: String

	/// The Stream Deck application information and devices information.
	public let info: PluginRegistrationInfo

	init(plugin: any PluginDelegate, port: Int32, uuid: String, event: String, info: PluginRegistrationInfo) {
		self.plugin = plugin
		self.port = port
		self.uuid = uuid
		self.event = event
		self.info = info

		let url = URL(string: "ws://localhost:\(port)")!
		self.task = URLSession.shared.webSocketTask(with: url)

	}

	// MARK: - InstanceManager

	/// Look up the action type based on the UUID.
	/// - Parameter uuid: The UUID of the action.
	/// - Returns: The action's type, if available.
	public func action(forID uuid: String) -> (any Action.Type)? {
		type(of: plugin).actions.first { $0.uuid == uuid }
	}

	/// Register a new instance of an action from a `willAppear` event.
	/// - Parameter event: The event with information about the instance.
	public func registerInstance(actionID: String, context: String, coordinates: Coordinates?) {

		// Check if the instance already exists
		guard instances[context] == nil else {
			log.log("This instance has already been registered.")
			return
		}

		// Look up the action
		guard let actionType = action(forID: actionID) else {
			log.log("No action available with UUID '\(actionID, privacy: .public)'.")
			return
		}

		// Initialize a new instance
		instances[context] = actionType.init(context: context, coordinates: coordinates)

		log.log("Initialized a new instance of '\(actionType.uuid, privacy: .public)'")
	}

	/// Remove an instance of an action from a `willDisappear` event.
	/// - Parameter event: The event with information about the instance.
	public func removeInstance(_ context: String?) {
		guard let context else { return }
		log.log("Removing instance of '\(context, privacy: .public)'")
		instances[context] = nil
	}

	/// Return an action by its context.
	public subscript (context: String) -> (any Action)? { instances[context] }

	public subscript (context: String?) -> (any Action)? {
		guard let context else { return nil }
		return instances[context]
	}


	// MARK: - WebSocket Methods
	/// Continually receive messages from the socket.
	func monitorSocket() {

		if task.state == .suspended {
			log.log("Connecting to Stream Deck application")
			task.resume()
		}

		self.task.receive { [weak self] result in

			// Handle a new message
			switch result {
			case let .success(message):
				self?.parseMessage(message)
				self?.webSocketErrorCount = 0
			case let .failure(error):
				log.error("WebSocket Error: \(error)")
				self?.webSocketErrorCount += 1
				break
			}

			if self?.webSocketErrorCount == 50 {
				log.warning("There have been 50 WebSocket errors in a row, the StreamDeck app is probably no longer running. Terminating.")
				exit(0)
			}

			// Queue for the next message
			self?.monitorSocket()
		}

	}

	/// Sends a WebSocket message, receiving the result in a completion handler.
	///
	/// If an error occurs while sending the message, any outstanding work also fails.
	/// - Parameters:
	///   - message: The WebSocket message to send to the other endpoint.
	///   - completionHandler: A closure that receives an NSError that indicates an error encountered while sending, or nil if no error occurred.
	func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) {
		task.send(message, completionHandler: completionHandler)
	}

	func parseMessage(_ message: URLSessionWebSocketTask.Message) {
		guard let data = readMessage(message) else {
			log.warning("WebSocket sent empty message")
			return
		}

		// Decode the event from the data
		do {
			let eventKey = try decoder.decode(ReceivableEvent.self, from: data)
			try parseEvent(event: eventKey.event, context: eventKey.context, data: data)
		} catch let error as DecodingError {
			let json = String(data: data, encoding: .utf8) ?? "could not read string from JSON"

			log.error("""
			Decoding Error:
			\(error)
			\(json)
			""")

		} catch {
			let json = String(data: data, encoding: .utf8) ?? "could not read string from JSON"
			log.error("Decoding Error: \(error.localizedDescription)\n\(json)")
		}

	}

	/// Interpret the message as either Data or a UTF-8 encoded data.
	func readMessage(_ message: URLSessionWebSocketTask.Message) -> Data? {
		switch message {
		case let .data(data):
			return data
		case let .string(string):
			return string.data(using: .utf8)
		@unknown default:
			log.warning("Warning: WebSocket sent unknown message")
			return nil
		}
	}


	// MARK: - Helper Functions

	/// Complete the registration handshake with the server.
	/// - Parameter properties: The properties provided by the Stream Deck application.
	/// - Throws: Errors while encoding the data to JSON.
	func registerPlugin() throws {
		let registrationEvent: [String: Any] = [
			"event": event,
			"uuid": uuid
		]

		guard JSONSerialization.isValidJSONObject(registrationEvent) else {
			throw StreamDeckError.invalidJSON(event, registrationEvent)
		}

		let data = try JSONSerialization.data(withJSONObject: registrationEvent, options: [])

		log.log("Sending registration event")
		send(URLSessionWebSocketTask.Message.data(data)) { error in
			if let error = error {
				log.error("Failed to send \(self.event) event.\n\(error.localizedDescription)")
			}
		}

	}

	/// Send raw events over the the socket.
	///
	/// - Parameters:
	///   - eventType: The event type.
	///   - context: The context token.
	///   - payload: The payload for the action.
	/// - Throws: Errors while encoding the data to JSON.
	public func sendEvent(_ eventType: SendableEventKey, action: String? = nil, context: String?, payload: [String: Any]?) {

		var event: [String: Any] = [
			"event": eventType.rawValue
		]

		event["action"] = action
		event["context"] = context
		event["payload"] = payload

		guard JSONSerialization.isValidJSONObject(event) else {
			log.log("Data for \(eventType.rawValue) is not valid JSON.")
			return
		}

		do {
			let data = try JSONSerialization.data(withJSONObject: event, options: [])

			task.send(URLSessionWebSocketTask.Message.data(data)) { error in
				if let error = error {
					log.error("Failed to send \(eventType.rawValue) event.\n\(error.localizedDescription)")
				} else {
					log.log("Completed \(eventType.rawValue)")
				}
			}
		} catch {
			log.error("\(error.localizedDescription).")
		}

	}

	/// Send raw events over the the socket.
	///
	/// - Parameters:
	///   - eventType: The event type.
	///   - context: The context token.
	///   - payload: The payload for the action.
	/// - Throws: Errors while encoding the data to JSON.
	public func sendEvent<P: Encodable>(_ eventType: SendableEventKey, action: String? = nil, context: String?, payload: P?) {

		// Construct the event to serialize and send
		let event = SendableEvent(event: eventType,
								  action: action,
								  context: context,
								  payload: payload)

		do {
			// Encode the event
			let data = try encoder.encode(event)

			// Send the event
			task.send(URLSessionWebSocketTask.Message.data(data)) { error in
				if let error = error {
					log.error("Failed to send \(eventType.rawValue) event.\n\(error.localizedDescription)")
				} else {
					log.log("Completed \(eventType.rawValue)")
				}
			}
		} catch {
			log.error("\(error.localizedDescription).")
		}

	}

	/// Send raw events over the the socket.
	///
	/// - Parameters:
	///   - eventType: The event type.
	///   - context: The context token.
	///   - payload: The payload for the action.
	/// - Throws: Errors while encoding the data to JSON.
	public func sendEvent<P: Encodable>(_ eventType: SendableEventKey, action: String? = nil, context: String?, payload: P?) async throws {

		// Construct the event to serialize and send
		let event = SendableEvent(event: eventType,
								  action: action,
								  context: context,
								  payload: payload)

		// Encode the event
		let data = try encoder.encode(event)

		try await task.send(URLSessionWebSocketTask.Message.data(data))

	}

	/// Parse an event received from the Stream Deck application.
	/// - Parameters:
	///   - event: The event key.
	///   - data: The JSON data.
	func parseEvent(event: ReceivableEvent.EventKey, context: String?, data: Data) throws {

		if shouldLoadSettings {
			log.log("Received first event, requesting global settings")
			// Get the initial global settings
			StreamDeckPlugin.shared.sendEvent(.getGlobalSettings,
											  context: StreamDeckPlugin.shared.uuid,
											  payload: nil)
			shouldLoadSettings = false
		}

		switch event {

		case .didReceiveSettings:

			log.info("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeSettings(data, using: decoder)

		case .didReceiveGlobalSettings:
			log.info("Forwarding \(event) to PluginDelegate")
			GlobalSettings.shared.updateSettings(fromEvent: data)

			for (_ , instance) in instances {
				instance.didReceiveGlobalSettings()
			}

		case .keyDown:
			log.info("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeKeyDown(data, using: decoder)

		case .keyUp:
			log.info("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeKeyUp(data, using: decoder)

		case .dialRotate:
			log.info("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeDialRotate(data, using: decoder)

		case .dialPress:
			log.info("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeDialUp(data, using: decoder)

		case .dialDown:
			log.info("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeDialDown(data, using: decoder)

		case .dialUp:
			log.info("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeDialUp(data, using: decoder)

		case .touchTap:
			log.info("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeTouchTap(data, using: decoder)

			if let json = String(data: data, encoding: .utf8) {
				log.debug("\(json)")
			}

		case .willAppear:
			log.info("Forwarding \(event) to \(context ?? "no context")")
			let action = try decoder.decode(ActionEvent<InstanceAppearEvent>.self, from: data)

			self.registerInstance(actionID: action.action, context: action.context, coordinates: action.payload.coordinates)

			try self[context]?.decodeWillAppear(data, using: decoder)
			//
			//            self[action.context]?.willAppear(device: action.device, payload: action.payload)
			//            plugin.willAppear(action: action.action, context: action.context, device: action.device, payload: action.payload)

		case .willDisappear:
			log.info("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeWillDisappear(data, using: decoder)
			//            let action = try decoder.decode(ActionEvent<AppearEvent>.self, from: data)
			//
			//            self[action.context]?.willDisappear(device: action.device, payload: action.payload)
			//            plugin.willDisappear(action: action.action, context: action.context, device: action.device, payload: action.payload)

			self.removeInstance(context)

		case .titleParametersDidChange:
			log.info("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeTitleParametersDidChange(data, using: decoder)

		case .deviceDidConnect:
			let action = try decoder.decode(DeviceConnectionEvent.self, from: data)

			log.info("Forwarding \(event) to PluginDelegate")
			plugin.deviceDidConnect(action.device, deviceInfo: action.deviceInfo!)

		case .deviceDidDisconnect:
			let action = try decoder.decode(DeviceConnectionEvent.self, from: data)

			log.info("Forwarding \(event) to PluginDelegate")
			plugin.deviceDidDisconnect(action.device)

		case .systemDidWakeUp:

			log.info("Forwarding \(event) to PluginDelegate")
			plugin.systemDidWakeUp()

		case .applicationDidLaunch:
			let action = try decoder.decode(ApplicationEvent.self, from: data)

			log.info("Forwarding \(event) to PluginDelegate")
			plugin.applicationDidLaunch(action.payload.application)

		case .applicationDidTerminate:
			let action = try decoder.decode(ApplicationEvent.self, from: data)

			log.info("Forwarding \(event) to PluginDelegate")
			plugin.applicationDidTerminate(action.payload.application)

		case .propertyInspectorDidAppear:
			let action = try decoder.decode(PropertyInspectorEvent.self, from: data)

			log.info("Forwarding \(event) to \(action.context)")
			self[action.context]?.propertyInspectorDidAppear(device: action.device)
			plugin.propertyInspectorDidAppear(action: action.action, context: action.context, device: action.device)

		case .propertyInspectorDidDisappear:
			let action = try decoder.decode(PropertyInspectorEvent.self, from: data)

			log.info("Forwarding \(event) to \(action.context)")

			self[action.context]?.propertyInspectorDidDisappear(device: action.device)
			plugin.propertyInspectorDidDisappear(action: action.action, context: action.context, device: action.device)
			
		case .sendToPlugin:
			log.info("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeSentToPlugin(data, using: decoder)
		}
	}
}
