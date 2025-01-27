//
//  Counter Layout.swift
//  CounterPlugin
//
//  Created by Emory Dunn on 1/27/25.
//
import StreamDeck

extension LayoutName {
	static let counter: LayoutName = "counter"
}

extension Layout {
	static let counter = Layout(id: .counter) {
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
}

struct CounterSettings: LayoutSettings {
	var countText: TextLayoutSettings
	var countBar: BarLayoutSettings
}
