
//: ![pubbot](pubbot.png)

enum Direction {
  case left, right, forward
}

enum PugBotError: Error {
  case invalidMove(found: Direction, expected: Direction)
  case endOfPath
}

class PugBot {
  let name: String
  let correctPath: [Direction]
  private var currentStepInPath = 0
    
  init(name: String, correctPath: [Direction]) {
    self.correctPath = correctPath
    self.name = name
  }
    
  func move(_ direction: Direction) throws {
    guard currentStepInPath < correctPath.count else {
      throw PugBotError.endOfPath
    }
    let nextDirection = correctPath[currentStepInPath]
    guard nextDirection == direction else {
      throw PugBotError.invalidMove(found: direction, expected: nextDirection)
    }
    currentStepInPath += 1
  }
  
  func reset() {
    currentStepInPath = 0
  }
}

let pug = PugBot(name: "Pug", correctPath: [.forward, .left, .forward, .right])

func goHome() throws {
  try pug.move(.forward)
  try pug.move(.left)
  try pug.move(.forward)
  try pug.move(.right)
}

do {
  try goHome()
} catch {
  print("PugBot failed to get home.")
}

func moveSafely(_ movement: () throws -> ()) -> String {
  do {
    try movement()
    return "Completed operation successfully."
  } catch PugBotError.invalidMove(let found, let expected) {
    return "The PugBot was supposed to move \(expected), but moved \(found) instead."
  } catch PugBotError.endOfPath {
    return "The PugBot tried to move past the end of the path."
  } catch {
    return "An unknown error occurred."
  }
}

pug.reset()
moveSafely(goHome)

pug.reset()
moveSafely {
  try pug.move(.forward)
  try pug.move(.left)
  try pug.move(.forward)
  try pug.move(.right)
}

//: 重新抛出\
//: 以抛出闭包作为参数的函数必须选择：要么捕获每个错误，要么成为抛出函数。
func perform(times: Int, movement: () throws -> ()) rethrows {
  for _ in 1...times {
    try movement()
  }
}


try? perform(times: 5) {
  try pug.move(.forward)
}

// Swift 可能很聪明，如果你向它传递一个不会抛出异常的闭包，那么该实例中的perform调用就不会被视为可抛出异常。
perform(times: 5) {
  pug.reset()
}
