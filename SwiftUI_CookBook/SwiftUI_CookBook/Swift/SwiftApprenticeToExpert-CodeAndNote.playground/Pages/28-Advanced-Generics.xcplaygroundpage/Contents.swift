/*:
 
 
 
 # 类型擦除
 不仅在 Swift 标准库中，在其他库中也有几种类型擦除的类型。例如，AnyIterator、AnySequence、 AnyCollection、AnyHashable是 Swift 标准库的一部分。AnyPublisher是Combine 框架的一部分，AnyView也是SwiftUI 的一部分。
 
 # 不透明类型
 
 注意：不透明返回类型构成了SwiftUI的一个主要特性，其View协议返回 a bodyof some View。不必知道返回视图的确切类型并在每次按钮移动时维护它。这种维护非常容易出错。底层的具体类型意味着 SwiftUI 可以快速找到视图之间的差异，从而转化为出色的用户体验和简单的编程模型。
 
 some不允许混合不同类型的对象，但any没有抱怨。
 
 使用不透明类型代替尖括号
 您可以使用不透明类型进行泛型编程。考虑以下：
 func product<C: Collection>(_ input: C) -> Double where C.Element == Double {
   input.reduce(1, *)
 }
 product([1,2,3,4]) // 24

 
 尽管您可能需要使用传统的通用尖括号和where子句来进行某些类型的约束，但您应该尽可能选择这种更易于阅读的样式。
 
 
 关键点
 您可以将协议用作存在类型、不透明类型和泛型约束。
 存在使用关键字any，并且是可以多态使用的装箱类型，就像基类一样。
 通用约束表达类型所需的功能。
 关联类型使协议具有通用性。它们提供了更大的通用性并且可以进行类型检查。
 类型擦除是一种隐藏具体细节同时保留重要类型信息的方法。
 您可以将关联类型标记为主要关联类型，这样您就可以将它们显式指定为尖括号中的约束。
 some关键字创建一个不透明类型，使您只能访问具体类型的协议信息。
 您编写的代码越通用，您可以重用它的地方就越多。
 
 */


protocol TPet {
  var name: String { get }
}
struct testClass {
  
  struct Cat: TPet {
    var name: String
  }
  
  /*:
   Here, you defined the variable pet with a type of any Pet instead of the concrete type Cat. Here any Pet is an existential type or boxed type— it’s an abstract concept, a protocol, that refers to a concrete type, such as a struct, that exists. The compiler automatically creates a boxed type and wires up the concrete type inside of it.
   
   Note: Strictly speaking, for simple protocols with no associated types, you do not need to use the any keyword before the protocol. However, the need to write any may change in future versions of Swift and become required. The any makes clear you are paying a small but non-zero cost of accessing the concrete type through the compiler-generated box type.
   */
  var somePet: any TPet = Cat(name: "Whiskers")
}


//protocol Pet {
//  associatedtype Food
//  var name: String { get }
//}

//protocol WeightCalculatable {
//  associatedtype WeightType
//  var weight: WeightType { get }
//}

class Truck: WeightCalculatable {
  // This heavy thing only needs integer accuracy
  typealias WeightType = Int

  var weight: Int {
    100
  }
}

class Flower: WeightCalculatable {
  // This light thing needs decimal places
  typealias WeightType = Double

  var weight: Double {
    0.0025
  }
}

//class StringWeightThing: WeightCalculatable {
//  typealias WeightType = String
//
//  var weight: String {
//    "That doesn't make sense"
//  }
//}

//class CatWeightThing: WeightCalculatable {
//  typealias WeightType = Cat
//
//  var weight: Cat {
//    Cat(name: "What is this cat doing here?")
//  }
//}

protocol WeightCalculatable {
  associatedtype WeightType: Numeric
  var weight: WeightType { get }
}

//protocol Product {}
//
//protocol ProductionLine  {
//  func produce() -> Product
//}
//
//protocol Factory {
//  var productionLines: [ProductionLine] {get}
//}
//
//extension Factory {
//  func produce() -> [Product] {
//    var items: [Product] = []
//    productionLines.forEach { items.append($0.produce()) }
//    print("Finished Production")
//    print("-------------------")
//    return items
//  }
//}
//


