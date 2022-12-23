//
//  PluginEventTests.swift
//  
//
//  Created by Emory Dunn on 10/31/21.
//

import XCTest
import Combine
@testable import StreamDeck

final class PluginEventTests: XCTestCase {
    
    let info = PluginRegistrationInfo(
        application: StreamDeckApp(language: .english, platform: .mac, platformVersion: "", version: ""),
        plugin: PluginInfo(version: "", uuid: "TestPlugin"),
        devicePixelRatio: 2,
        colors: [:])
    
    func wait(for event: ReceivableEvent.EventKey, data: Data, delegate: TestPlugin) {
        let plugin = StreamDeckPlugin(plugin: delegate, port: 42, uuid: "", event: "", info: info)
        
        do {
            try plugin.parseEvent(event: event, context: nil, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [delegate.eventExp], timeout: 1)
    }
    
//    func testDidReceiveSettings() {
//        class EventTestPlugin: TestPlugin {
//			override func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent<NoSettings>.Payload) {
//                print("EventTestPlugin", #function)
//                XCTAssertEqual(action, "com.elgato.example.didReceiveSettings")
//                eventExp.fulfill()
//            }
//
//        }
//
//        let event = ReceivableEvent.EventKey.didReceiveSettings
//        let data = TestEvent.didReceiveSettings
//
//        let delegate = EventTestPlugin(expectation(description: #function))
//        wait(for: event, data: data, delegate: delegate)
//
//    }
    
    func testDidReceiveGlobalSettings() {
        class EventTestPlugin: TestPlugin {
			override func didReceiveGlobalSettings(_ settings: TestPlugin.Settings) {
                eventExp.fulfill()
            }
        }
        
        let event = ReceivableEvent.EventKey.didReceiveGlobalSettings
        let data = TestEvent.didReceiveGlobalSettings

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
//    func testKeyDown() {
//        class EventTestPlugin: TestPlugin {
//			override func keyDown(action: String, context: String, device: String, payload: KeyEvent<NoSettings>) {
//                XCTAssertEqual(action, "com.elgato.example.keyDown")
//                eventExp.fulfill()
//            }
//        }
//
//        let event = ReceivableEvent.EventKey.keyDown
//        let data = TestEvent.keyDown
//
//        let delegate = EventTestPlugin(expectation(description: #function))
//        wait(for: event, data: data, delegate: delegate)
//
//    }
    
//    func testKeyUp() {
//        class EventTestPlugin: TestPlugin {
//            override func keyUp(action: String, context: String, device: String, payload: KeyEvent<NoSettings>) {
//                XCTAssertEqual(action, "com.elgato.example.keyUp")
//                eventExp.fulfill()
//            }
//        }
//
//        let event = ReceivableEvent.EventKey.keyUp
//        let data = TestEvent.keyUp
//
//        let delegate = EventTestPlugin(expectation(description: #function))
//        wait(for: event, data: data, delegate: delegate)
//
//    }
    
//    func testWillAppear() {
//        class EventTestPlugin: TestPlugin {
//            override func willAppear(action: String, context: String, device: String, payload: AppearEvent<NoSettings>) {
//                XCTAssertEqual(action, "com.elgato.example.willAppear")
//                eventExp.fulfill()
//            }
//
//        }
//
//        let event = ReceivableEvent.EventKey.willAppear
//        let data = TestEvent.willAppear
//
//        let delegate = EventTestPlugin(expectation(description: #function))
//        wait(for: event, data: data, delegate: delegate)
//
//    }
    
//    func testWillDisappear() {
//        class EventTestPlugin: TestPlugin {
//            override func willDisappear(action: String, context: String, device: String, payload: AppearEvent<NoSettings>) {
//                XCTAssertEqual(action, "com.elgato.example.willDisappear")
//                eventExp.fulfill()
//            }
//
//        }
//
//        let event = ReceivableEvent.EventKey.willDisappear
//        let data = TestEvent.willDisappear
//
//        let delegate = EventTestPlugin(expectation(description: #function))
//        wait(for: event, data: data, delegate: delegate)
//
//    }
    
//    func testTitleParametersDidChange() {
//        class EventTestPlugin: TestPlugin {
//            override func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo<NoSettings>) {
//                XCTAssertEqual(action, "com.elgato.example.titleParametersDidChange")
//                eventExp.fulfill()
//            }
//
//        }
//
//        let event = ReceivableEvent.EventKey.titleParametersDidChange
//        let data = TestEvent.titleParametersDidChange
//
//        let delegate = EventTestPlugin(expectation(description: #function))
//        wait(for: event, data: data, delegate: delegate)
//
//    }
    
    func testDeviceDidConnect() {
        class EventTestPlugin: TestPlugin {
            override func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) {
                XCTAssertEqual(device, "deviceDidConnect")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.deviceDidConnect
        let data = TestEvent.deviceDidConnect

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testDeviceDidDisconnect() {
        class EventTestPlugin: TestPlugin {
            override func deviceDidDisconnect(_ device: String) {
                XCTAssertEqual(device, "deviceDidDisconnect")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.deviceDidDisconnect
        let data = TestEvent.deviceDidDisconnect

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testSystemDidWakeUp() {
        class EventTestPlugin: TestPlugin {
            override func systemDidWakeUp() {
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.systemDidWakeUp
        let data = TestEvent.systemDidWakeUp

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testApplicationDidLaunch() {
        class EventTestPlugin: TestPlugin {
            override func applicationDidLaunch(_ application: String) {
                XCTAssertEqual(application, "com.test.launch")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.applicationDidLaunch
        let data = TestEvent.applicationDidLaunch

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testApplicationDidTerminate() {
        class EventTestPlugin: TestPlugin {
            override func applicationDidTerminate(_ application: String) {
                XCTAssertEqual(application, "com.test.terminate")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.applicationDidTerminate
        let data = TestEvent.applicationDidTerminate

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testPropertyInspectorDidAppear() {
        class EventTestPlugin: TestPlugin {
            override func propertyInspectorDidAppear(action: String, context: String, device: String) {
                XCTAssertEqual(action, "com.elgato.example.propertyInspectorDidAppear")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.propertyInspectorDidAppear
        let data = TestEvent.propertyInspectorDidAppear

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testPropertyInspectorDidDisappear() {
        class EventTestPlugin: TestPlugin {
            override func propertyInspectorDidDisappear(action: String, context: String, device: String) {
                XCTAssertEqual(action, "com.elgato.example.propertyInspectorDidDisappear")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.propertyInspectorDidDisappear
        let data = TestEvent.propertyInspectorDidDisappear

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
    
    func testSendToPlugin() {
        class EventTestPlugin: TestPlugin {
            override func sentToPlugin(context: String, action: String, payload: [String : String]) {
                XCTAssertEqual(action, "com.elgato.example.sendToPlugin")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.sendToPlugin
        let data = TestEvent.sendToPlugin

        let delegate = EventTestPlugin(expectation(description: #function))
        wait(for: event, data: data, delegate: delegate)

    }
}
