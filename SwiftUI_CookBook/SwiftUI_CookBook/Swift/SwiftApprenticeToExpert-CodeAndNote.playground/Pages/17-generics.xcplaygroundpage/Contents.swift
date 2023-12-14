// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics

/*:
 ```
 class Keeper<Animal> {}

 func swapped<T, U>(_ x: T, _ y: U) -> (U, T) {
   (y, x)
 }

 swapped(33, "Jay")  // returns ("Jay", 33)

 // 型制約のあるジェネリックス
 class Keeper<Animal: Pet> {
    /* definition body as before */
 }

 
 func callForDinner<Animal: Pet>(_ pet: Animal) {
    print("Here \(pet.name)-\(pet.name)! Dinner time!")
 }

 // この汎用関数は以前のバージョンと同じものを表現します。
 // このスタイルは、山かっこを使用しない方が読みやすく、制約をより直接的に示すため、推奨されます。
 func callForDinner(_ pet: some Pet) {
   print("Here \(pet.name)-\(pet.name)! Dinner time!")
 }

 
 func callForDinner<Animal>(_ pet: Animal) where Animal: Pet {
   print("Here \(pet.name)-\(pet.name)! Dinner time!")
 }

 extension Array where Element: Cat {
   func meow() {
     forEach { print("\($0.name) says meow!") }
   }
 }

 
 let lost: [any Pet] = [Cat(name: "Whiskers"), Dog(name: "Hachiko")]

 ```
 */


import Foundation

// try 0: values driving values
enum PetKind {
  case cat
  case dog
}

struct KeeperKind {
  var keeperOf: PetKind
}

let catKeeper = KeeperKind(keeperOf: .cat)
let dogKeeper = KeeperKind(keeperOf: .dog)

// types driving types

/* try 1: manually mirrored types
class Cat {}
class Dog {}

class KeeperForCats {}
class KeeperForDogs {}
*/

/* try 2: generics to establish type relationship
class Cat {}
class Dog {}

class Keeper<Animal> {}

var aCatKeeper = Keeper<Cat>()
//var aKeeper = Keeper()  // compile-time error!
*/

/* try 3: add identity. now we have collections
*/
protocol Pet {
  var name: String { get }  // all pets respond to a name
}

class Cat {
  var name: String
  
  init(name: String) {
    self.name = name
  }
}

class Dog {
  var name: String
  
  init(name: String) {
    self.name = name
  }
}

extension Cat: Pet {}
extension Dog: Pet {}

class Keeper<Animal: Pet> {
  var name: String
  var morningCare: Animal
  var afternoonCare: Animal
  
  init(name: String, morningCare: Animal, afternoonCare: Animal) {
    self.name = name
    self.morningCare = morningCare
    self.afternoonCare = afternoonCare
  }
}

let jason = Keeper(name: "Jason", morningCare: Cat(name: "Whiskers"), afternoonCare: Cat(name: "Sleepy"))

// with a generic where clause:
// a type extension is restricted by a constraint on the type parameter
extension Array where Element: Cat {
  func meow() {
    forEach { print("\($0.name) says meow!") }
  }
}

// with a generic where clause:
// a type extension adopts a protocol on the condition the type parameter does
protocol Meowable {
  func meow()
}

extension Cat: Meowable {
  func meow() {
    print("\(self.name) says meow!")
  }
}

extension Array: Meowable where Element: Meowable {
  func meow() {
    forEach { $0.meow() }
  }
}

let animalAges: Array<Int> = [2,5,7,9]

let intNames: Dictionary<Int, String> = [42: "forty-two"]
let intNames2: [Int: String] = [42: "forty-two", 7: "seven"]
let intNames3 = [42: "forty-two", 7: "seven"]

enum OptionalDate {
  case none
  case some(Date)
}

enum OptionalString {
  case none
  case some(String)
}

struct FormResults {
  // other properties here
  var birthday: OptionalDate
  var lastName: OptionalString
}

// Keep this commented out so we can keep using Swift's Optional type, not our own.
//enum Optional<Wrapped> {
//  case none
//  case some(Wrapped)
//}

var birthdate: Optional<Date> = .none
if birthdate == .none {
  // no birthdate
}

var birthdate2: Date? = nil
if birthdate2 == nil {
  // no birthdate
}

func swapped<T, U>(_ x: T, _ y: U) -> (U, T) {
  (y, x)
}

swapped(33, "Jay")  // returns ("Jay", 33)
