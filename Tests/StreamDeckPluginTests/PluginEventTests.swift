//
//  PluginEventTests.swift
//  
//
//  Created by Emory Dunn on 10/31/21.
//

import XCTest
import Combine
@testable import StreamDeck

class TestPlugin: StreamDeckPlugin {
    
    let eventExp: XCTestExpectation
    
    init(_ exp: XCTestExpectation) throws {
        self.eventExp = exp
        try super.init(port: 42, uuid: "", event: "", info: "")
    }
    
    required init(port: Int32, uuid: String, event: String, info: String) throws {
        fatalError("init(port:uuid:event:info:) has not been implemented")
    }

}

final class PluginEventTests: XCTestCase {
    
    func testDidReceiveSettings() {
        class EventTestPlugin: TestPlugin {
            override func didReceiveSettings(action: String, context: String, device: String, payload: SettingsEvent.Payload) {
                XCTAssertEqual(action, "com.elgato.example.didReceiveSettings")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.didReceiveSettings
        let data = TestEvent.didReceiveSettings

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testDidReceiveGlobalSettings() {
        class EventTestPlugin: TestPlugin {
            override func didReceiveGlobalSettings(_ settings: [String: String]) {
                XCTAssertFalse(settings.isEmpty)
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.didReceiveGlobalSettings
        let data = TestEvent.didReceiveGlobalSettings

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testKeyDown() {
        class EventTestPlugin: TestPlugin {
            override func keyDown(action: String, context: String, device: String, payload: KeyEvent) {
                XCTAssertEqual(action, "com.elgato.example.keyDown")
                eventExp.fulfill()
            }
        }
        
        let event = ReceivableEvent.EventKey.keyDown
        let data = TestEvent.keyDown

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testKeyUp() {
        class EventTestPlugin: TestPlugin {
            override func keyUp(action: String, context: String, device: String, payload: KeyEvent) {
                XCTAssertEqual(action, "com.elgato.example.keyUp")
                eventExp.fulfill()
            }
        }
        
        let event = ReceivableEvent.EventKey.keyUp
        let data = TestEvent.keyUp

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testWillAppear() {
        class EventTestPlugin: TestPlugin {
            
            override func willAppear(action: String, context: String, device: String, payload: AppearEvent) {
                XCTAssertEqual(action, "com.elgato.example.willAppear")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.willAppear
        let data = TestEvent.willAppear

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testWillDisappear() {
        class EventTestPlugin: TestPlugin {
            override func willDisappear(action: String, context: String, device: String, payload: AppearEvent) {
                XCTAssertEqual(action, "com.elgato.example.willDisappear")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.willDisappear
        let data = TestEvent.willDisappear

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testTitleParametersDidChange() {
        class EventTestPlugin: TestPlugin {
            override func titleParametersDidChange(action: String, context: String, device: String, info: TitleInfo) {
                XCTAssertEqual(action, "com.elgato.example.titleParametersDidChange")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.titleParametersDidChange
        let data = TestEvent.titleParametersDidChange

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testDeviceDidConnect() {
        class EventTestPlugin: TestPlugin {
            override func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) {
                XCTAssertEqual(device, "deviceDidConnect")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.deviceDidConnect
        let data = TestEvent.deviceDidConnect

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

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

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testSystemDidWakeUp() {
        class EventTestPlugin: TestPlugin {
            override func systemDidWakeUp() {
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.systemDidWakeUp
        let data = TestEvent.systemDidWakeUp

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

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

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

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

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

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

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

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

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
    
    func testSendToPlugin() {
        class EventTestPlugin: TestPlugin {
            override func sendToPlugin(context: String, action: String, payload: [String : String]) {
                XCTAssertEqual(action, "com.elgato.example.sendToPlugin")
                eventExp.fulfill()
            }
            
        }
        
        let event = ReceivableEvent.EventKey.sendToPlugin
        let data = TestEvent.sendToPlugin

        let plugin = try! EventTestPlugin(expectation(description: #function))
        
        do {
            try plugin.parseEvent(event: event, data: data)
        } catch {
            print(error)
        }
        
        wait(for: [plugin.eventExp], timeout: 1)

    }
}
