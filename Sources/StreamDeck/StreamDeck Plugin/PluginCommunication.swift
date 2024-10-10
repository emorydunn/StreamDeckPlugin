//
//  StreamdeckPlugin.swift
//  
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation
import OSLog

fileprivate let log = Logger(subsystem: "StreamDeckPlugin", category: "PluginCommunication")

/// An object that manages a plugins’s main event loop.
public final actor PluginCommunication {

	/// The shared plugin.
	public static var shared: PluginCommunication!

	/// The plugin's delegate object.
	public var plugin: (any Plugin)!

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

	init(port: Int32, uuid: String, event: String, info: PluginRegistrationInfo) {
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

	public func registerInstance(_ event:  ActionEvent<InstanceAppearEvent>) {
		// Check if the instance already exists
		guard instances[event.context] == nil else {
			log.log("This instance has already been registered.")
			return
		}

		// Look up the action
		guard let actionType = action(forID: event.action) else {
			log.log("No action available with UUID '\(event.action, privacy: .public)'.")
			return
		}

		// Register the controller type
		ActionControllerRegistry.shared.store(event.context, controller: event.payload.controller)

		// Initialize a new instance
		instances[event.context] = actionType.init(context: event.context, coordinates: event.payload.coordinates)

		log.log("Initialized a new instance of '\(actionType.uuid, privacy: .public)'")
	}

	/// Remove an instance of an action from a `willDisappear` event.
	/// - Parameter event: The event with information about the instance.
	public func removeInstance(_ context: String?) {
		guard let context else { return }
		log.log("Removing instance of '\(context, privacy: .public)'")
		instances[context] = nil
		ActionControllerRegistry.shared.remove(context)
	}

	/// Return an action by its context.
	public subscript (context: String) -> (any Action)? { instances[context] }

	public subscript (context: String?) -> (any Action)? {
		guard let context else { return nil }
		return instances[context]
	}


	// MARK: - WebSocket Methods
	/// Continually receive messages from the socket.
	func monitorSocket() async {

		if task.state == .suspended {
			log.log("Connecting to Stream Deck application")
			task.resume()
		}

		do {
			let message = try await self.task.receive()

			// Parse the message outside of the WebSocket loop.
			// An action may take a long time to respond, especially
			// if an AppleEvent takes longer than expected, so we
			// want to kick that off and get back to receiving messages
			// as soon as possible.
			Task(priority: .userInitiated) {
				await parseMessage(message)
			}
			
			webSocketErrorCount = 0
		} catch {
			log.error("WebSocket Error: \(error, privacy: .public)")
			webSocketErrorCount += 1
		}

		if webSocketErrorCount == 50 {
			log.warning("There have been 50 WebSocket errors in a row, the StreamDeck app is probably no longer running. Terminating.")
			exit(0)
		}

		await monitorSocket()

	}

	@available(*, deprecated, message: "Use async")
	/// Sends a WebSocket message, receiving the result in a completion handler.
	///
	/// If an error occurs while sending the message, any outstanding work also fails.
	/// - Parameters:
	///   - message: The WebSocket message to send to the other endpoint.
	///   - completionHandler: A closure that receives an NSError that indicates an error encountered while sending, or nil if no error occurred.
	func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) {
		task.send(message, completionHandler: completionHandler)
	}

	/// Sends a WebSocket message, receiving the result in a completion handler.
	/// 
	/// If an error occurs while sending the message, any outstanding work also fails.
	/// - Parameters:
	///   - message: The WebSocket message to send to the other endpoint.
	///   - eventType: The event type of the data, used for logging.
	func send(_ message: Data, eventType: String) {
		Task {
			do {
				try await task.send(URLSessionWebSocketTask.Message.data(message))

				log.log("Completed \(eventType, privacy: .public)")
			} catch {
				log.error("Failed to send \(eventType, privacy: .public) event.\n\(error.localizedDescription, privacy: .public)")
			}
		}
	}

	func parseMessage(_ message: URLSessionWebSocketTask.Message) async {
		guard let data = readMessage(message) else {
			log.warning("WebSocket sent empty message")
			return
		}

		do {
			// Decode the event from the data
			let eventKey = try decoder.decode(ReceivableEvent.self, from: data)
			try await parseEvent(event: eventKey.event, context: eventKey.context, data: data)
		} catch {
			// Pass the error onto the plugin
			log.error("Failed to decode and parse the event received")
			plugin.eventError(error, data: data)
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
			log.warning("WebSocket sent unknown message")
			return nil
		}
	}


	// MARK: - Helper Functions

	/// Complete the registration handshake with the server.
	/// - Parameter properties: The properties provided by the Stream Deck application.
	/// - Throws: Errors while encoding the data to JSON.
	func registerPlugin(_ plugin: any Plugin.Type) throws {
		let registrationEvent: [String: Any] = [
			"event": event,
			"uuid": uuid
		]

		guard JSONSerialization.isValidJSONObject(registrationEvent) else {
			throw StreamDeckError.invalidJSON(event, registrationEvent)
		}

		let data = try JSONSerialization.data(withJSONObject: registrationEvent, options: [])

		log.log("Sending registration event")
		send(data, eventType: event)

		// Create the plugin instance
		self.plugin = plugin.init()
//		send(URLSessionWebSocketTask.Message.data(data)) { error in
//			if let error = error {
//				log.error("Failed to send \(self.event) event.\n\(error.localizedDescription)")
//			}
//		}

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
			log.warning("Data for \(eventType.rawValue, privacy: .public) is not valid JSON.")
			return
		}

		do {
			let data = try JSONSerialization.data(withJSONObject: event, options: [])

			send(data, eventType: eventType.rawValue)
		} catch {
			log.error("\(error.localizedDescription, privacy: .public).")
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
			send(data, eventType: eventType.rawValue)
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
//	public func sendEvent<P: Encodable>(_ eventType: SendableEventKey, action: String? = nil, context: String?, payload: P?) throws {
//
//		// Construct the event to serialize and send
//		let event = SendableEvent(event: eventType,
//								  action: action,
//								  context: context,
//								  payload: payload)
//
//		// Encode the event
//		let data = try encoder.encode(event)
//
//		send(data, eventType: eventType.rawValue)
//
//	}

	/// Parse an event received from the Stream Deck application.
	/// - Parameters:
	///   - event: The event key.
	///   - data: The JSON data.
	func parseEvent(event: ReceivableEvent.EventKey, context: String?, data: Data) async throws {

		if shouldLoadSettings {
			log.log("Received first event, requesting global settings")
			// Get the initial global settings
			await PluginCommunication.shared.sendEvent(.getGlobalSettings,
											  context: PluginCommunication.shared.uuid,
											  payload: nil)
			shouldLoadSettings = false
		}

		switch event {

		case .didReceiveSettings:

			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			try self[context]?.decodeSettings(data, using: decoder)

		case .didReceiveGlobalSettings:
			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")
			GlobalSettings.shared.updateSettings(fromEvent: data)

			plugin.didReceiveGlobalSettings()

		case .didReceiveDeepLink:
			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")

			let event = try decoder.decode(DeepLinkEvent.self, from: data)

			plugin.didReceiveDeepLink(event.payload.url)

		case .keyDown:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			try self[context]?.decodeKeyDown(data, using: decoder)

		case .keyUp:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			try self[context]?.decodeKeyUp(data, using: decoder)

		case .dialRotate:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")

			try self[context]?.decodeDialRotate(data, using: decoder)

		case .dialPress:
			// Only forward this event on versions before `dialUp` & `dialDown` were introduced
			if info.application.version.hasPrefix("6.0") {
				log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
				try self[context]?.decodeDialPress(data, using: decoder)
			} else {
				log.warning("The `dialPress` event is deprecated and will be removed in Stream Deck 6.5.")
			}

		case .dialDown:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")

			try self[context]?.decodeDialDown(data, using: decoder)

		case .dialUp:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")

			try self[context]?.decodeDialUp(data, using: decoder)

		case .touchTap:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")

			try self[context]?.decodeTouchTap(data, using: decoder)

			if let json = String(data: data, encoding: .utf8) {
				log.debug("\(json)")
			}

		case .willAppear:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			let event = try decoder.decode(ActionEvent<InstanceAppearEvent>.self, from: data)

			self.registerInstance(event)

			try self[context]?.decodeWillAppear(data, using: decoder)

		case .willDisappear:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			try self[context]?.decodeWillDisappear(data, using: decoder)

			self.removeInstance(context)

		case .titleParametersDidChange:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			try self[context]?.decodeTitleParametersDidChange(data, using: decoder)

		case .deviceDidConnect:
			let action = try decoder.decode(DeviceConnectionEvent.self, from: data)

			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")
			plugin.deviceDidConnect(action.device, deviceInfo: action.deviceInfo!)

		case .deviceDidDisconnect:
			let action = try decoder.decode(DeviceConnectionEvent.self, from: data)

			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")
			plugin.deviceDidDisconnect(action.device)

		case .systemDidWakeUp:

			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")
			plugin.systemDidWakeUp()

		case .applicationDidLaunch:
			let action = try decoder.decode(ApplicationEvent.self, from: data)

			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")
			plugin.applicationDidLaunch(action.payload.application)

		case .applicationDidTerminate:
			let action = try decoder.decode(ApplicationEvent.self, from: data)

			log.info("Forwarding \(event, privacy: .public) to PluginDelegate")
			plugin.applicationDidTerminate(action.payload.application)

		case .propertyInspectorDidAppear:
			let action = try decoder.decode(PropertyInspectorEvent.self, from: data)

			log.info("Forwarding \(event, privacy: .public) to \(action.context, privacy: .public)")
			self[action.context]?.propertyInspectorDidAppear(device: action.device)
			plugin.propertyInspectorDidAppear(action: action.action, context: action.context, device: action.device)

		case .propertyInspectorDidDisappear:
			let action = try decoder.decode(PropertyInspectorEvent.self, from: data)

			log.info("Forwarding \(event, privacy: .public) to \(action.context, privacy: .public)")

			self[action.context]?.propertyInspectorDidDisappear(device: action.device)
			plugin.propertyInspectorDidDisappear(action: action.action, context: action.context, device: action.device)
			
		case .sendToPlugin:
			log.info("Forwarding \(event, privacy: .public) to \(context ?? "no context", privacy: .public)")
			try self[context]?.decodeSentToPlugin(data, using: decoder)
		}
	}
}
