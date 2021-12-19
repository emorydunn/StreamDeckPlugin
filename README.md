# StreamDeck

A library for creating Stream Deck plugins in Swift.

## Usage

Your plugin should conform to `PluginDelegate`, which handles event routing to you actions and lets you interact with the Stream Deck application.

```swift
import StreamDeck

@main
class CounterPlugin: PluginDelegate {

    // Skipping manifest for brevity

    var counter: Int = 0

    func keyDown(action: String, context: String, device: String, payload: KeyEvent) {
        counter += 1
        setTitle(in: context, to: "\(counter)")
    }

}
```

My using the `@main` attribute your plugin will be automatically initialized.

## Responding to Events

### With Methods

When events are received by your plugin they are parsed and the corresponding method is called. See the [Events Received][er] page for more details. Each event has a default implementation that does nothing, so your plugin only needs to include any events you care about.

Each method is called with the top-level properties along with an event specific payload. For instance, to the `keyDown` event provides a payload that includes the actions settings, coordinates, etc.

### With Actions

A more powerful way to respond to events is with `Actions`. By creating an object that conforms to `Action` you can move the logic out of the plugin. For a plugin with many actions this is the preferred way to handle events. The `StreamDeckPlugin` creates a new instance of your action when `willAppear` is called and releases it when `willDisappear` is called.

## The Environment

In order to pass variables between instances you can use `@Environment` property wrapper. Firstly you need to declare your `EnvironmentKey`:

```swift
struct PluginCount: EnvironmentKey {
    static let defaultValue: Int = 0
}
```

Then when you need to access that value in an action you decorate the variable:

```swift
class IncrementAction: Action {
    @Environment(PluginCount.self) var count: Int
}
```

[er]: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/

## Sending Events

In addition to receiving events from the application your plugin can [send events][se]. Most of the commands require a context object to specify the instance on the Stream Deck.

[se]: https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/

## Exporting Your Plugin

Your plugin executable ships with an automatic way to generate the plugin's `manifest.json` file in a type-safe manor. Each `Action` also has its own manifest properties as well.

```swift
@main
class CounterPlugin: PluginDelegate {

    // MARK: Manifest
    static var name: String = "Counter"

    static var description: String = "Count things. On your Stream Deck!"

    static var category: String? = "Counting Actions"

    static var categoryIcon: String? = nil

    static var author: String = "Emory Dunn"

    static var icon: String = "counter"

    static var url: URL? = nil

    static var version: String = "0.2"

    static var os: [PluginOS] = [.mac(minimumVersion: "10.15")]

    static var applicationsToMonitor: ApplicationsToMonitor? = nil

    static var software: PluginSoftware = .minimumVersion("4.1")

    static var sdkVersion: Int = 2

    static var codePath: String = CounterPlugin.executableName

    static var codePathMac: String? = nil

    static var codePathWin: String? = nil

    static var actions: [Action.Type] = [
        IncrementAction.self,
        DecrementAction.self
    ]

}

class IncrementAction: Action {

    static var name: String = "Increment"

    static var uuid: String = "counter.increment"

    static var icon: String = "Icons/plus"

    static var states: [PluginActionState] = []

    static var propertyInspectorPath: String?

    static var supportedInMultiActions: Bool?

    static var tooltip: String?

    static var visibleInActionsList: Bool?
}

```

Using the `export` command you can generate the manifest file and copy the actual executable to the Plugins directory:

```
counter-plugin export --copy-executable --generate-manifest
```

You can also specify the output directory, manifest name, executable name, or preview the manifest. Check `export -h` for all of the options.

## Adding `StreamDeck` as a Dependency

To use the `StreamDeck` library in a SwiftPM project,
add the following line to the dependencies in your `Package.swift` file:

```swift
.package(name: "StreamDeck", url: "https://github.com/emorydunn/StreamDeckPlugin.git", .branch("main"))
```

Finally, include `"StreamDeck"` as a dependency for your executable target:

```swift
let package = Package(
    // name, products, etc.
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(name: "StreamDeck", url: "https://github.com/emorydunn/StreamDeckPlugin.git", .branch("main")),
        // other dependencies
    ],
    targets: [
        .executableTarget(name: "<command-line-tool>", dependencies: [
            "StreamDeck"
        ]),
        // other targets
    ]
)
```
