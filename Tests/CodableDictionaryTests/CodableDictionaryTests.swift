/* *************************************************************************************************
CodableDictionaryTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import XCTest
@testable import CodableDictionary

import Foundation

#if swift(>=6) && canImport(Testing)
import Testing

func expectJSON<K, V>(
  _ dictionary: CodableDictionary<K, V>,
  expectedJSON: String,
  sourceLocation: SourceLocation = #_sourceLocation
) throws where V: Equatable {
  let jsonData = try JSONEncoder().encode(dictionary)
  #expect(
    String(data: jsonData, encoding: .utf8) == expectedJSON,
    "Encoding failed.",
    sourceLocation: sourceLocation
  )
  #expect(
    try JSONDecoder().decode(CodableDictionary<K, V>.self, from: jsonData) == dictionary,
    "Decoding failed.",
    sourceLocation: sourceLocation
  )
}

@Test("String Key JSON Test")
func stringKeyJSONTest() throws {
  try expectJSON(["key": "value"], expectedJSON: #"{"key":"value"}"#)
}

@Test("Integer Key JSON Test")
func intKeyJSONTest() throws {
  try expectJSON([UInt(0): "value"], expectedJSON: #"{"0":"value"}"#)
}

@Test("String Enum Key JSON Test")
func stringEnumKeyJSONTest() throws {
  enum MyKey: String, CodableDictionaryKey {
    case key
  }
  try expectJSON([MyKey.key: "value"], expectedJSON: #"{"key":"value"}"#)
}

@Test("Integer Enum Key JSON Test")
func intEnumKeyJSONTest() throws {
  enum MyKey: Int, CodableDictionaryKey {
    case key = 0
  }
  try expectJSON([MyKey.key: "value"], expectedJSON: #"{"0":"value"}"#)
}

#else
final class CodableDictionaryTests: XCTestCase, @unchecked Sendable {
  private func _assertCoding<K, V>(_ dictionary: CodableDictionary<K, V>, expectedJSON: String,
                                   file: StaticString = #filePath, line: UInt = #line) throws where V: Equatable {
    let jsonData = try JSONEncoder().encode(dictionary)
    XCTAssertEqual(String(data: jsonData, encoding: .utf8), expectedJSON,
                   "Encoding failed.", file: file, line: line)
    XCTAssertEqual(try JSONDecoder().decode(CodableDictionary<K, V>.self, from: jsonData), dictionary,
                   "Decoding failed.", file: file, line: line)
  }

  func test_stringKey() throws {
    try _assertCoding(["key": "value"], expectedJSON: #"{"key":"value"}"#)
  }
  
  func test_intKey() throws {
    try _assertCoding([UInt(0): "value"], expectedJSON: #"{"0":"value"}"#)
  }
  
  func test_stringEnumKey() throws {
    enum MyKey: String, CodableDictionaryKey {
      case key
    }
    try _assertCoding([MyKey.key: "value"], expectedJSON: #"{"key":"value"}"#)
  }
  
  func test_intEnumKey() throws {
    enum MyKey: Int, CodableDictionaryKey {
      case key = 0
    }
    try _assertCoding([MyKey.key: "value"], expectedJSON: #"{"0":"value"}"#)
  }
}
#endif
