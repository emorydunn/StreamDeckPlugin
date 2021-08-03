    import XCTest
    @testable import StreamDeck

    final class EventsReceivedTests: XCTestCase {
        
        let decoder = JSONDecoder()
        
        func test_keyDown() {
            let data = """
            {
                "action": "com.elgato.example.action1",
                "event": "keyDown",
                "context": "opaqueValue",
                "device": "opaqueValue",
                "payload": {
                    "settings": {},
                    "coordinates": {
                        "column": 3,
                        "row": 1
                    },
                    "state": 0,
                    "userDesiredState": 1,
                    "isInMultiAction": false
                }
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(ActionEvent<KeyEvent>.self, from: data))
            
        }
        
        func test_keyUp() {
            let data = """
            {
                "action": "com.elgato.example.action1",
                "event": "keyUp",
                "context": "opaqueValue",
                "device": "opaqueValue",
                "payload": {
                    "settings": {},
                    "coordinates": {
                        "column": 3,
                        "row": 1
                    },
                    "state": 0,
                    "userDesiredState": 1,
                    "isInMultiAction": false
                }
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(ActionEvent<KeyEvent>.self, from: data))
            
        }
        
        func test_willAppear() {
            let data = """
            {
                "action": "com.elgato.example.action1",
                "event": "willAppear",
                "context": "opaqueValue",
                "device": "opaqueValue",
                "payload": {
                    "settings": {},
                    "coordinates": {
                        "column": 3,
                        "row": 1
                    },
                    "state": 0,
                    "isInMultiAction": false
                }
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(ActionEvent<AppearEvent>.self, from: data))
            
        }
        
        func test_willDisappear() {
            let data = """
            {
                "action": "com.elgato.example.action1",
                "event": "willDisappear",
                "context": "opaqueValue",
                "device": "opaqueValue",
                "payload": {
                    "settings": {},
                    "coordinates": {
                        "column": 3,
                        "row": 1
                    },
                    "state": 0,
                    "isInMultiAction": false
                }
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(ActionEvent<AppearEvent>.self, from: data))
            
        }
        
        func test_titleParametersDidChange() {
            let data = """
            {
              "action": "com.elgato.example.action1",
              "event": "titleParametersDidChange",
              "context": "opaqueValue",
              "device": "opaqueValue",
              "payload": {
                "coordinates": {
                  "column": 3,
                  "row": 1
                },
                "settings": {},
                "state": 0,
                "title": "",
                "titleParameters": {
                  "fontFamily": "",
                  "fontSize": 12,
                  "fontStyle": "",
                  "fontUnderline": false,
                  "showTitle": true,
                  "titleAlignment": "bottom",
                  "titleColor": "#ffffff"
                }
              }
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(ActionEvent<TitleInfo>.self, from: data))
            
        }
        
        func test_deviceDidConnect() {
            let data = """
            {
                "event": "deviceDidConnect",
                "device": "opaqueValue",
                 "deviceInfo": {
                    "name": "Device Name",
                    "type": 0,
                     "size": {
                        "columns": 5,
                        "rows": 3
                    }
                },
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(DeviceConnectionEvent.self, from: data))
            
        }
        
        func test_deviceDidDisconnect() {
            let data = """
            {
                "event": "deviceDidDisconnect",
                "device": "opaqueValue"
            }
            """.data(using: .utf8)!
            
            XCTAssertNoThrow(try decoder.decode(DeviceConnectionEvent.self, from: data))
            
        }
        
    }
