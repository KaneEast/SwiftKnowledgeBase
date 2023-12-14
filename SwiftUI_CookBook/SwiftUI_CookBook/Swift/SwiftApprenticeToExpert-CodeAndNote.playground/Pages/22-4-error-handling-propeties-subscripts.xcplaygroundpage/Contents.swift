class Person {
  var name: String
  var age: Int
  
  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
}

enum PersonError: Error {
  case noName, noAge, noData
}

//: 类型可以具有计算属性。有时计算属性可能无法计算\
//: 在这些情况下，您希望能够从 getter 中抛出错误。这只能通过只读计算属性来实现。
extension Person {
  var data: String {
    get throws {
      guard !name.isEmpty else {throw PersonError.noName}
      guard age > 0 else {throw PersonError.noAge}
      return "\(name) is \(age) years old."
    }
  }
}

let me = Person(name: "Cosmin", age: 36)

me.name = ""
do {
  try me.data
} catch {
  print(error)
}

me.age = -36
do {
  try me.data
} catch {
  print(error)
}

me.name = "Cosmin"
do {
  try me.data
} catch {
  print(error)
}

me.age = 36
do {
  try me.data
} catch {
  print(error)
}

extension Person {
  subscript(key: String) -> String {
    get throws {
      switch key {
      case "name": return name
      case "age": return "\(age)"
      default: throw PersonError.noData
      }
    }
  }
}

/*:
 可抛出的下标
 您还可以从只读下标抛出错误。
 
 */
do {
  try me["name"]
} catch {
  print(error)
}

do {
  try me["age"]
} catch {
  print(error)
}

do {
  try me["gender"]
} catch {
  print(error)
}
