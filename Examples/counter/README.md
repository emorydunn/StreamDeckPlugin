# Example Plugin

The example plugin, a basic counter, show how to structure your plugin & actions. It includes several actions demonstrating a number of library features including global settings, property inspectors, custom Stream Deck + layouts, bundled profiles, and deep linking. It's a good starting place to familiarize yourself with both Stream Deck plugins and the Swift library. 

## Build the Binary from Source Code

From the counter example directory run:

`swift build`

## Export the Plugin 

Copy the binary, export the manifest, and copy resources into `~/Library/Application Support/com.elgato.StreamDeck/Plugins`:

`swift run counter-plugin export --copy-executable --generate-manifest --copy-file Resources/Icons/ --copy-file Resources/Profiles/ --copy-file Resources/Inspectors/`

## Validate plug-in

Run the streamdeck CLI validate tool requires tool to be installed:

`streamdeck validate com.example.counter.sdPlugin`