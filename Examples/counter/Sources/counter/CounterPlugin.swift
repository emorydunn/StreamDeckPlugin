//
//  CounterPlugin.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation
import StreamDeck

@main
class CounterPlugin: PluginDelegate {

	typealias Settings = NoSettings
    
    // MARK: Manifest
    static var name: String = "Counter"
    
    static var description: String = "Count things. On your Stream Deck!"
    
    static var category: String?
    
    static var categoryIcon: String?
    
    static var author: String = "Emory Dunn"
    
    static var icon: String = "Icons/pluginIcon"
    
    static var url: URL? = URL(string: "https://github.com/emorydunn/StreamDeckPlugin")
    
    static var version: String = "0.2"
    
    static var os: [PluginOS] = [.mac(minimumVersion: "10.15")]
    
    static var applicationsToMonitor: ApplicationsToMonitor?
    
    static var software: PluginSoftware = .minimumVersion("4.1")
    
    static var sdkVersion: Int = 2
    
    static var codePath: String = CounterPlugin.executableName
    
    static var codePathMac: String?
    
    static var codePathWin: String?
    
    static var actions: [any Action.Type] = [
        IncrementAction.self,
        DecrementAction.self
    ]
    
    @Environment(PluginCount.self) var count: Int

    required init() {
        NSLog("CounterPlugin init!")
    }
    
    func keyDown(action: String, context: String, device: String, payload: KeyEvent<Settings>) {
        StreamDeckPlugin.shared.instances.values.forEach {
            $0.setTitle(to: "\(count)", target: nil, state: nil)
        }
    }

}
