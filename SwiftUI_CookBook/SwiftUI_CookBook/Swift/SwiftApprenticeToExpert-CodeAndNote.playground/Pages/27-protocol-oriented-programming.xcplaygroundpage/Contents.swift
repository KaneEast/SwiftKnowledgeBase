
/*:
 Apple 宣布 Swift 是第一个面向协议的编程语言。该声明是通过引入协议扩展而成为可能的。
 尽管协议从一开始就存在于 Swift 中，但 Apple 的声明和协议密集型标准库的更改会影响您对类型的看法。扩展协议是全新编程风格的关键！
 简而言之，面向协议的编程强调对协议进行编码，而不是对特定的类、结构或枚举进行编码。它通过打破旧的协议规则并允许您在协议本身上编写协议的实现来实现这一点。
 本章向您介绍协议扩展和面向协议编程的强大功能。在此过程中，您将学习如何使用默认实现、类型约束、混合和特征来极大地简化您的代码。
 
 
 
 */


// Introducing Protocol Extensions
extension String {
  func shout() {
    print(uppercased())
  }
}

"Swift is pretty cool".shout()

protocol TeamRecord {
  var wins: Int { get }
  var losses: Int { get }
  var winningPercentage: Double { get }
}

extension TeamRecord {
  var gamesPlayed: Int {
    wins + losses
  }
}

struct BaseballRecord: TeamRecord {
  var wins: Int
  var losses: Int

  var winningPercentage: Double {
    Double(wins) / Double(wins + losses)
  }
}

let sanFranciscoSwifts = BaseballRecord(wins: 10, losses: 5)
sanFranciscoSwifts.gamesPlayed

// Default Implementations

// Before protocol extension
/*
struct BasketballRecord: TeamRecord {
  var wins: Int
  var losses: Int
  let seasonLength = 82

  var winningPercentage: Double {
    Double(wins) / Double(wins + losses)
  }
}
*/

extension TeamRecord {
  var winningPercentage: Double {
    Double(wins) / Double(wins + losses)
  }
}

struct BasketballRecord: TeamRecord {
  var wins: Int
  var losses: Int
  let seasonLength = 82
}

let minneapolisFunctors = BasketballRecord(wins: 60, losses: 22)
minneapolisFunctors.winningPercentage

struct HockeyRecord: TeamRecord {
  var wins: Int
  var losses: Int
  var ties: Int

  // Hockey record introduces ties, and has
  // its own implementation of winningPercentage
  var winningPercentage: Double {
    Double(wins) / Double(wins + losses + ties)
  }
}

// Works with or without ties
let chicagoOptionals = BasketballRecord(wins: 10, losses: 6)
let phoenixStridables = HockeyRecord(wins: 8, losses: 7, ties: 1)

chicagoOptionals.winningPercentage
phoenixStridables.winningPercentage

// Protocol Extension Dispatching
protocol WinLoss {
  var wins: Int { get }
  var losses: Int { get }
}

extension WinLoss {
  var winningPercentage: Double {
    Double(wins) / Double(wins + losses)
  }
}

struct CricketRecord: WinLoss {
  var wins: Int
  var losses: Int
  var draws: Int

  var winningPercentage: Double {
    Double(wins) / Double(wins + losses + draws)
  }
}

let miamiTuples = CricketRecord(wins: 8, losses: 7, draws: 1)
let winLoss: WinLoss = miamiTuples

miamiTuples.winningPercentage
winLoss.winningPercentage

// Type Constraints
protocol PostSeasonEligible {
  var minimumWinsForPlayoffs: Int { get }
}

extension TeamRecord where Self: PostSeasonEligible {
  var isPlayoffEligible: Bool {
    wins > minimumWinsForPlayoffs
  }
}

protocol Tieable {
  var ties: Int { get }
}

extension TeamRecord where Self: Tieable {
  var winningPercentage: Double {
    Double(wins) / Double(wins + losses + ties)
  }
}

struct RugbyRecord: TeamRecord, Tieable {
  var wins: Int
  var losses: Int
  var ties: Int
}

let rugbyRecord = RugbyRecord(wins: 8, losses: 7, ties: 1)
rugbyRecord.winningPercentage

