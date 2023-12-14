//: ## Chapter 12: Methods
var numbers = [1, 2, 3]
numbers.removeLast()
numbers

let months = ["January", "February", "March",
              "April", "May", "June",
              "July", "August", "September",
              "October", "November", "December"]

struct SimpleDate {
  var month = "January"
  var day = 1
  
  func monthsUntilWinterBreak() -> Int {
    months.firstIndex(of: "December")! - months.firstIndex(of: month)!
  }
  
  mutating func advance() {
    day += 1
  }
}

extension SimpleDate {
  init(month: Int, day: Int) {
    self.month = months[month-1]
    self.day = day
  }
}

let date = SimpleDate()
date.month
date.monthsUntilWinterBreak()

let valentinesDay = SimpleDate(month: "February", day: 14)
valentinesDay.month // February
valentinesDay.day // 14

let octoberFirst = SimpleDate(month: "October")
octoberFirst.month // October
octoberFirst.day // 1

let januaryTwentySecond = SimpleDate(day: 22)
januaryTwentySecond.month // January
januaryTwentySecond.day // 22

let halloween = SimpleDate(month: 10, day: 31)
halloween.month // October
halloween.day // 31

struct Math {
  static func factorial(of number: Int) -> Int {
    (1...number).reduce(1, *)
  }
}

Math.factorial(of: 6)

extension Math {
  static func primeFactors(of value: Int) -> [Int] {
    var remainingValue = value
    var testFactor = 2
    var primes: [Int] = []
    while testFactor * testFactor <= remainingValue {
      if remainingValue % testFactor == 0 {
        primes.append(testFactor)
        remainingValue /= testFactor
      }
      else {
        testFactor += 1
      }
    }
    if remainingValue > 1 {
      primes.append(remainingValue)
    }
    return primes
  }
}

Math.primeFactors(of: 81)
