/*:
 Triangular number https://en.wikipedia.org/wiki/Triangular_number
 フィボナッチ https://en.wikipedia.org/wiki/Fibonacci_sequence
 */


// COMPARISON OPERATORS
//let yes: Bool = true
//let no: Bool = false
let yes = true
let no = false

let doesOneEqualTwo = (1 == 2)
let doesOneNotEqualTwo = (1 != 2)
let alsoTrue = !(1 == 2)
let isOneGreaterThanTwo = (1 > 2)
let isOneLessThanTwo = (1 < 2)

let and = true && true
let or = true || false

let andTrue = 1 < 2 && 4 > 3
let andFalse = 1 < 2 && 3 > 4

let orTrue = 1 < 2 || 3 > 4
let orFalse = 1 == 2 || 3 == 4

let andOr = (1 < 2 && 3 > 4) || 1 < 4

let guess = "dog"
let dogEqualsCat = guess == "cat"

let order = "cat" < "dog"

var switchState = true
switchState.toggle()
switchState.toggle()

// IF-STATEMENTS
if 2 > 1 {
  print("Yes, 2 is greater than 1.")
}

let hourOfDay = 12
var timeOfDay = ""

if hourOfDay < 6 {
  timeOfDay = "Early morning"
} else if hourOfDay < 12 {
  timeOfDay = "Morning"
} else {
  timeOfDay = "INVALID HOUR!"
}
print(timeOfDay)

let name = "Matt Galloway"

if 1 > 2 && name == "Matt Galloway" {
  // ...
}

if 1 < 2 || name == "Matt Galloway" {
  // ...
}


// SCOPE
var hoursWorked = 45

var price = 0
if hoursWorked > 40 {
  let hoursOver40 = hoursWorked - 40
  price += hoursOver40 * 50
  hoursWorked -= hoursOver40
}
price += hoursWorked * 25

print(price)
//print(hoursOver40)


// TERNARY OPERATOR
let a = 5
let b = 10

let min = a < b ? a : b
let max = a > b ? a : b


// WHILE LOOPS
// while true {} // Commented out as this will loop forever

// Made up sequence (it's powers of 2 minus 1, i.e. 3, 7, 15, 31, 63, etc)
var sum = 1
while sum < 1000 {
  sum = sum + (sum + 1)
}
sum

sum = 1
repeat {
  sum = sum + (sum + 1)
} while sum < 1000
sum

sum = 1
while sum < 1 {
  sum = sum + (sum + 1)
}
sum

sum = 1
repeat {
  sum = sum + (sum + 1)
} while sum < 1
sum

sum = 1
while true {
  sum = sum + (sum + 1)
  if sum >= 1000 {
    break
  }
}
sum
