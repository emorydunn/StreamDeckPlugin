# StreamDeck

![Swift](https://github.com/emorydunn/StreamDeckPlugin/workflows/Swift/badge.svg) ![Documentation badge](https://emorydunn.github.io/StreamDeckPlugin/badge.svg)

A library for creating Stream Deck plugins in Swift.

## Usage

Your plugin should conform to `PluginDelegate`, which handles event routing to you actions and lets you interact with the Stream Deck application.

```swift
@main
class CounterPlugin: PluginDelegate {

    static var name: String = "Counter"

    static var description: String = "Count things. On your Stream Deck!"

    static var author: String = "Emory Dunn"

    static var icon: String = "Icons/pluginIcon"

    static var version: String = "0.4"

    static var actions: [any Action.Type] = [
        IncrementAction.self,
        DecrementAction.self
    ]

    required init() { }

}
```

By using the `@main` attribute your plugin will be automatically initialized.

## Declaring a Plugin

A plugin both defines the code used to interact with the Stream Deck and the manifest for the plugin. When declaring your plugin there are a number of static properties which are defined to tell the Stream Deck application about what your plugin is and what it can do. Not all properties are required, for instance your plugin doesn't need to add a custom category. Optional properties have default overloads to help reduce boilerplate.

Many of the properties are shown to users, such as the name and description. Others are used internally by the Stream Deck application. The most important property is `actions` which is where you define the actions your plugin provides.

```swift
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

Starting in Swift 5.9 two new macros will be available to make declaring environmental values and global settings easier. The macro handles generating both the struct and variable for the key path.

```swift
extension EnvironmentValues {
    #environmentKey("count", defaultValue: 0, ofType: Int.self)
}

extension GlobalSettings {
    #globalSetting("count", defaultValue: 0, ofType: Int.self)
}
```

## Creating Actions

### Events

### Action Settings
