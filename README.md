# What is `SwiftCodableDictionary`?

Yet another workaround for [SR-7788](https://bugs.swift.org/browse/SR-7788).


## Overview

As [implemented in the standard library](https://github.com/apple/swift/blob/90cb347cd9552024ce2483e516b6f3788eca44be/stdlib/public/core/Codable.swift#L5521-L5635),
`Dictionary` can be en/decoded in/from a keyed container **only if the dictionary uses `String` or `Int` keys**.
An unkeyed container is used to encode `Dictionary` even if `Key` conforms to `Codable`, and
a keyed container cannot be decoded even if `Key` can be decoded from a string representation. 

`CodableDictionary` resolves the issue. 
`CodableDictionary` can be en/decoded
while its `Key` conforms to [`CodableDictionaryKey`](./Sources/CodableDictionary/CodableDictionaryKey.swift)
that inherits from `Hashable` and `CodingKey`.
The point is that `Key` does not have to conform to `Codable`.


## Usage

```Swift
import Foundation
import CodableDictionary

enum Key: String, CodableDictionaryKey { 
   case key
   // No additional implementation is required,
   // because `CodableDictionaryKey` provides default implementation.
}

let dictionary: CodableDictionary<Key, String> = [.key: "value"]

let json = String(data: try JSONEncoder().encode(dictionary), encoding: .utf8)!
print(json) // -> {"key":"value"}

let decoded = try JSONDecoder().decode(CodableDictionary<Key, String>.self, from: json.data(using: .utf8)!)
print(dictionary == decoded) // -> true

```


# Requirements

- Swift 5
- OS
  * macOS
  * Linux



# License

MIT License.  
See "LICENSE.txt" for more information.


