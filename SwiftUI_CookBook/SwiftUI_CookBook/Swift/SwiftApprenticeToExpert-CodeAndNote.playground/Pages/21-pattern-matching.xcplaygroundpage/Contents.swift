/*：
 TODO: Survey
 Pattern Matching and Dictionary in Swift Algorithm Hacking
 */

import Foundation

let coordinate = (x: 1, y: 0, z: 0)

if (coordinate.y == 0) && (coordinate.z == 0) {
  print("along the x-axis")
}
if case (_, 0, 0) = coordinate {
  print("along the x-axis")
}

//func process(point: (x: Int, y: Int, z: Int)) -> String {
//  if case (0, 0, 0) = point {
//    return "At origin"
//  }
//  return "Not at origin"
//}
//let point = (x: 0, y: 0, z: 0)
//let status = process(point: point) // At origin

func process(point: (x: Int, y: Int, z: Int)) -> String {
  // 1
  let closeRange = -2...2
  let midRange = -5...5
  // 2
  switch point {
  case (0, 0, 0):
    return "At origin"
  case (closeRange, closeRange, closeRange):
    return "Very close to origin"
  case (midRange, midRange, midRange):
    return "Nearby origin"
default:
    return "Not near origin"
  }
}

let point = (x: 15, y: 5, z: 3)
let status = process(point: point) // Not near origin

// 模式匹配可以充当过滤器
let groupSizes = [1, 5, 4, 6, 2, 1, 3]
for case 1 in groupSizes {
  print("Found an individual") // 2 times
}

if case (let x, 0, 0) = coordinate {
 print("On the x-axis at \(x)") // Printed: 1
}

if case let (x, y, 0) = coordinate {
 print("On the x-y plane at (\(x), \(y))") // Printed: 1, 0
}

enum Direction {
  case north, south, east, west
}
let heading = Direction.north
if case .north = heading {
  print("Don’t forget your jacket") // Printed!
}

enum Organism {
  case plant
  case animal(legs: Int)
}
let pet = Organism.animal(legs: 4)
switch pet {
case .animal(let legs):
  print("Potentially cuddly with \(legs) legs") // Printed: 4
default:
  print("No chance for cuddles")
}

let names: [String?] = ["Michelle", nil, "Brandon", "Christine", nil, "David"]


for case let name? in names {
 print(name) // 4 times
}

let response: [Any] = [15, "George", 2.0]
for element in response {
 switch element {
 case is String:
   print("Found a string") // 1 time
 default:
    print("Found something else") // 2 times
 }
}

for element in response {
 switch element {
 case let text as String:
   print("Found a string: \(text)") // 1 time
 default:
   print("Found something else") // 2 times
 }
}

for number in 1...9 {
  switch number {
  case let x where x % 2 == 0:
    print("even") // 4 times
  default:
    print("odd") // 5 times
 }
}

enum LevelStatus {
  case complete
  case inProgress(percent: Double)
  case notStarted
}
let levels: [LevelStatus] =
  [.complete, .inProgress(percent: 0.9), .notStarted]
for level in levels {
  switch level {
  case .inProgress(let percent) where percent > 0.8 :
    print("Almost there!")
  case .inProgress(let percent) where percent > 0.5 :
    print("Halfway there!")
  case .inProgress(let percent) where percent > 0.2 :
    print("Made it through the beginning!")
  default:
    break
  }
}

func timeOfDayDescription(hour: Int) -> String {
  switch hour {
  case 0, 1, 2, 3, 4, 5:
    return "Early morning"
  case 6, 7, 8, 9, 10, 11:
    return "Morning"
  case 12, 13, 14, 15, 16:
    return "Afternoon"
  case 17, 18, 19:
    return "Evening"
case 20, 21, 22, 23:
    return "Late evening"
default:
    return "INVALID HOUR!"
  }
}
let timeOfDay = timeOfDayDescription(hour: 12) // Afternoon

if case .animal(let legs) = pet, case 2...4 = legs {
  print("potentially cuddly") // Printed!
} else {
  print("no chance for cuddles")
}

enum Number {
  case integerValue(Int)
  case doubleValue(Double)
  case booleanValue(Bool)
}

let a = 5
let b = 6
let c: Number? = .integerValue(7)
let d: Number? = .integerValue(8)

if a != b {
  if let c = c {
    if let d = d {
      if case .integerValue(let cValue) = c {
        if case .integerValue(let dValue) = d {
          if dValue > cValue {
            print("a and b are different") // Printed!
            print("d is greater than c") // Printed!
            print("sum: \(a + b + cValue + dValue)") // 26
          }
        }
      }
    }
  }
}

