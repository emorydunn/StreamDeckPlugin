# How to Build and Validate

## Build the Binary from Source Code

From the counter example directory run:

`swift build`

## Export the Plugin 

Export manifest and copy the binary to the plugin folder and define the uuid of the plug-in:

`swift run counter-plugin export com.example.counter --output . --generate-manifest --copy-executable --executable-name "counter-plugin"`

## Copy Resources (Icons)

`cp -r Icons com.example.counter.sdPlugin`

## Validate plug-in

Run the streamdeck CLI validate tool requires tool to be installed:

`streamdeck validate com.example.counter.sdPlugin`