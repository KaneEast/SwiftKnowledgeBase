//
//  Generics.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import Foundation

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

func swapped<T, U>(_ x: T, _ y: U) -> (U, T) {
  (y, x)
}