if a != b,
   let c = c,
   let d = d,
   case .integerValue(let cValue) = c,
   case .integerValue(let dValue) = d,
   dValue > cValue {
  print("a and b are different") // Printed!
  print("d is greater than c") // Printed!
  print("sum: \(a + b + cValue + dValue)") // Printed: 26
}

let name = "Bob"
let age = 23
if case ("Bob", 23) = (name, age) {
  print("Found the right Bob!") // Printed!
}

var username: String?
var password: String?
switch (username, password) {
case let (username?, password?):
  print("Success! User: \(username) Pass: \(password)")
case let (username?, nil):
  print("Password is missing. User: \(username)")
case let (nil, password?):
  print("Username is missing. Pass: \(password)")
case (nil, nil):
  print("Both username and password are missing")  // Printed!
}

for _ in 1...3 {
 print("hi") // 3 times
}

let user: String? = "Bob"
guard let _ = user else {
  print("There is no user.")
  fatalError()
}
print("User exists, but identity not needed.") // Printed!

guard user != nil else {
  print("There is no user.")
  fatalError()
}

struct Rectangle {
  let width: Int
  let height: Int
  let background: String
}
let view = Rectangle(width: 15, height: 60, background: "Green")
switch view {
case _ where view.height < 50:
  print("Shorter than 50 units")
case _ where view.width > 20:
  print("Over 50 tall, & over 20 wide")
case _ where view.background == "Green":
  print("Over 50 tall, at most 20 wide, & green") // Printed!
default:
  print("This view can’t be described by this example")
}


// 0, 1, 1, 2, 3, 5, 8
func fibonacci(position: Int) -> Int {
  switch position {
  // 如果当前序列位置小于二，该函数将返回0
  case let n where n <= 1:
    return 0
  // 如果当前序列位置等于 2，则该函数将返回1。
  case 2:
    return 1
  // 3
  case let n:
    return fibonacci(position: n - 1) + fibonacci(position: n - 2)
  }
}

let fib15 = fibonacci(position: 15) // 377


// FizzBu​​zz
for i in 1...100 {
  // 1
  switch (i % 3, i % 5) {
  // 2
  case (0, 0):
    print("FizzBuzz", terminator: " ")
  case (0, _):
    print("Fizz", terminator: " ")
  case (_, 0):
    print("Buzz", terminator: " ")
  // 3
  case (_, _):
    print(i, terminator: " ")
  }
}
print("")


// 编译器使用~=运算符来检查整数值是否在某个范围内。
let matched = (1...10 ~= 5) // true

if case 1...10 = 5 {
  print("In the range")
}


// 该函数将一个整数数组作为其pattern参数，并使用一个整数作为其value参数。该函数返回一个Bool.
func ~=(pattern: [Int], value: Int) -> Bool {
  // 该函数将一个整数数组作为其pattern参数，并使用一个整数作为其value参数。该函数返回一个Bool.
  for i in pattern {
    if i == value {
      // 该函数将一个整数数组作为其pattern参数，并使用一个整数作为其value参数。该函数返回一个Bool.
      return true
    }
  }
  // 如果for循环结束时没有任何匹配项，则该函数返回false。
  return false
}


let list = [0, 1, 2, 3]
let integer = 2
let isInArray = (list ~= integer) // true

if case list = integer {
  print("The integer is in the array") // Printed!
} else {
  print("The integer is not in the array")
}


// 挑战一：梳理
// 根据此代码，编写一条if语句，如果用户尚未满 21 岁，则显示错误：
enum FormField {
  case firstName(String)
  case lastName(String)
  case emailAddress(String)
  case age(Int)
}
let minimumAge = 21
let submittedAge = FormField.age(22)


//挑战2：有液态水的行星
//根据此代码，使用循环查找具有液态水的行星for：
enum CelestialBody {
  case star
  case planet(liquidWater: Bool)
  case comet
}

let telescopeCensus = [
  CelestialBody.star,
  .planet(liquidWater: false),
  .planet(liquidWater: true),
  .planet(liquidWater: true),
  .comet
]

//挑战 3：找到年份
//给定此代码，通过循环查找 1974 年发行的专辑for：
let queenAlbums = [
  ("A Night at the Opera", 1974),
  ("Sheer Heart Attack", 1974),
  ("Jazz", 1978),
  ("The Game", 1980)
]

//挑战4：在世界的哪个地方
//给定以下代码，编写一条switch语句，打印出纪念碑是位于北半球、南半球还是赤道上。
let coordinates = (lat: 37.334890, long: -122.009000)


//关键点
//模式代表值的结构。
//模式匹配可以帮助您编写比替代逻辑条件更具可读性的代码。
//模式匹配是从枚举值中提取关联值的唯一方法。
//该~=运算符用于模式匹配，您可以重载它以添加自己的模式匹配。
