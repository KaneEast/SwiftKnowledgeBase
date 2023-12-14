// RANGES
let closedRange = 0...5
let halfOpenRange = 0..<5

while Int.random(in: 1...6) != 6 {
  print("Not a six")
}

// FOR LOOPS
let count = 10
// Triangle numbers
var sum = 0
for i in 1...count {
  sum += i
}
sum

// Fibonacci
sum = 1
var lastSum = 0
for _ in 0..<count {
  let temp = sum
  sum = sum + lastSum
  lastSum = temp
}
sum

// Sum odd numbers
sum = 0
for i in 1...count where i % 2 == 1 {
  sum += i
}
sum

// Chess board iteration
sum = 0
for row in 0..<8 {
  if row % 2 == 0 {
    continue
  }
  
  for column in 0..<8 {
    sum += row * column
  }
}
sum

sum = 0
rowLoop: for row in 0..<8 {
  columnLoop: for column in 0..<8 {
    if row == column {
      continue rowLoop
    }
    sum += row * column
  }
}
sum


// SWITCH STATEMENTS
let number = 10

switch number {
case 0:
  print("Zero")
default:
  print("Non-zero")
}

switch number {
case 10:
  print("It's ten!")
default:
  break
}

let string = "Dog"
switch string {
case "Cat", "Dog":
  print("Animal is a house pet.")
default:
  print("Animal is not a house pet.")
}

let hourOfDay = 12
var timeOfDay = ""

switch hourOfDay {
case 0...5:
  timeOfDay = "Early morning"
case 6...11:
  timeOfDay = "Morning"
case 12...16:
  timeOfDay = "Afternoon"
case 17...19:
  timeOfDay = "Evening"
case 20..<24:
  timeOfDay = "Late evening"
default:
  timeOfDay = "INVALID HOUR!"
}
print(timeOfDay)

switch number {
case let x where x % 2 == 0:
  print("Even")
default:
  print("Odd")
}

switch number {
case _ where number % 2 == 0:
  print("Even")
default:
  print("Odd")
}

let coordinates = (x: 3, y: 2, z: 5)

switch coordinates {
case (0, 0, 0):
  print("Origin")
case (_, 0, 0):
  print("On the x-axis.")
case (0, _, 0):
  print("On the y-axis.")
case (0, 0, _):
  print("On the z-axis.")
default:
  print("Somewhere in space")
}

switch coordinates {
case (0, 0, 0):
  print("Origin")
case (let x, 0, 0):
  print("On the x-axis at x = \(x)")
case (0, let y, 0):
  print("On the y-axis at y = \(y)")
case (0, 0, let z):
  print("On the z-axis at z = \(z)")
case let (x, y, z):
  print("Somewhere in space at x = \(x), y = \(y), z = \(z)")
}

switch coordinates {
case let (x, y, _) where y == x:
  print("Along the y = x line.")
case let (x, y, _) where y == x * x:
  print("Along the y = x^2 line.")
default:
  break
}
