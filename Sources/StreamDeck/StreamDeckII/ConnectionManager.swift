//
//  ConnectionManager.swift
//  
//
//  Created by Emory Dunn on 12/18/21.
//

import Foundation

/// The object responsible for connecting to the StreamDeck WebSocket.
class ConnectionManager {
    
    let plugin: PluginDelegate
    let task: URLSessionWebSocketTask
    
    let decoder = JSONDecoder()
    
    init(plugin: PluginDelegate, port: Int32) {
        self.plugin = plugin

        let url = URL(string: "ws://localhost:\(port)")!
        self.task = URLSession.shared.webSocketTask(with: url)
    }
    
    // MARK: - WebSocket Methods
    /// Continually receive messages from the socket. 
    func monitorSocket() {
        self.task.receive { [weak self] result in
            
            // Handle a new message
            switch result {
            case let .success(message):
                self?.parseMessage(message)
            case let .failure(error):
                print(error)
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
        guard let data = readMessage(message) else { return }
        
        // Decode the event from the data
        do {
            let eventKey = try decoder.decode(ReceivableEvent.self, from: data).event
            try plugin.parseEvent(event: eventKey, data: data)
        } catch {
            print(error)
        }
        
    }

    // MARK: - Helper Functions
    
    /// Interpret the message as either Data or a UTF-8 encoded data.
    func readMessage(_ message: URLSessionWebSocketTask.Message) -> Data? {
        switch message {
        case let .data(data):
            return data
        case let .string(string):
            return string.data(using: .utf8)
        @unknown default:
            return nil
        }
    }
    
}

