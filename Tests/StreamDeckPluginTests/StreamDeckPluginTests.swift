import XCTest
@testable import StreamDeck

final class EventsReceivedTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func test_keyDown() {
        let data = TestEvent.keyDown
        
        XCTAssertNoThrow(try decoder.decode(ActionEvent<KeyEvent<NoSettings>>.self, from: data))
        
    }
    
    func test_keyUp() {
        let data = TestEvent.keyUp
        
        XCTAssertNoThrow(try decoder.decode(ActionEvent<KeyEvent<NoSettings>>.self, from: data))
        
    }
    
    func test_willAppear() {
        let data = TestEvent.willAppear
        
        XCTAssertNoThrow(try decoder.decode(ActionEvent<AppearEvent<NoSettings>>.self, from: data))
        
    }
    
    func test_willDisappear() {
        let data = TestEvent.willDisappear
        
        XCTAssertNoThrow(try decoder.decode(ActionEvent<AppearEvent<NoSettings>>.self, from: data))
        
    }
    
    func test_titleParametersDidChange() {
        let data = TestEvent.titleParametersDidChange
        
        XCTAssertNoThrow(try decoder.decode(ActionEvent<TitleInfo<NoSettings>>.self, from: data))
        
    }
    
    func test_deviceDidConnect() {
        let data = TestEvent.deviceDidConnect
        
        XCTAssertNoThrow(try decoder.decode(DeviceConnectionEvent.self, from: data))
        
    }
    
    func test_deviceDidDisconnect() {
        let data = TestEvent.deviceDidDisconnect
        
        XCTAssertNoThrow(try decoder.decode(DeviceConnectionEvent.self, from: data))
        
    }
    
}
