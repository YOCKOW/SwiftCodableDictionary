/* *************************************************************************************************
CodableDictionaryTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import XCTest
@testable import CodableDictionary

import Foundation

final class CodableDictionaryTests: XCTestCase {
  private func _assertCoding<K, V>(_ dictionary: CodableDictionary<K, V>, expectedJSON: String,
                                   file: StaticString = #file, line: UInt = #line) throws where V: Equatable {
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
