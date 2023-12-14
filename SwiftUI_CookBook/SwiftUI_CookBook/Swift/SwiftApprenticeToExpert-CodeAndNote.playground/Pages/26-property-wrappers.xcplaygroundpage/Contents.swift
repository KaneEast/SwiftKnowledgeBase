// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/#Property-Wrappers

/*:
 在Swift Apprentice：基础知识的“属性”一章中，您了解了属性观察器以及如何使用它们来影响类型中属性的行为。属性包装器通过让您命名和重用自定义逻辑，将这一想法提升到一个新的水平。他们通过将自定义逻辑移动到您可以定义的辅助类型来实现此目的。
 如果您使用过 SwiftUI，那么您已经遇到过属性包装器（以及它们基于 @ 的、$-happy 语法）。SwiftUI 广泛使用它们，因为它们几乎允许无限地自定义属性语义，而 SwiftUI 需要这些语义来在幕后执行视图更新和数据同步魔法。
 
 Swift 核心团队努力使属性包装器成为通用语言功能。例如，它们已经在 Apple 生态系统之外的 Vapor 项目中使用。在这种情况下，属性包装器允许您定义数据模型并将其映射到 PostgreSQL 等数据库。
 
 wrapped value
 projected value
 
 func printValueV3(@ZeroTo(upper: 10) _ value: Double) {
   print("The wrapped value is", value)
   print("The projected value is", $value)
 }
 */

//: Thinking: Custom property wrapper instead of @AppStorage ?

import Foundation

@propertyWrapper
struct ZeroToOne {
  private var value: Double

  private static func clamped(_ input: Double) -> Double {
    min(max(input, 0), 1)
  }

  init(wrappedValue: Double) {
    value = Self.clamped(wrappedValue)
  }

  var wrappedValue: Double {
    get { value }
    set { value =  Self.clamped(newValue) }
  }
}

@propertyWrapper
struct ZeroToOneV2 {
  private var value: Double

  init(wrappedValue: Double) {
    value = wrappedValue
  }

  var wrappedValue: Double {
    get { min(max(value, 0), 1) }
    set { value = newValue }
  }

  var projectedValue: Double { value }
}

@propertyWrapper
struct ZeroTo<Value: Numeric & Comparable> {
  private var value: Value
  let upper: Value

  init(wrappedValue: Value, upper: Value) {
    value = wrappedValue
    self.upper = upper
  }

  var wrappedValue: Value {
    get { min(max(value, 0), upper) }
    set { value = newValue }
  }

  var projectedValue: Value { value }
}


struct Color: CustomStringConvertible {
  @ZeroToOne var red: Double
  @ZeroToOne var green: Double
  @ZeroToOne var blue: Double

  var description: String {
    "r: \(red) g: \(green) b: \(blue)"
  }
}

// Preset colors
extension Color {
  static var black = Color(red: 0, green: 0, blue: 0)
  static var white = Color(red: 1, green: 1, blue: 1)
  static var blue  = Color(red: 0, green: 0, blue: 1)
  static var green = Color(red: 0, green: 1, blue: 0)
  // more ...
}

var superRed = Color(red: 2, green: 0, blue: 0)
print(superRed) // r: 1, g: 0, b: 0
superRed.blue = -2
print(superRed) // r: 1, g: 0, b: 0

func printValue(@ZeroToOne _ value: Double) {
  print("The wrapped value is", value)
}

printValue(3.14)

func printValueV2(@ZeroToOneV2 _ value: Double) {
  print("The wrapped value is", value)
  print("The projected value is", $value)
}

printValueV2(3.14)

func printValueV3(@ZeroTo(upper: 10) _ value: Double) {
  print("The wrapped value is", value)
  print("The projected value is", $value)
}
printValueV3(42)

// Paint bucket abstraction
class Bucket {
  var color: Color
  var isRefilled = false

  init(color: Color) {
    self.color = color
  }

  func refill() {
    isRefilled = true
  }
}


// Copy-on-write, using a property wrapper

// a property wrapper, named CopyOnWriteColor
@propertyWrapper
struct CopyOnWriteColor {
  // ... which can be initialized with a Color,
  // thus allowing the wrapped property to be initialized with Color
  init(wrappedValue: Color) {
    self.bucket = Bucket(color: wrappedValue)
  }