struct Car: Product {
  init() {
    print("Producing one awesome Car 🚔")
  }
}
//
//struct CarProductionLine: ProductionLine {
//  func produce() -> Product {
//    Car()
//  }
//}
//
//struct CarFactory: Factory {
//  var productionLines: [ProductionLine] = []
//}
//
//var carFactory = CarFactory()
//carFactory.productionLines = [CarProductionLine(), CarProductionLine()]
//carFactory.produce()
//
//struct Chocolate: Product {
//  init() {
//    print("Producing one chocolate bar 🍫")
//  }
//}
//
//struct ChocolateProductionLine: ProductionLine {
//  func produce() -> Product {
//    Chocolate()
//  }
//}

//var oddCarFactory = CarFactory()
//oddCarFactory.productionLines = [CarProductionLine(), ChocolateProductionLine()]
//oddCarFactory.produce()

protocol Product {
  init()
}

protocol ProductionLine {
  associatedtype ProductType
  func produce() -> ProductType
}

protocol Factory {
  associatedtype ProductType
  func produce() -> [ProductType]
}

struct GenericProductionLine<P: Product>: ProductionLine {
  func produce() -> P {
    P()
  }
}

struct GenericFactory<P: Product>: Factory {
  var productionLines: [GenericProductionLine<P>] = []

  func produce() -> [P] {
    var newItems: [P] = []
    productionLines.forEach { newItems.append($0.produce()) }
    print("Finished Production")
    print("-------------------")
    return newItems
  }
}

var carFactory = GenericFactory<Car>()
carFactory.productionLines = [GenericProductionLine<Car>(), GenericProductionLine<Car>()]
carFactory.produce()

// MARK: -

let array = Array(1...10)
let set = Set(1...10)
let reversedArray = array.reversed()

for e in reversedArray {
 print(e)
}

let arrayCollections = [array, Array(set), Array(reversedArray)]

let collections = [AnyCollection(array),
                   AnyCollection(set),
                   AnyCollection(array.reversed())]

let total = collections.flatMap { $0 }.reduce(0, +) // 165

protocol Pet {
  associatedtype Food
  func eat(_ food: Food)
}

enum PetFood { case dry, wet }

struct Cat: Pet {
  func eat(_ food: PetFood) {
    print("Eating cat food.")
  }
}

struct Dog: Pet {
  func eat(_ food: PetFood) {
    print("Eating dog food.")
  }
}

//let pets: [Pet] = [Dog(), Cat()] // ERROR: Pet can only be used as a generic constraint

struct AnyPet<Food>: Pet {
  private let _eat: (Food) -> Void

  init<SomePet: Pet>(_ pet: SomePet) where SomePet.Food == Food {
    _eat = pet.eat(_:)
  }

  func eat(_ food: Food) {
    _eat(food)
  }
}

let pets = [AnyPet(Dog()), AnyPet(Cat())]

extension Pet {
  func eraseToAnyPet() -> AnyPet<Food> {
    .init(self)
  }
}

let morePets = [Dog().eraseToAnyPet(),
            Cat().eraseToAnyPet()]

func makeValue() -> some FixedWidthInteger {
  42
}

print("Two makeVales summed", makeValue() + makeValue())

func makeValueRandomly() -> some FixedWidthInteger {
  if Bool.random() {
    return Int(42)
  }
  else {
    // return Int8(24) // Compiler error.  All paths must return same type.
    return Int(24)
  }
}

// let v: FixedWidthInteger = 42 // compiler error
let v = makeValue() // works

func makeEquatableNumericInt() -> some Numeric & Equatable { 1 }
func makeEquatableNumericDouble() -> some Numeric & Equatable { 1.0 }

let value1 = makeEquatableNumericInt()
let value2 = makeEquatableNumericInt()

print(value1 == value2) // prints true
print(value1 + value2) // prints 2
// print(value1 > value2) // error

// Compiler error, types don't match up
// makeEquatableNumericInt() == makeEquatableNumericDouble()