// Protocol Oriented Benefits
class TeamRecordBase {
  var wins = 0
  var losses = 0

  var winningPercentage: Double {
    Double(wins) / Double(wins + losses)
  }
}

// Will not compile: inheritance is only possible with classes.
/*
struct BaseballRecord: TeamRecordBase {}
*/

// Inefficent Class Implementation
/*
class HockeyRecord: TeamRecordBase {
  var ties = 0

  override var winningPercentage: Double {
    Double(wins) / Double(wins + losses + ties)
  }
}
 
class TieableRecordBase: TeamRecordBase {
  var ties = 0
 
  override var winningPercentage: Double {
    Double(wins) / Double(wins + losses + ties)
   }
}
 
class HockeyRecord: TieableRecordBase {}
 
class CricketRecord: TieableRecordBase {}
 
extension TieableRecordBase {
  var totalPoints: Int {
    (2 * wins) + (1 * ties)
  }
}
*/

// Traits, mixins, and multiple inheritance
protocol TieableRecord {
  var ties: Int { get }
}

protocol DivisionalRecord {
  var divisionalWins: Int { get }
  var divisionalLosses: Int { get }
}

protocol ScoreableRecord {
  var totalPoints: Int { get }
}

extension ScoreableRecord where Self: TieableRecord, Self: TeamRecord {
  var totalPoints: Int {
    (2 * wins) + (1 * ties)
  }
}

struct NewHockeyRecord: TeamRecord, TieableRecord, DivisionalRecord, CustomStringConvertible, Equatable {
  var wins: Int
  var losses: Int
  var ties: Int
  var divisionalWins: Int
  var divisionalLosses: Int

  var description: String {
    "\(wins) - \(losses) - \(ties)"
  }
}


/*:
 ## 为什么 Swift 是一种面向协议的语言
 您已经了解了协议和协议扩展的功能，但您可能想知道：Swift 是面向协议的语言到底意味着什么？
 协议扩展会极大地影响您编写富有表现力和解耦代码的能力 - 并且 Swift 标准库广泛使用协议扩展。
 首先，您可以将面向协议的编程与面向对象的编程进行对比。后者重点关注可变对象的概念以及对象如何交互。因此，类是任何面向对象语言的中心。
 尽管类是 Swift 的一部分，但您会发现它们只是标准库的一小部分。相反，Swift 标准库是符合协议的值类型（或具有值语义的类型）。您可以看到许多 Swift 核心类型的重要性，例如Int和Array。
 
 
 注意：更中立的 Swift 开发人员将 Swift 称为“多范式”语言。您已经了解了继承、面向对象技术和面向协议编程；Swift 可以轻松处理所有这些！
 
 协议和面向协议的编程是 Swift 语言的基础。例如，泛型系统使用协议来精确指定所使用的泛型类型的类型要求。如果您有m 个数据结构和n 个对这些数据结构进行操作的算法，则在某些语言中，您需要m * n代码块来实现它们。使用 Swift，使用协议，您只需要编写m + n块，无需重复。面向协议的编程为您提供了面向对象编程的所有优点，同时避免了大多数陷阱。
 
 下次面对编程任务时，请从值类型开始。看看您是否能找出跨类型的共同元素。这些成为协议的候选者，并且通常与所关注的问题领域密切相关。以这种方式思考可能会导致您获得更灵活和可扩展的解决方案。就像 Neo 可以在《黑客帝国》中看到红色连衣裙一样，你越养成这个习惯，就越容易看到协议抽象。
 
 关键点
 协议扩展允许您编写协议的实现代码，甚至可以编写协议所需方法的默认实现。
 协议扩展是面向协议编程的主要驱动程序，使您可以编写适用于符合协议的任何类型的代码。
 正式协议声明的接口部分是采用类型可以覆盖的定制点。
 协议扩展的类型约束提供了额外的上下文，让您可以编写更专门的实现。
 您可以使用特征和混合来装饰类型来扩展行为，而无需继承。
 如果使用得当，协议可以促进代码重用和封装。
 从值类型开始并找到基本协议。
 */
