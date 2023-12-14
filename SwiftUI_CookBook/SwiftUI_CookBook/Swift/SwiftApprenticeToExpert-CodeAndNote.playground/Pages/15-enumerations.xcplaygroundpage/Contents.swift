
/*:
 ## Associated Values
 
 Associated values take Swift enumerations to the next level in expressive power. They let you associate a custom value (or values) with each enumeration case.\
 
 ## Here are some unique qualities of associated values:
 - Each enumeration case has zero or more associated values.
 - The associated values for each enumeration case have their own data type.
 - You can define associated values with label names as you would for named function parameters.
 ```
 enum WithdrawalResult {
   case success(newBalance: Int)
   case error(message: String)
 }
 ```
 
 オプション
 ```
 var age: Int?
 age = 17
 age = nil
 
 switch age {
 case .none:
   print("No value")
 case .some(let value):
   print("Got a value: \(value)")
 }
 ```
 
 */
//: ## Chapter 15: Enumerations
let months = ["January", "February", "March", "April", "May",
              "June", "July", "August", "September", "October",
              "November", "December"]

func semester(for month: String) -> String {
  switch month {
  case "August", "September", "October", "November", "December":
    return "Autumn"
  case "January", "February", "March", "April", "May":
    return "Spring"
  default:
    return "Not in the school year"
  }
}

semester(for: "April")

enum Month: Int {
  case january = 1, february, march, april, may, june, july, august, september, october, november, december
}

func semester(for month: Month) -> String {
  switch month {
  case .august, .september, .october, .november, .december:
    return "Autumn"
  case .january, .february, .march, .april, .may:
    return "Spring"
  case .june, .july:
    return "Summer"
  }
}

var month = Month.april
semester(for: month)
month = .september
semester(for: month)


func monthsUntilWinterBreak(from month: Month) -> Int {
  Month.december.rawValue - month.rawValue
}
monthsUntilWinterBreak(from: .april)

let fifthMonth = Month(rawValue: 5)!
monthsUntilWinterBreak(from: fifthMonth)

// 1
enum Icon: String {
  case music
  case sports
  case weather
  var filename: String {
    "\(rawValue).png"
  }
}
let icon = Icon.weather
icon.filename

enum Coin: Int {
  case penny = 1
  case nickel = 5
  case dime = 10
  case quarter = 25
}

let coin = Coin.quarter
coin.rawValue

var balance = 100

enum WithdrawalResult {
  case success(newBalance: Int)
  case error(message: String)
}

func withdraw(amount: Int) -> WithdrawalResult {
  if amount <= balance {
    balance -= amount
    return .success(newBalance: balance)
  } else {
    return .error(message: "Not enough money!")
  }
}

let result = withdraw(amount: 99)

switch result {
case .success(let newBalance):
  print("Your new balance is: \(newBalance)")
case .error(let message):
  print(message)
}

enum HTTPMethod {
  case get
  case post(body: String)
}

let request = HTTPMethod.post(body: "Hi there")
guard case .post(let body) = request else {
  fatalError("No message was posted")
}
print(body)

enum TrafficLight {
  case red, yellow, green
}
let trafficLight = TrafficLight.red

// Looping through all cases

enum Pet: CaseIterable {
  case cat, dog, bird, turtle, fish, hamster
}

for pet in Pet.allCases {
  print(pet)
}

enum Math {
  static func factorial(of number: Int) -> Int {
    (1...number).reduce(1, *)
  }
}
let factorial = Math.factorial(of: 6)

// let math = Math() // ERROR: No accessible initializers

var age: Int?
age = 17
age = nil

switch age {
case .none:
  print("No value")
case .some(let value):
  print("Got a value: \(value)")
}

let optionalNil: Int? = .none
optionalNil == nil    // true
optionalNil == .none  // true
