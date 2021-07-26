//
//  WebSocketTaskPublisher.swift
//
//
//  Created by Emory Dunn on 5/23/21.
//

import Foundation
import Combine

extension URLSession {
    
    /// Returns a publisher that wraps a URL session WebSocket task for a given URL.
    ///
    /// The provided URL must have a `ws` or `wss` scheme.
    /// - Parameter url: The WebSocket URL with which to connect.
    func webSocketTaskPublisher(for url: URL) -> WebSocketTaskPublisher {
        WebSocketTaskPublisher(with: url, session: self)
    }
}

/// A publisher that delivers the messages from a WebSocket.
public struct WebSocketTaskPublisher: Publisher {
    
    public typealias Output = URLSessionWebSocketTask.Message
    
    public typealias Failure = Error
    
    let task: URLSessionWebSocketTask
    
    /// Creates a WebSocket task publisher from the provided URL and URL session.
    ///
    /// The provided URL must have a `ws` or `wss` scheme.
    /// - Parameters:
    ///   - url: The WebSocket URL with which to connect.
    ///   - session: The URLSession to create the WebSocket task.
    public init(with url: URL, session: URLSession = URLSession.shared) {
        self.task = session.webSocketTask(with: url)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, URLSessionWebSocketTask.Message == S.Input {
        
        let subscrption = Subscription(task: task, target: subscriber)
        subscriber
            .receive(subscription: subscrption)

    }
    
//    public func send(_ message: URLSessionWebSocketTask.Message) {
//        task.send(message, completionHandler: <#T##(Error?) -> Void#>)
//    }
    
}

extension WebSocketTaskPublisher {
    class Subscription<Target: Subscriber>: Combine.Subscription where Target.Input == Output, Target.Failure == Error {
        
        let task: URLSessionWebSocketTask
        var target: Target?

        init(task: URLSessionWebSocketTask, target: Target) {
            self.task = task
            self.target = target
        }
        
        func request(_ demand: Subscribers.Demand) {
            var demand = demand
            
            // Resume the task
            task.resume()

            // Request new messages from the socket
            while let target = target, demand > 0 {

                // Only allow one request at once
                let flag = DispatchSemaphore(value: 0)

                self.task.receive { result in
                    switch result {
                    case let .success(message):
                        demand -= 1
                        demand += target.receive(message)
                    case let .failure(error):
                        target.receive(completion: .failure(error))
                    }
                    
                    flag.signal()

                }

                flag.wait()

            }
        }
        
        func cancel() {
            task.cancel()
            target = nil
        }
    }
}
