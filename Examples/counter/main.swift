import Foundation
import StreamDeck

class CounterPlugin: StreamDeckPlugin {

    var counter: Int = 0
    
    override func keyDown(action: String, context: String, device: String, payload: ActionEvent.Payload) {
        counter += 1
        setTitle(in: context, to: "\(counter)")
    }
    
}

PluginManager.main(plugin: CounterPlugin.self)
