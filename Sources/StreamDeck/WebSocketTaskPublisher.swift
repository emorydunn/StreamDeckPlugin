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
            guard let target = target else { return }
            
            // Resume the task
            task.resume()
            
            sendReceivedEvents(to: target, with: demand)
            
        }
        
        /// Receive events from the WebSocket and pass them along to the subscriber.
        /// - Parameters:
        ///   - target: The subscriber to attach to this Publisher, after which it can receive values.
        ///   - demand: A requested number of items, sent to a publisher from a subscriber through the subscription.
        func sendReceivedEvents(to target: Target, with demand: Subscribers.Demand) {
            var demand = demand
            
            self.task.receive { [weak self] result in
                switch result {
                case let .success(message):
                    demand -= 1
                    demand += target.receive(message)
                case let .failure(error):
                    target.receive(completion: .failure(error))
                }
                
                if demand > 0 {
                    self?.sendReceivedEvents(to: target, with: demand)
                }
            }
        }

        func cancel() {
            task.cancel()
            target = nil
        }
    }
}
