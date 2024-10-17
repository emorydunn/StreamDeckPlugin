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

	func fulfillment(of event: ReceivableEvent.EventKey, data: Data, plugin: TestPlugin) async {

		let comm = PluginCommunication(port: 42, uuid: "", event: "", info: info, plugin: plugin)
		PluginCommunication.shared = comm


		do {
			try await comm.parseEvent(event: event, context: nil, data: data)
		} catch {
			print(error)
		}

		await fulfillment(of: [plugin.eventExp], timeout: 1)
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

	func testDidReceiveGlobalSettings() async {
		class EventTestPlugin: TestPlugin {
			override func didReceiveGlobalSettings() {
				eventExp.fulfill()
			}
		}

		let event = ReceivableEvent.EventKey.didReceiveGlobalSettings
		let data = TestEvent.didReceiveGlobalSettings

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

	func testDidReceiveDeepLink() async {
		class EventTestPlugin: TestPlugin {
			override func didReceiveDeepLink(_ url: URL) {
				eventExp.fulfill()
			}
		}

		let event = ReceivableEvent.EventKey.didReceiveDeepLink
		let data = TestEvent.didReceiveDeepLink

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)
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

	func testDeviceDidConnect() async {
		class EventTestPlugin: TestPlugin {
			override func deviceDidConnect(_ device: String, deviceInfo: DeviceInfo) {
				XCTAssertEqual(device, "deviceDidConnect")
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.deviceDidConnect
		let data = TestEvent.deviceDidConnect

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

	func testDeviceDidDisconnect() async {
		class EventTestPlugin: TestPlugin {
			override func deviceDidDisconnect(_ device: String) {
				XCTAssertEqual(device, "deviceDidDisconnect")
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.deviceDidDisconnect
		let data = TestEvent.deviceDidDisconnect

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

	func testSystemDidWakeUp() async {
		class EventTestPlugin: TestPlugin {
			override func systemDidWakeUp() {
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.systemDidWakeUp
		let data = TestEvent.systemDidWakeUp

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

	func testApplicationDidLaunch() async {
		class EventTestPlugin: TestPlugin {
			override func applicationDidLaunch(_ application: String) {
				XCTAssertEqual(application, "com.test.launch")
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.applicationDidLaunch
		let data = TestEvent.applicationDidLaunch

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

	func testApplicationDidTerminate() async {
		class EventTestPlugin: TestPlugin {
			override func applicationDidTerminate(_ application: String) {
				XCTAssertEqual(application, "com.test.terminate")
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.applicationDidTerminate
		let data = TestEvent.applicationDidTerminate

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

	func testPropertyInspectorDidAppear() async {
		class EventTestPlugin: TestPlugin {
			override func propertyInspectorDidAppear(action: String, context: String, device: String) {
				XCTAssertEqual(action, "com.elgato.example.propertyInspectorDidAppear")
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.propertyInspectorDidAppear
		let data = TestEvent.propertyInspectorDidAppear

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)
		
	}

	func testPropertyInspectorDidDisappear() async {
		class EventTestPlugin: TestPlugin {
			override func propertyInspectorDidDisappear(action: String, context: String, device: String) {
				XCTAssertEqual(action, "com.elgato.example.propertyInspectorDidDisappear")
				eventExp.fulfill()
			}

		}

		let event = ReceivableEvent.EventKey.propertyInspectorDidDisappear
		let data = TestEvent.propertyInspectorDidDisappear

		let delegate = EventTestPlugin(expectation(description: #function))
		await fulfillment(of: event, data: data, plugin: delegate)

	}

}
