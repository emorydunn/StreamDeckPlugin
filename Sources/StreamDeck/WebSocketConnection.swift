//
//  WebSocketConnection.swift
//  
//
//  Created by Emory Dunn on 11/17/21.
//

import Foundation

public class WebSocketConnection<Payload: Decodable> {
    
    public let task: URLSessionWebSocketTask
    
    let decoder = JSONDecoder()
    
    public var callback: ((Payload, Data) -> Void)? {
        didSet {
            // Resume the task
            task.resume()
            
            listen()
        }
    }
    
    public init(with url: URL, session: URLSession = URLSession.shared) {
        self.task = session.webSocketTask(with: url)
    }
    
    /// Sends a WebSocket message, receiving the result in a completion handler.
    ///
    /// If an error occurs while sending the message, any outstanding work also fails.
    /// - Parameters:
    ///   - message: The WebSocket message to send to the other endpoint.
    ///   - completionHandler: A closure that receives an NSError that indicates an error encountered while sending, or nil if no error occurred.
    public func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) {
        task.send(message, completionHandler: completionHandler)
    }
    
    
    public func listen() {
        self.task.receive { [weak self] result in
            switch result {
            case let .success(message):
                self?.decode(message: message)
            case let .failure(error):
                NSLog("WebSocket received failure")
                NSLog(error.localizedDescription)
                NSLog("\(error)")
            }
            
            self?.listen()
            
        }
    }
    
    func decode(message: URLSessionWebSocketTask.Message) {
        
        let messageData: Data
        
        // Extract the message data
        switch message {
        case let .data(data):
            messageData = data
        case let .string(string):
            if let data = string.data(using: .utf8) {
                messageData = data
            } else {
                return
            }
        @unknown default:
            return
        }
        
        // Attempt to decode the payload
        do {
            let payload = try decoder.decode(Payload.self, from: messageData)
            
            // Call the handler
            callback?(payload, messageData)
        } catch {
            NSLog("Failed to decode WS message as JSON")
            NSLog(error.localizedDescription)
            NSLog("\(error)")
        }
        
        
    }
}
