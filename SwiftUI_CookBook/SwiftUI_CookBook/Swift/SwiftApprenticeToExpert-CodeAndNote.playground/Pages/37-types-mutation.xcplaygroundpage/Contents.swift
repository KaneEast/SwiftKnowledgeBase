/*:
 注意：可以通过指定唯一的属性属性来给出值类型标识。该Identifiable协议添加了Hashable(and Equatable)id属性来执行此操作。SwiftUI 框架定义了属性包装器，例如@State，它将生命周期注入到简单值类型中。
 
 https://www.swift.org/documentation/api-design-guidelines/
 */

/*:
 Key points
 Swift is a strongly typed language that allows the compiler to check your program’s correctness before it runs. The better you get at working with types, the easier it will be to write correct programs.
 Here are some key points to keep in mind from this chapter:
 Structures, enumerations and classes are the fundamental named types that Swift uses to make every other concrete type, including Bool, Int, Optional, String, Array, etc.
 Create custom types to solve problems in your domain elegantly.
 Structures and enumerations are value types. Classes are reference types.
 Any type can be designed to have value semantics.
 The most straightforward way to get value semantics is to use a value type (structure or enumeration) that only contains other types with value semantics.
 All the standard types, including String, Array, Set and Dictionary, already have value semantics, making them easy to compose into larger types with value semantics.
 Making a class immutable is one way to give reference types value semantics.
 Value types are generally copied around on the stack, whereas reference types are allocated on the heap and are reference counted.
 Reference types have a built-in notion of lifetime and identity.
 Instance methods secretly pass in self.
 The mutating instance methods of value types pass inout self.
 Enumerations model a finite set of states.
 Avoid initializing half-baked, invalid objects. Instead, create failing initializers.
 A good set of types can act as compiler-checkable documentation.
 The foundation Measurement types make working with different units less error-prone by defining them as concrete types.
 Swift lets you improve the usage ergonomics for types you don’t even own.
 The protocol RawRepresentable lets you create simple, expressive types.
 Copy-on-write is a way to give reference types mutating value semantics.
 */


enum Coin: Int, CaseIterable {
  case penny = 1, nickel = 5, dime = 10, quarter = 25
}

let lucky = Coin(rawValue: 1)
lucky?.rawValue

struct Email: RawRepresentable {
  var rawValue: String

  init?(rawValue: String) {
    guard rawValue.contains("@") else {
      return nil
    }
    self.rawValue = rawValue
  }
}

func send(message: String, to: Email) {

}

public struct Point: Equatable {
  var x, y: Double
  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

extension Point {
  public static var zero: Point {
    Point(x: 0, y: 0)
  }
}

public struct PermutedCongruential: RandomNumberGenerator {
  private var state: UInt64
  private let multiplier: UInt64 = 6364136223846793005
  private let increment: UInt64 = 1442695040888963407
  private func rotr32(x: UInt32, r: UInt32) -> UInt32 {
    (x &>> r) | x &<< ((~r &+ 1) & 31)
  }
  private mutating func next32() -> UInt32 {
    var x = state
    let count = UInt32(x &>> 59)
    state = x &* multiplier &+ increment
    x ^= x &>> 18
    return rotr32(x: UInt32(truncatingIfNeeded: x &>> 27),
                  r: count)
  }
  public mutating func next() -> UInt64 {
    UInt64(next32()) << 32 | UInt64(next32())
  }
  public init(seed: UInt64) {
    state = seed &+ increment
    _ = next()
  }
}
