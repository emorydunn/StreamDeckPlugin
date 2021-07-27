# StreamDeck

A library for creating Stream Deck plugins in Swift. 

## Usage

Your plugin class should inherit from `StreamDeckPlugin`, which handles the WebSocket connection and events automatically. You can override event methods in order to act upon received actions.  

```swift
import StreamDeck

class CounterPlugin: StreamDeckPlugin {

    var counter: Int = 0
    
    override func keyDown(action: String, context: String, device: String, payload: ActionEvent) {
        counter += 1
        setTitle(in: context, to: "\(counter)")
    }
    
}
```

In order to run your plugin it needs to be registered during startup. The `PluginManager` manages the lifecycle of your plugin. In your `main.swift` file add your plugin:

```swift
import Foundation
import StreamDeck

PluginManager.plugin = CounterPlugin.self
PluginManager.main()

dispatchMain()
```

This is all that should be in the file in order for the Stream Deck software to succesfully launch the plugin. 

## Responding to Events

When events are received by your plugin they are parsed and the corosponding method is called. See the [Events Received][er] page for more details. 

[er]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/

## Sending Events

In addition to receiving events from the application your plugin can [send events][se]. Most of the commands require a context object to specify the instance on the Stream Deck. 

[se]: https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/

## Accessing Specific Action Insrances

Responding to events is easy because the context is provided, however updating instances outside of a recieved event requires knowing the state of the Stream Deck. 
To aid in this the `StreamDeckPlugin` has an `InstanceManager` which tracks `willAppear` and `willDissapear` events. The manager provides methods for looking up available instances in a few ways.  

The most straight forward is by looking up the context token using `.instance(for:)`. Usually you'll be looking up instances of a specific action or at specific coordinates. 

To look up all instances of an action call `.instances(with:)`  with the UUID from your `manifest.json` file. The ID you pass in will be automatically lowercased. 

You can also look up the instance of an action by coordinates by calling `.instance(at:)`. 
