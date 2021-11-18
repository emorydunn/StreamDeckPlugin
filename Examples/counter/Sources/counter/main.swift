import Foundation
import StreamDeck

let manifest = PluginManifest(
    name: "Counter",
    description: "Count things. On your Stream Deck!",
    category: "Counting Actions",
    author: "Emory Dunn",
    icon: "counter",
    version: "0.1",
    os: [
        .mac(minimumVersion: "10.15")
    ],
    software: .minimumVersion("4.1"),
    codePath: "counter-plugin",
    actions: [
        PluginAction(
            name: "Increment",
            uuid: "counter.increment",
            icon: "Icons/plus",
            tooltip: "Increment the count."),
        PluginAction(
            name: "Decrement",
            uuid: "counter.decrement",
            icon: "Icons/minus",
            tooltip: "Decrement the count.")
    ])

PluginManager.main(plugin: CounterPlugin.self, manifest: manifest)
