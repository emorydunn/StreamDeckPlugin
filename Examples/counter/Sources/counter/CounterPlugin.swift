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
    
    @Environment(PluginCount.self) var count: Int

    required init() { }

}
