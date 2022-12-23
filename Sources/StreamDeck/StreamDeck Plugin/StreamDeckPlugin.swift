//
//  StreamdeckPlugin.swift
//  
//
//  Created by Emory Dunn on 12/19/21.
//

import Foundation

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
            NSLog("This instance has already been registered.")
            return
        }
        
        // Look up the action
        guard let actionType = action(forID: actionID) else {
            NSLog("No action available with UUID '\(actionID)'.")
            return
        }
        
        // Initialize a new instance
        instances[context] = actionType.init(context: context, coordinates: coordinates)
        
        NSLog("Initialized a new instance of '\(actionType.uuid)'")
    }
    
    /// Remove an instance of an action from a `willDisappear` event.
    /// - Parameter event: The event with information about the instance.
    public func removeInstance(_ context: String?) {
		guard let context else { return }
        NSLog("Removing instance of '\(context)'")
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
			NSLog("Connecting to Stream Deck application")
			task.resume()
		}

        self.task.receive { [weak self] result in

            // Handle a new message
            switch result {
            case let .success(message):
                self?.parseMessage(message)
            case let .failure(error):
                NSLog("WebSocket Error: \(error)")
                break
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
			NSLog("Warning: WebSocket sent empty message")
			return
		}
        
        // Decode the event from the data
        do {
            let eventKey = try decoder.decode(ReceivableEvent.self, from: data)
			try parseEvent(event: eventKey.event, context: eventKey.context, data: data)
        } catch {
			NSLog("Decoding Error: \(error.localizedDescription)")
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
			NSLog("Warning: WebSocket sent unknown message")
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
        
        NSLog("Sending registration event")
        send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                NSLog("ERROR: Failed to send \(self.event) event.")
                NSLog(error.localizedDescription)
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
            NSLog("Data for \(eventType.rawValue) is not valid JSON.")
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: event, options: [])
            
            task.send(URLSessionWebSocketTask.Message.data(data)) { error in
                if let error = error {
                    NSLog("ERROR: Failed to send \(eventType.rawValue) event.")
                    NSLog(error.localizedDescription)
                } else {
                    NSLog("Completed \(eventType.rawValue)")
                }
            }
        } catch {
            NSLog("ERROR: \(error.localizedDescription).")
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
					NSLog("ERROR: Failed to send \(eventType.rawValue) event.")
					NSLog(error.localizedDescription)
				} else {
					NSLog("Completed \(eventType.rawValue)")
				}
			}
		} catch {
			NSLog("ERROR: \(error.localizedDescription).")
		}

	}
    
    /// Parse an event received from the Stream Deck application.
    /// - Parameters:
    ///   - event: The event key.
    ///   - data: The JSON data.
	func parseEvent(event: ReceivableEvent.EventKey, context: String?, data: Data) throws {

        switch event {
            
        case .didReceiveSettings:

			NSLog("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeSettings(data, using: decoder)

        case .didReceiveGlobalSettings:
			NSLog("Forwarding \(event) to PluginDelegate")
			try plugin.decodeGlobalSettings(data, using: decoder)
        
        case .keyDown:
			NSLog("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeKeyDown(data, using: decoder)

        case .keyUp:
			NSLog("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeKeyUp(data, using: decoder)

		case .dialRotate:
			NSLog("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeDialRotate(data, using: decoder)

		case .dialPress:
			NSLog("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeDialPress(data, using: decoder)

		case .touchTap:
			NSLog("Forwarding \(event) to \(context ?? "no context")")

			try self[context]?.decodeTouchTap(data, using: decoder)

			if let json = String(data: data, encoding: .utf8) {
				NSLog(json)
			}

        case .willAppear:
			NSLog("Forwarding \(event) to \(context ?? "no context")")
			let action = try decoder.decode(ActionEvent<InstanceAppearEvent>.self, from: data)

			self.registerInstance(actionID: action.action, context: action.context, coordinates: action.payload.coordinates)

			try self[context]?.decodeWillAppear(data, using: decoder)
//
//            self[action.context]?.willAppear(device: action.device, payload: action.payload)
//            plugin.willAppear(action: action.action, context: action.context, device: action.device, payload: action.payload)
        
        case .willDisappear:
			NSLog("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeWillDisappear(data, using: decoder)
//            let action = try decoder.decode(ActionEvent<AppearEvent>.self, from: data)
//
//            self[action.context]?.willDisappear(device: action.device, payload: action.payload)
//            plugin.willDisappear(action: action.action, context: action.context, device: action.device, payload: action.payload)
            
            self.removeInstance(context)
        
        case .titleParametersDidChange:
			NSLog("Forwarding \(event) to \(context ?? "no context")")
			try self[context]?.decodeTitleParametersDidChange(data, using: decoder)
//            let action = try decoder.decode(ActionEvent<TitleInfo>.self, from: data)
//
//			NSLog("Forwarding \(event) to \(action.context)")
//            self[action.context]?.titleParametersDidChange(device: action.device, info: action.payload)
//            plugin.titleParametersDidChange(action: action.action, context: action.context, device: action.device, info: action.payload)
            
        case .deviceDidConnect:
            let action = try decoder.decode(DeviceConnectionEvent.self, from: data)

			NSLog("Forwarding \(event) to PluginDelegate")
            plugin.deviceDidConnect(action.device, deviceInfo: action.deviceInfo!)
            
        case .deviceDidDisconnect:
            let action = try decoder.decode(DeviceConnectionEvent.self, from: data)

			NSLog("Forwarding \(event) to PluginDelegate")
            plugin.deviceDidDisconnect(action.device)
            
        case .systemDidWakeUp:

			NSLog("Forwarding \(event) to PluginDelegate")
            plugin.systemDidWakeUp()
            
        case .applicationDidLaunch:
            let action = try decoder.decode(ApplicationEvent.self, from: data)

			NSLog("Forwarding \(event) to PluginDelegate")
            plugin.applicationDidLaunch(action.payload.application)
        
        case .applicationDidTerminate:
            let action = try decoder.decode(ApplicationEvent.self, from: data)

			NSLog("Forwarding \(event) to PluginDelegate")
            plugin.applicationDidTerminate(action.payload.application)
            
        case .propertyInspectorDidAppear:
            let action = try decoder.decode(PropertyInspectorEvent.self, from: data)

			NSLog("Forwarding \(event) to \(action.context)")
            self[action.context]?.propertyInspectorDidAppear(device: action.device)
            plugin.propertyInspectorDidAppear(action: action.action, context: action.context, device: action.device)
        
        case .propertyInspectorDidDisappear:
            let action = try decoder.decode(PropertyInspectorEvent.self, from: data)

			NSLog("Forwarding \(event) to \(action.context)")
            self[action.context]?.propertyInspectorDidDisappear(device: action.device)
            plugin.propertyInspectorDidDisappear(action: action.action, context: action.context, device: action.device)
        
        case .sendToPlugin:
            let action = try decoder.decode(SendToPluginEvent.self, from: data)

			NSLog("Forwarding \(event) to PluginDelegate")
            plugin.sentToPlugin(context: action.context, action: action.action, payload: action.payload)
        }
    }
}
