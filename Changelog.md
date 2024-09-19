# Changelog

## 0.5.0 / 2024-09-19

## Added

- Create custom SD+ layouts using result builders
- Initial deep link support
- `Action.openURL(_:)` to allow actions to launch URLs
- Support for disabling the user configurable title in the PI
- Global Long Press support for actions
- Dial events include a `clockwise` property

## Changed

- Action UUIDs are checked that they are a uniform type identifier
- WebSocket code has been migrated to async

## 0.4.0 / 2024-01-08

## Added

- The new `globalSetting` and `environmentKey` macros
- Support for `dialDown` and `dialUp` events (`dialPress` is now deprecated)
- ` DisableAutomaticStates` in the `Action` protocol
- `setTriggerDescription` event for SD+
- `sortName` to provide a custom sort key for actions
- `PluginSoftware` conforms to `ExpressibleByStringLiteral`
- `@State` for action-specific state
- New `sortName` property on `Action` to allow sorting actions

## Changed

- Use `OSLog` for nicer logs
- Example plugin uses a relative path to the plugin
- Use `PlatformMinimumVersion` for manifest
- Plugin monitors WebSocket errors and exits after too many
- Deprecated `dialPress`, event is send to `dialUp`
- Renamed `PluginOS.mac(minimumVersion:)` & `PluginOS.win(minimumVersion:)` to `PluginOS.macOS(_:)` & `PluginOS.windows(_:)`
- Renamed `PluginDelegate` to `Plugin`
- Renamed `StreamDeckPlugin` to `PluginCommunication`
- The plugin communication and registration now happens before initializing your `Plugin`, meaning it's safe to call events from the `init()`
- The plugin validates action UUIDs
- Sort manifest keys for stable JSON

## 0.3.0 / 2023-03-03

## Added

- This changelog
- Additional error logging
- Provide manifest defaults for values that aren't required, have defaults, or shouldn't actually be changed
- Support for decoding new StreamDeck hardware
- `Settings API`

## Fixed

- Target and state are correctly passed when setting an image in the bundle
- A bug where the will appear decode method would fail if the instance hadn't been previously registered

## 0.2.0 / 2022-06-19

## Added

- Automatic event routing
- An environment for sharing values across actions
- 100% documentation

## Fixed

- The plugin extension is added automatically if needed

## 0.1.0 / 2022-02-18

### Added

- The initial release!
- CLI for exporting a manifest