  // ...  defining a private property, which holds the storage
  private var bucket: Bucket

  // ... defining a wrappedValue with computed properties, which
  // implement the usual copy-on-write logic
  var wrappedValue: Color {
    get {
      bucket.color
    }
    set {
      if isKnownUniquelyReferenced(&bucket) {
        bucket.color = newValue
      } else {
        bucket = Bucket(color: newValue)
      }
    }
  }
}

struct PaintingPlan {

  // a value semantic type, which is a simple value type
  var accent = Color.white

  // a value semantic type, backed by a reference type managed by a property wrapper
  @CopyOnWriteColor var bucketColor = .blue
  // ... and another, without any code duplication
  @CopyOnWriteColor var bucketColorForDoor = .blue
  // ... and another, without any code duplication
  @CopyOnWriteColor var bucketColorForWalls = .blue
}

var artPlan = PaintingPlan()
var housePlan = artPlan
housePlan.bucketColor = Color.green
artPlan.bucketColor // blue. good!


/*:
 这些术语的秘诀在于不要从字面上理解它们，因为它们的名称具有误导性。为了使它们的功能更加清晰，这里有一组简短的工作定义：
 属性包装器：通过其定义并呈现属性wrappedValue。
 包装值：只是属性包装器呈现的值wrappedValue。
 投影值：属性包装器通过$语法公开的任意值。它可能与包装值没有任何关系。
 那么这些术语如何应用于绘画计划示例呢？
 @CopyOnWriteColor创建一个CopyOnWriteColor实例。该实例是属性包装器。
 客户端通过实例的属性与实例交互wrappedValue。这是包装后的值。
 CopyOnWriteColor根本不提供预计值。
 */

// ValidatedDate property wrapper,
// which requires strings to fit a specific format

@propertyWrapper
public struct ValidatedDate {
    
  private var storage: Date? = nil
  private(set) var formatter = DateFormatter()

  public init(wrappedValue: String) {
    self.formatter.dateFormat = "yyyy-mm-dd"
    self.wrappedValue = wrappedValue
  }

  public var wrappedValue: String {
    set {
      self.storage = formatter.date(from: newValue)
    }
    get {
      if let date = self.storage {
        return formatter.string(from: date)
      } else {
        return "invalid"
      }
    }
  }
  
  public var projectedValue: DateFormatter {
    get { formatter }
    set { formatter = newValue }
  }
}

struct Order {
  
  @ValidatedDate var orderPlacedDate: String = ""
//  @ValidatedDate var shippingDate: String
//  @ValidatedDate var deliveredDate: String
}

var order = Order()
// store a valid date string
order.orderPlacedDate = "2014-06-02"
order.orderPlacedDate // => 2014-06-02
// try to store an invalid date
order.orderPlacedDate = "2015-06-50"
// observe that all you can read back is "invalid"
order.orderPlacedDate // => "invalid"
order.orderPlacedDate = "2014-06-02"

// update the date format using the projected value
let otherFormatter = DateFormatter()
otherFormatter.dateFormat = "mm/dd/yyyy"
order.$orderPlacedDate = otherFormatter
// read the string in the new format
order.orderPlacedDate // => "06/02/2014"



/*:
 Key Points
 Property wrappers have a lot of flexibility and power, but you also need to use them carefully. Here are some things to remember:
 Unusual SwiftUI syntax that uses @ and $ characters is not unique to SwiftUI. It’s an advanced application of property wrappers, a language feature anyone can use.
 A property wrapper lets you apply custom logic to define the behavior of reading and writing a property such as @MyWrapper var myproperty. It lets you define this logic so you can reuse it easily over many properties.
 A property wrapper’s wrappedValue defines the external interface to the value, which is exposed as the wrapped property itself, as in myproperty.
 A property wrapper can have a projectedValue, which provides a handle for other interactions with the property wrapper. For example, it’s exposed via the $ syntax, as in $myproperty.
 Property wrapping is conceptual. It doesn’t use the typical object-oriented programming pattern where one object acts as an adapter by physically wrapping another actual object. Consequently, there isn’t necessarily a stored property or value that exists untouched “underneath” the wrapper.
 */
