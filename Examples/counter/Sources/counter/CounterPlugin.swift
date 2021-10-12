//
//  CounterPlugin.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation
import StreamDeck

class CounterPlugin: StreamDeckPlugin {

    var counter: Int = 0
    
    override func keyDown(action: String, context: String, device: String, payload: KeyEvent) {
        print("keyDown", action)
        switch action {
        case "counter.increment":
            counter += 1
        case "counter.decrement":
            counter -= 1
        default:
            break
        }

        instanceManager.instances.forEach {
            setTitle(in: $0.context, to: "\(counter)")
        }
        
    }
    
}
