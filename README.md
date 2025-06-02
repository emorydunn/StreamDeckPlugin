# StreamDeck

![Swift](https://github.com/emorydunn/StreamDeckPlugin/workflows/Swift/badge.svg) ![Documentation badge](https://emorydunn.github.io/StreamDeckPlugin/badge.svg)

A library for creating Stream Deck plugins in Swift.

## Usage

Your plugin should conform to `Plugin`, which handles event routing to your actions and lets you interact with the Stream Deck application.

```swift
@main
class CounterPlugin: Plugin {

    static var name: String = "Counter"

    static var description: String = "Count things. On your Stream Deck!"

    static var author: String = "Emory Dunn"

    static var icon: String = "Icons/pluginIcon"

    static var version: String = "0.4"

    @ActionBuilder
    static var actions: [any Action.Type] {
      IncrementAction.self
      DecrementAction.self
      RotaryAction.self
    }

    static var layouts: [Layout] {
      Layout(id: "counter") {
        // The title of the layout
        Text(title: "Current Count")
          .textAlignment(.center)
          .frame(width: 180, height: 24)
          .position(x: (200 - 180) / 2, y: 10)

        // A large counter label
        Text(key: "count-text", value: "0")
          .textAlignment(.center)
          .font(size: 16, weight: 600)
          .frame(width: 180, height: 24)
          .position(x: (200 - 180) / 2, y: 30)

        // A bar that shows the current count
        Bar(key: "count-bar", value: 0, range: -50..<50)
          .frame(width: 180, height: 20)
          .position(x: (200 - 180) / 2, y: 60)
          .barBackground(.black)
          .barStyle(.doubleTrapezoid)
          .barBorder("#943E93")
      }
    }

    required init() { }

}
```

By using the `@main` attribute your plugin will be automatically initialized.

## Declaring a Plugin

A plugin both defines the code used to interact with the Stream Deck and the manifest for the plugin. When declaring your plugin there are a number of static properties which are defined to tell the Stream Deck application about what your plugin is and what it can do. Not all properties are required, for instance your plugin doesn't need to add a custom category. Optional properties have default overloads to help reduce boilerplate.

Many of the properties are shown to users, such as the name and description. Others are used internally by the Stream Deck application. The most important property is `actions` which is where you define the actions your plugin provides.

```swift

// Define actions with a builder
@ActionBuilder
static var actions: [any Action.Type] {
  IncrementAction.self
  DecrementAction.self
  RotaryAction.self
}

// Or define actions in an array
static var actions: [any Action.Type] = [
    IncrementAction.self,
    DecrementAction.self
]
```

Actions are provided as a type because the plugin will initialize a new instance per visible key.

### The Environment and Global Settings

There are two ways to share a global state amongst actions:

1. The Environment
2. Global Settings

In use they're very similar, only differing by a couple of protocols. The important difference is that environmental values aren't persisted whereas global settings are stored and will be consistent across launches of the Stream Deck app.

There are two ways to declare environmental values and global settings.

Start with a struct that conforms to `EnvironmentKey` or `GlobalSettingKey`. This defines the default value and how the value will be accessed:

```swift
struct Count: EnvironmentKey {
    static let defaultValue: Int = 0
}
```

Next add an extension to either `EnvironmentValues` or `GlobalSettings`:

```swift
extension EnvironmentValues {
    var count: Int {
        get { self[Count.self] }
        set { self[Count.self] = newValue }
    }
}
```

To use the value in your actions use the corresponding property wrapper:

```swift
@Environment(\.count) var count // For an environment key
@GlobalSetting(\.count) var count // For a global settings key
```

The value can be read and updated from inside an action callback.

#### Macros

Additionally, instead of manually declaring the keys, you can use the `@Entry` macro. The macro handles generating both the struct and variable for the key path. By default the name is auto-generated based on the property name, but a custom key can be provided.

```swift
extension EnvironmentValues {
    @Entry var count = 42
}

extension GlobalSettings {
    @Entry("CountDracula") var theCount = 42
}
```

## Creating Actions

Each action in your plugin is defined as a separate struct conforming to `Action`. There are several helper protocols available for specific action types.

| Protocol             | Description                                  |
| -------------------- | -------------------------------------------- |
| `KeyAction`          | A key action which has multiple states       |
| `StatelessKeyAction` | A key action which has a single state        |
| `EncoderAction`      | A rotary encoder action on the Stream Deck + |

Using one of the above protocols simply provides default values on top of `Action`, and you can provide your own values as needed. For instance `KeyAction` sets the `controllers` property to `[.keypad]` by default, and `EncoderAction` sets it to `[.encoder]`. To create an action that provides both key and encoder actions set `controllers` to `[.keypad, .encoder]` no matter which convenience protocol you're using.

For all action there are several common static properties which need to be defined.

```swift
struct IncrementAction: KeyAction {

    typealias Settings = NoSettings

    static var name: String = "Increment"

    static var uuid: String = "counter.increment"

    static var icon: String = "Icons/actionIcon"

    static var states: [PluginActionState]? = [
        PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
    ]

    var context: String

    var coordinates: StreamDeck.Coordinates?

    @GlobalSetting(\.count) var count

    required init(context: String, coordinates: StreamDeck.Coordinates?) {
        self.context = context
        self.coordinates = coordinates
    }
}
```

### Action Settings

If your action uses a [property inspector][pi] for configuration you can use a `Codable` struct as the `Settings`. The current settings will be sent in the payload in events.

```swift
struct ChooseAction: KeyAction {
    enum Settings: String, Codable {
        case optionOne
        case optionTwo
        case optionThree
    }
}
```

#### Working with SPDI Components

If you define your Property Inspectors using [SPDI Components][SPDI] your plugin can both send dynamic properties natively.

For example if you have an `spdi-select`:

```HTML
<sdpi-item label="Recipe">
  <sdpi-select
    id="recipeSelect"
    setting="processRecipe"
    placeholder="Choose a process recipe"
    datasource="getRecipes"
    loading="Loading process recipes..."
  >
  </sdpi-select>
</sdpi-item>

```

Your plugin can easily provide values for it using `DataSourcePayload`. The `event` sent by the plugin matches the `datasource` in the component and the initializer provides a convenient map function.

```swift
let recipeNames = listProcessRecipes() // Returns an array of strings

let response = DataSourcePayload(event: "getRecipes", items: recipeNames) { recipeName in
  DatasourceItem(label: recipeName)
}

sendToPropertyInspector(response)
```

### Events

Your action can both [receive events][er] from the app and [send events][es] to the app. Most of the events will be from user interaction, key presses and dial rotation, but also from system events such as the action appearing on a Stream Deck or the property inspector appearing.

To receive events simply implement the corresponding method in your action, for instance to be notified when a key is released use `keyUp`. If your action displays settings to the user, use `willAppear` to update the title to reflect the current value.

```swift
struct IncrementAction: KeyAction {

    func willAppear(device: String, payload: AppearEvent<NoSettings>) {
        setTitle(to: "\(count)", target: nil, state: nil)
    }

    func didReceiveGlobalSettings() {
        log.log("Global settings changed, updating title with \(self.count)")
        setTitle(to: "\(count)", target: nil, state: nil)
    }

    func keyUp(device: String, payload: KeyEvent<Settings>) {
        count += 1
    }

    func longKeyPress(device: String, payload: KeyEvent<NoSettings>) {
      count = 0
      showOk()
      log.log("Resetting count to \(self.count)")
    }
}
```

In the above example, `setTitle` is an event that an action can send. In this case it sets the title of the action. It's called in two places: when the action appears to set the initial title and when the global settings are changed so it can keep the visible counter in sync.

## Stream Deck Plus Layouts

Designing [custom layouts][plus_layout] for the Stream Deck Plus is accomplished with using a result builder. Each `Layout` is built from components, such as `Text`, `Image`, etc. The layout is defined in the plugin manifest. For instance, to build a custom bar layout from the example `counter` plugin:

```swift

extension LayoutName {
  static let counter: LayoutName = "counter"
}

Layout(id: .counter) {
  // The title of the layout
  Text(title: "Current Count")
    .textAlignment(.center)
    .frame(width: 180, height: 24)
    .position(x: (200 - 180) / 2, y: 10)

  // A large counter label
  Text(key: "countText", value: "0")
    .textAlignment(.center)
    .font(size: 16, weight: 600)
    .frame(width: 180, height: 24)
    .position(x: (200 - 180) / 2, y: 30)

  // A bar that shows the current count
  Bar(key: "countBar", value: 0, range: -50...50)
    .frame(width: 180, height: 20)
    .position(x: (200 - 180) / 2, y: 60)
    .barBackground(.black)
    .barStyle(.doubleTrapezoid)
    .barBorder("#943E93")
}

struct CounterSettings: LayoutSettings {
  var countText: TextLayoutSettings
  var countBar: BarLayoutSettings

  init(count: Int, bgColor: Color) {
    self.countText = TextLayoutSettings(value: count.formatted())
    self.countBar = BarLayoutSettings(value: Double(count), bar_fill_c: bgColor)
  }
}
```

The layout is saved into the Layouts folder in the same directory as the manifest. In order to use the layout on a rotary action set the layout property of the encoder to the folder and id of the layout, e.g. `Layouts/counter.json`.

The layout can be updated with a struct which conforms to `LayoutSettings`, like `CounterSettings` above.

```swift
let feedback = CounterSettings(count: count, bgColor: .red)

setFeedback(feedback)
```

Any editable property can be updated this way. Please refer to the [documentation](https://docs.elgato.com/sdk/plugins/layouts-sd+#items) for more details.

## Exporting Your Plugin

Your plugin executable ships with an automatic way to generate the plugin's `manifest.json` file in a type-safe manor. Use the provided `export` command on your plugin binary to export the manifest and copy the binary itself. You will still need to use Elgato's `DistributionTool` for final packaging.

```bash
OVERVIEW: Conveniently export the plugin.

Automatically generate the manifest and copy the executable to the Plugins folder.

USAGE: plugin-command export <uri> [--output <output>] [--generate-manifest] [--preview-manifest] [--manifest-name <manifest-name>] [--copy-executable] [--executable-name <executable-name>]

ARGUMENTS:
  <uri>                   The URI for your plugin

OPTIONS:
  -o, --output <output>   The folder in which to create the plugin's directory. (default: ~/Library/Application Support/com.elgato.StreamDeck/Plugins)
  --generate-manifest/--preview-manifest
                          Encode the manifest for the plugin and either save or preview it.
  -m, --manifest-name <manifest-name>
                          The name of the manifest file. (default: manifest.json)
  -c, --copy-executable   Copy the executable file.
  -e, --executable-name <executable-name>
                          The name of the executable file.
  --version               Show the version.
  -h, --help              Show help information.
```

If you're building a universal binary there appears to be an issue with the macro which prevents compiling for multiple architectures at once. A workaround is to compile each separately and then combine with with `lipo`.

```shell
# Build each architecture separately and then combine
echo "Building ARM binary"
swift build -c release --arch arm64

echo "Building Intel binary"
swift build -c release --arch x86_64

echo "Creating universal binary"
lipo -create \
  .build/arm64-apple-macosx/counter-plugin \
  .build/x86_64-apple-macosx/counter-plugin \
  -output counter-plugin
```

## Adding `StreamDeck` as a Dependency

To use the `StreamDeck` library in a SwiftPM project,
add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/emorydunn/StreamDeckPlugin.git", from: "0.5.0"),
```

Finally, include `"StreamDeck"` as a dependency for your executable target:

```swift
let package = Package(
    // name, products, etc.
    platforms: [.macOS(.v11)],
    dependencies: [
        .package(url: "https://github.com/emorydunn/StreamDeckPlugin.git", from: "0.5.0"),
        // other dependencies
    ],
    targets: [
        .executableTarget(name: "<command-line-tool>", dependencies: [
            .product(name: "StreamDeck", package: "StreamDeckPlugin")
        ]),
        // other targets
    ]
)
```

[pi]: https://docs.elgato.com/sdk/plugins/property-inspector
[er]: https://docs.elgato.com/sdk/plugins/events-received
[es]: https://docs.elgato.com/sdk/plugins/events-sent
[plus_layout]: https://docs.elgato.com/sdk/plugins/layouts-sd+
[spdi]: https://sdpi-components.dev
