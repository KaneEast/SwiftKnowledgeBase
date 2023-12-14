/*:
 值类型 copy-by-copy
 
 何时首选值语义
 什么时候应该设计一种类型来支持值语义？此选择取决于您的类型应该建模的内容。
 值语义适合表示惰性的描述性数据——数字、字符串和物理量，如角度、长度或颜色；数学对象，如向量和矩阵；纯二进制数据；最后，这些值的集合以及由这些值构成的大型、丰富的结构，例如媒体。
 */

struct Color: CustomStringConvertible {
  var red, green, blue: Double
  
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

let azurePaint = Bucket(color: .blue)
let wallBluePaint = azurePaint
wallBluePaint.isRefilled // => false, initially
azurePaint.refill()
wallBluePaint.isRefilled // => true, unsurprisingly!

extension Color {
  mutating func darken() {
    red *= 0.9; green *= 0.9; blue *= 0.9
  }
}

var azure = Color.blue
var wallBlue = azure
azure  // r: 0.0 g: 0.0 b: 1.0
wallBlue.darken()
azure  // r: 0.0 g: 0.0 b: 1.0 (unaffected)


class ReferenceType { var value = 0 }
struct ValueType { var value = 0 }

typealias MysteryType = ReferenceType
// or
// typealias MysteryType = ValueType

func exposeValue(_ mystery: MysteryType) -> Int {
  mystery.value
}

var x = MysteryType()
var y = x
exposeValue(x) // => initial value derived from x
// {code here which uses only y}
y.value = 10
exposeValue(x) // => final value derived from x
// Q: are the initial and final values different?


do {
  // No copy-on-write
  
  struct PaintingPlan { // a value type, containing ...
    // a value type
    var accent = Color.white
    // a mutable reference type
    var bucket = Bucket(color: .blue)
  }
  
  let artPlan = PaintingPlan()
  let housePlan = artPlan
  artPlan.bucket.color // => blue
  // for house-painting only we fill the bucket with green paint
  housePlan.bucket.color = Color.green
  artPlan.bucket.color // => green. oops!

  /*
   A side note: In the code above, the Swift compiler complains that artPlan
   and housePlan are never mutated and so could be changed to let constants.

   In what sense are they are never being mutated, even though we are changing
   the color in their bucket? Because from the compiler's point of view,
   the _value_ of this PaintingPlan is determined by _which_ bucket it
   points to, not the value of the paint in the bucket. This is because
   Bucket is a reference type.
   */
  
} // end of scope, so we can try again


/*:
 # 写时复制
 
 */

do {
  // Copy-on-write
  
  struct PaintingPlan { // a value type, containing ...
    // a value type
    var accent = Color.white
    // a private reference type, for "deep storage"
    private var bucket = Bucket(color: .blue)
    
    // a pseudo-value type, using the deep storage
    var bucketColor: Color {
      get {
        bucket.color
      }
      set {
        bucket = Bucket(color: newValue)
      }
    }
  }
  
  let artPlan = PaintingPlan()
  var housePlan = artPlan
  housePlan.bucketColor = Color.green
  artPlan.bucketColor // blue. better!

  /*
   To continue the side note: The compiler does not complain that the variables
   could be constants here, because from its point of view they are being
   mutated, because bucketColor is a value type.
   */
  
} // end of do scope, so you can try again!


do {
// Copy-on-write, but only copy when you absolutely have to

  struct PaintingPlan { // a value type, containing ...
    // a value type
    var accent = Color.white
    // a private reference type, for "deep storage"
    private var bucket = Bucket(color: .blue)
    
    // a computed property facade over deep storage
    // with copy-on-write and in-place mutation when possible
    var bucketColor: Color {
      get {
        bucket.color
      }
      set {
        if isKnownUniquelyReferenced(&bucket) {
          bucket.color = bucketColor
        } else {
          bucket = Bucket(color: newValue)
        }
      }
    }
  }
  
  let artPlan = PaintingPlan()
  var housePlan = artPlan
  housePlan.bucketColor = Color.green
  artPlan.bucketColor // blue. good!

} // end of do scope, so you can try again



/*:
 Recipes for Value Semantics
 To summarize, here is the recipe for determining if a type has value semantics or for defining your own such type:
 For a reference type (a class):
 The type must be immutable, so the requirement is that all its properties are constant and must be of types that have value semantics.
 For a value type (a struct or enum):
 A primitive value type like Int always has value semantics.
 If you define a struct type with properties, that type will have value semantics if all of its properties have value semantics.
 Similarly, if you define an enum type with associated values, that type will have value semantics if all its associated values have value semantics.
 
 For COW value types —struct or enum:
 Choose the “value-semantics access level”, that is, the access level that’ll expose an interface that preserves value semantics.
 Note all mutable reference-type properties, as these are the ones that spoil automatic value semantics. Set their access level below the value-semantics level.
 Define setters and mutating functions at and above the value-semantics access level so that they never actually modify a shared instance of those reference-type properties but instead assign a copy of the instance to the reference-type property.
 
 
 
 
 # Sendable
 While the benefits of value semantics may seem subtle, the recipe above is fairly simple at the end of the day. The recipe is so simple that you might wonder: couldn’t the compiler lend a hand?
 For instance, wouldn’t it be nice if the compiler let you somehow mark a type as having value semantics? For instance, by letting you declare that a type is ValueSemantic? And if the compiler knew that primitive types like Int and String are all intrinsically ValueSemantic?
 And that structs, enums, and tuples can only be ValueSemantic when all their members or associated values are ValueSemantic? And that class types can only be ValueSemantic when they contain only immutable stored properties that are also ValueSemantic? This reasoning, after all, is the essence of the recipe.
 If the compiler knew all that, it could validate the types you declare as ValueSemantic. It could even generate those declarations, automatically detecting that certain types are ValueSemantic.
 In fact, as of Swift 5.5, the compiler does this – but ValueSemantic is the new protocol Sendable, a marker protocol. Why finally introduce _ direct_ compiler support for a feature, value semantics, which has long been deeply embedded in the language and libraries implicitly? And why call it Sendable?
 Recall that a key benefit of value semantics is that it makes types immune from side effects, aiding local reasoning. This property is invaluable in concurrent programming since it ensures you can pass a value from one concurrency domain to another completely, eliminating the risk that the value will be mutated from two concurrent domains. This guarantee is the motivation for Sendable.
 Sendable is arriving in Swift as one of a set of carefully integrated features to support concurrent programming. It’s called “Sendable” to indicate that a value is safe to send from one domain to another. When the compiler sees code that tries to pass a non-Sendable value across domains, it raises an error at compile-time, preventing the sort of concurrency bug which is notoriously hard to understand at runtime. You’ll learn more about Swift’s concurrency features in Chapter 12, “Concurrency”.
 So can you treat Sendable as a synonym for having value semantics? Not quite, because Sendable is designed primarily with concurrency in mind. For instance, there is no facility to specify an access level. However, Apple’s Swift documentation now specifies which types conform to Sendable in the documentation for Sendable. Also, for any type that conforms, Sendable is listed with the other protocols in the “Conforms To” section of that type and includes notes as to any caveats. For example, the documentation notes that Array conforms to Sendable but only “when Element conforms to Sendable”. So it’s worth watching this protocol closely to see how much you can lean on it as a straightforward, compiler-enforced way to keep track of value semantics, an essential aspect of a type that used to be visible only to those with a discerning eye.
 */


/*:
 Where to Go From Here?
 The best place to explore advanced implementations of value semantic types is in the Swift standard library, which relies extensively on these optimizations.
 Apple and many practitioners in the wider community have written about value types and value-oriented programming more generally. Here are some relevant videos available online:
 WWDC 2016, session 207: What’s New in Foundation for Swift https://developer.apple.com/videos/play/wwdc2016/207/. Apple.
 WWDC 2015, session 414: Building Better Apps with Value Types https://developer.apple.com/videos/play/wwdc2015/414/. Apple.
 Controlling Complexity in Swift http://bit.ly/control-complexity. Andy Matuschak.
 Value of Values https://www.infoq.com/presentations/Value-Values. Rich Hickey.
 Value Semantics versus Value Types http://bit.ly/swift-value-semantics-not-types. Your humble author.
 Episode 71: “Polymorphic interfaces”, in Swift by Sundell https://www.swiftbysundell.com/podcast/71/. Dave Abrahams, a former member of the Swift core team.
 These talks offer a perspective complementary to the one in this chapter. However, only the last two resources focus on the distinctions between value types defined by assignment behavior and value semantics defined by the independence of variable values. Dave’s discussion of value semantics, which starts around the 54-minute mark of the interview, is particularly helpful for seeing the historical roots in functional programming and C++ assignment behaviors and dispelling the widespread misunderstanding that “copy-on-write” is a kind of semantics rather than a performance optimization.
 */
