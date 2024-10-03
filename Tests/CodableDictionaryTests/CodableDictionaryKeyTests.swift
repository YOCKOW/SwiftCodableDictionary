/* *************************************************************************************************
CodableDictionaryKeyTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import XCTest
@testable import CodableDictionary

#if swift(>=6) && canImport(Testing)
import Testing

@Test("Integer Key Test")
func integerKeyTest() {
  #expect(UInt8(intValue: 0) == 0)
  #expect(UInt8(intValue: 255) == 255)
  #expect(UInt8(intValue: -1) == nil)
  #expect(UInt8(intValue: 256) == nil)
}

@Test("Enum Key Test")
func enumKeyTest() {
  enum SomeStringKey: String, CodableDictionaryKey {
    case key = "my key"
  }

  enum SomeIntKey: Int, CodableDictionaryKey {
    case hundred = 100
  }

  enum SomeUIntKey: UInt, CodableDictionaryKey {
    case hundred = 100
  }

  #expect(SomeStringKey.key.stringValue == "my key")
  #expect(SomeStringKey(stringValue: "my key") == .key)
  #expect(SomeStringKey(stringValue: "your key") == nil)

  #expect(SomeIntKey.hundred.stringValue == "100")
  #expect(SomeIntKey.hundred.intValue == 100)
  #expect(SomeIntKey(stringValue: "100") == .hundred)
  #expect(SomeIntKey(intValue: 100) == .hundred)

  #expect(SomeUIntKey.hundred.stringValue == "100")
  #expect(SomeUIntKey.hundred.intValue == 100)
  #expect(SomeUIntKey(stringValue: "100") == .hundred)
  #expect(SomeUIntKey(intValue: 100) == .hundred)
}

@Test("Original RawRepresentable Key Test")
func originalRawRepresentableKeyTest() throws {
  struct MyKey: RawRepresentable, CodableDictionaryKey {
    struct RawValue: CodableDictionaryKey {
      var stringValue: String

      init?(stringValue: String) {
        self.stringValue = stringValue
      }

      var intValue: Int? { return Int(self.stringValue) }

      init?(intValue: Int) {
        self.stringValue = String(intValue)
      }
    }

    let rawValue: RawValue

    init(rawValue: RawValue) {
      self.rawValue = rawValue
    }
  }

  let key = MyKey(stringValue: "my key")
  #expect(try #require(key?.stringValue) == "my key")
  #expect(key?.intValue == nil)
}

#else
final class CodableDictionaryKeyTests: XCTestCase, @unchecked Sendable {
  func test_integerKey() {
    XCTAssertEqual(UInt8(intValue: 0), 0)
    XCTAssertEqual(UInt8(intValue: 255), 255)
    XCTAssertEqual(UInt8(intValue: -1), nil)
    XCTAssertEqual(UInt8(intValue: 256), nil)
  }
  
  func test_enumKey() {
    enum SomeStringKey: String, CodableDictionaryKey {
      case key = "my key"
    }
    
    enum SomeIntKey: Int, CodableDictionaryKey {
      case hundred = 100
    }
    
    enum SomeUIntKey: UInt, CodableDictionaryKey {
      case hundred = 100
    }
    
    XCTAssertEqual(SomeStringKey.key.stringValue, "my key")
    XCTAssertEqual(SomeStringKey(stringValue: "my key"), .key)
    XCTAssertEqual(SomeStringKey(stringValue: "your key"), nil)
    
    XCTAssertEqual(SomeIntKey.hundred.stringValue, "100")
    XCTAssertEqual(SomeIntKey.hundred.intValue, 100)
    XCTAssertEqual(SomeIntKey(stringValue: "100"), .hundred)
    XCTAssertEqual(SomeIntKey(intValue: 100), .hundred)
    
    XCTAssertEqual(SomeUIntKey.hundred.stringValue, "100")
    XCTAssertEqual(SomeUIntKey.hundred.intValue, 100)
    XCTAssertEqual(SomeUIntKey(stringValue: "100"), .hundred)
    XCTAssertEqual(SomeUIntKey(intValue: 100), .hundred)
  }
  
  func test_originalRawRepresentableKey() {
    struct MyKey: RawRepresentable, CodableDictionaryKey {
      struct RawValue: CodableDictionaryKey {
        var stringValue: String
        
        init?(stringValue: String) {
          self.stringValue = stringValue
        }
        
        var intValue: Int? { return Int(self.stringValue) }
        
        init?(intValue: Int) {
          self.stringValue = String(intValue)
        }
      }
      
      let rawValue: RawValue
      
      init(rawValue: RawValue) {
        self.rawValue = rawValue
      }
    }
    
    let key = MyKey(stringValue: "my key")
    XCTAssertEqual(key?.stringValue, "my key")
    XCTAssertEqual(key?.intValue, nil)
  }

  func test_issue2() {
    // https://github.com/YOCKOW/SwiftCodableDictionary/issues/2
    XCTAssertEqual(String(Int(0)), "0")
    XCTAssertEqual(Int(0).description, "0")
  }
}
#endif
