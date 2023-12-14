// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety

/*:
 弱引用 Safe
 
 弱引用是在对象的所有权中不发挥任何作用的引用。使用它们的好处是它们可以自动检测底层对象何时消失。这种自动检测就是您始终使用可选类型声明它们的原因。nil一旦被引用对象的引用计数达到零，它们就会变成零。
 
 教程并不总是分配一个编辑，因此将其建模为可选类型是有意义的。
 
 无主引用 Danger
 
 还有另一种打破引用循环的方法：无主引用。它们的行为类似于弱函数，因为它们不会更改对象的引用计数。
 然而，与弱引用不同，它们总是期望有一个值——你不能将它们声明为可选。
 
 可以这样想：没有作者，教程就不可能存在。
 
 
 !!!
 A word of caution is in order here: Be aware that using unowned comes with some danger. It’s the same danger you get from implicitly unwrapped optionals or using try!. That is, if the unowned property references an object that gets deallocated, then any access to that property will result in a crash of the program. So, use these only when you are sure the object will be alive.
 Using a weak property is always safer, and all you have to do is safely unwrap the optional to account for the object potentially being nil. The reason to use unowned is when you are sure you want to trade the safety for the ease of not needing to unwrap an optional.
 
 
 ## 带有闭包的引用循环
 
 请记住，在处理对象时，“常量”对于引用类型具有不同的含义。捕获列表将导致闭包捕获并存储存储在捕获变量内的当前引用（具有引用类型）。通过此引用对对象所做的更改将在闭包外部保持可见。
 */

class Tutorial {
  let title: String
  unowned let author: Author
  weak var editor: Editor?
  
  init(title: String, author: Author) {
    self.title = title
    self.author = author
  }
  
  deinit {
    print("Goodbye tutorial \(title)!")
  }
  
  /*
  lazy var description: () -> String = {
    [unowned self] in
    "\(self.title) by \(self.author.name)"
  }
  
  lazy var description: () -> String = {
    [weak self] in
    "\(self?.title) by \(self?.author.name)"
  }
  */
  
  lazy var description: () -> String = {
    [weak self] in
    guard let self = self else {
      return "The tutorial is no longer available."
    }
    return "\(self.title) by \(self.author.name)"
  }
}

class Editor {
  let name: String
  var tutorials: [Tutorial] = []
  
  init(name: String) {
    self.name = name
  }
  
  deinit {
    print("Goodbye editor \(name)!")
  }
}

class Author {
  let name: String
  var tutorials: [Tutorial] = []
  
  init(name: String) {
    self.name = name
  }
  
  deinit {
    print("Goodbye author \(name)!")
  }
}

do {
  let author = Author(name: "Cosmin")
  let tutorial = Tutorial(title: "Memory management", author: author)
  print(tutorial.description())
  let editor = Editor(name: "Ray")
  author.tutorials.append(tutorial)
  tutorial.editor = editor
  editor.tutorials.append(tutorial)
}

final class FunctionKeeper {
  private let function: () -> Void
  
  init(function: @escaping () -> Void) {
    self.function = function
  }
  
  func run() {
    function()
  }
}

let name = "Cosmin"
let f = FunctionKeeper {
  print("Hello, \(name)")
}
f.run()

var counter = 0
var g = {print(counter)}
counter = 1
g()

counter = 0
g = {[c = counter] in print(c)}
counter = 1
g()

counter = 0
g = {[counter] in print(counter)}
counter = 1
g()

let tutorialDescription: () -> String
do {
  let author = Author(name: "Cosmin")
  let tutorial = Tutorial(title: "Memory management", author: author)
  tutorialDescription = tutorial.description
}
print(tutorialDescription())



struct Calculator {
  let values: [Int]

  init(values: [Int]) {
    self.values = values
  }

  func add() -> Int {
    return values.reduce(into: 0) { $0 += $1 }
  }

  func multiply() -> Int {
    return values.reduce(into: 1) { $0 *= $1 }
  }

  func calculate() {
    let closure = {
      let add = add()
      print("Values added = \(add)")
      let multiply = multiply()
      print("Values multiplied = \(multiply)")
    }
    closure()
  }
}

/*:
 This code is the same as the previous example, except class changed to struct. The version with class failed to compile. However, the version with struct does compile. This difference is because Calculator is now a value type, and there’s no chance of a retain cycle in this scenario. Clever! :]
 There’s no chance of a retain cycle in this example with a struct because you can’t have references to structs. Instead, if a struct is passed between two places — for example, set to a new variable or passed to a function — then a copy of the struct is taken. There are no references, so there can’t be any retain cycles.
 
 
 
 Key Points
 Use a weak reference to break a strong reference cycle if a reference may become nil at some point in its lifecycle.
 Use an unowned reference to break a strong reference cycle when you know a reference always has a value and will never be nil.
 You must use self inside a closure’s body of a reference type. This requirement is a way the Swift compiler hints that you need to be careful not to make a circular reference.
 Capture lists define how you capture values and references in closures.
 The weak-strong pattern converts a weak reference to a strong one.
 An escaping closure is a closure parameter that can be stored and called after the function returns. You should consider the capture list of escaping closures carefully because their lifetimes can be arbitrarily extended.
 */





