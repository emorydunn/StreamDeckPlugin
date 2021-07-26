# StreamDeck

A library for creating Stream Deck plugins in Swift. 

## Usage

Your plugin class should inherit from `StreamDeckPlugin`, which handles the WebSocket connection and events automatically. You can override event methods in order to act upon received actions.  

```swift
import StreamDeck

class CounterPlugin: StreamDeckPlugin {

    var counter: Int = 0
    
    override func keyDown(action: String, context: String, device: String, payload: ActionEvent.Payload) {
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
