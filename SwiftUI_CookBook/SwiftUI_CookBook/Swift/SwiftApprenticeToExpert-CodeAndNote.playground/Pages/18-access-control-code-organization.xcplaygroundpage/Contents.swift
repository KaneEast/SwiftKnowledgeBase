// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol
// https://swift.org/package-manager

/*:
 ```
 private(set) var balance: Dollars

 ```
 ## modifiers available in Swift:
 
 - private: Accessible only to the defining type, all nested types and extensions on that type within the same source file.
 - `fileprivate`: Accessible from anywhere within the source file in which it’s defined.
 - `internal`: Accessible from anywhere within the module in which it’s defined. This level is the default access level. If you don’t write anything, this is what you get.
 - `public`: Accessible from anywhere that imports the module.
 - `open`: The same as public, with the additional ability granted to override the code in another module.
 
 
 
 将代码组织成扩展
 - 按行为扩展
 - 协议一致性扩展
 
 
 # @available(*, deprecated, message: "Use init(interestRate:pin:) instead")
 
 # some
 
 
 不透明的返回类型
 想象一下，您需要为银行库的用户创建一个公共 API。您必须调用一个函数createAccount来创建并返回新帐户。此 API 的要求之一是隐藏实现细节，以便鼓励客户编写通用代码。这意味着您不应该公开您正在创建的帐户类型，无论是BasicAccount,CheckingAccount还是SavingsAccount。相反，您将返回一些符合协议的实例Account。
 要实现这一点，您必须首先公开该Account协议。打开Account.swiftpublic并在 之前添加修饰符protocol Account。现在返回您的 Playground 并插入以下代码：
 
 // error: Protocol 'Account' can only be used as a generic constraint because it has Self or associated type requirements
 func createAccount() -> Account {
   CheckingAccount()
 }

 // fix
 func createAccount() -> some Account {
   CheckingAccount()
 }

 */


/*:
 # Swift Package Manager
 Another powerful way to organize your code is to use Swift Package Manager, or SwiftPM for short. SwiftPM lets you “package” your module so that you or other developers can easily use it in their code.
 
 For example, a module that implements the logic of downloading images from the web is useful in many projects. Instead of copying & pasting the code to all your projects needing image downloading functionality, you could import and reuse this module.
 
 
 
 */

/*:
 编写测试
 
 The acronym FIRST describes a concise set of criteria for useful unit tests. Those criteria are:
 - Fast: Tests should run quickly.
 - Independent/Isolated: Tests should not share state.
 - Repeatable: You should obtain the same results every time you run a test.
 - Self-validating: Tests should be fully automated, and the output should be either “pass” or “fail”.
 - Timely: Ideally, write tests before writing the code they test (Test-Driven Development).
 
 快速：测试应该快速运行。
 独立/隔离：测试不应共享状态。
 可重复：每次运行测试时都应该获得相同的结果。
 自我验证：测试应该完全自动化，输出应该是“通过”或“失败”。
 及时：理想情况下，在编写测试代码之前编写测试（测试驱动开发）。
 
 @testable
 @testable import Banking
 
 此属性使您的内部界面可见。（注意：私有 API 仍然是私有的。）此技术是一个出色的测试工具，但您永远不应该在生产代码中执行此操作。始终坚持使用公共 API。
 
 
 setUp 和tearDown 方法
 正如setUp在每个测试之前执行一样，tearDown在每个测试之后运行。测试通过或失败并不重要。当您需要释放所获取的资源或需要重置对象的状态时，它很有用。
 */


import XCTest

// Create a new account
let account = BasicAccount()

// Deposit and withdraw some money
account.deposit(amount: 10.00)
account.withdraw(amount: 5.00)

// ... or do evil things!
//account.balance = 1000000.00

// Create a checking account for John. Deposit $300.00
let johnChecking = CheckingAccount()
johnChecking.deposit(amount: 300.00)

// Write a check for $200.00
let check = johnChecking.writeCheck(amount: 200.0)!

// Create a checking account for Jane, and deposit the check.
let janeChecking = CheckingAccount()
janeChecking.deposit(check)
janeChecking.balance // 200.00

// Try to cash the check again. Of course, it had no effect on
// Jane's balance this time
janeChecking.deposit(check)
janeChecking.balance // 200.00

class SavingsAccount: BasicAccount {
  var interestRate: Double
  private let pin: Int
  
  @available(*, deprecated, message: "Use init(interestRate:pin:) instead")
  init(interestRate: Double) {
    self.interestRate = interestRate
    pin = 0;
  }
  
  init(interestRate: Double, pin: Int) {
    self.interestRate = interestRate
    self.pin = pin
  }
  
  @available(*, deprecated, message: "Use processInterest(pin:) instead")
  func processInterest() {
    let interest = balance * interestRate
    deposit(amount: interest)
  }
  
  func processInterest(pin: Int) {
    if pin == self.pin {
      let interest = balance * interestRate
      deposit(amount: interest)
    }
  }
}

func createAccount() -> some Account {
  CheckingAccount()
}

class BankingTests: XCTestCase {

  var checkingAccount: CheckingAccount!
  
  override func setUp() {
    super.setUp()
    checkingAccount = CheckingAccount()
  }

  override func tearDown() {
    checkingAccount.withdraw(amount: checkingAccount.balance)
    super.tearDown()
  }

  func testNewAccountBalanceZero() {
    let checkingAccount = CheckingAccount()
    XCTAssertEqual(checkingAccount.balance, 0)
  }

  func testCheckOverBudgetFails() {
    let checkingAccount = CheckingAccount()
    let check = checkingAccount.writeCheck(amount: 100)
    XCTAssertNil(check)
  }

  func testNewAPI() {
    guard #available(iOS 15, *) else {
      XCTFail("Only available in iOS 15 and above")
      return
    }
    // perform test
  }
  
  // 跳过测试
  func testNewAPISkip() throws {
      guard #available(iOS 15, *) else {
        throw XCTSkip("Only available in iOS 15 and above")
      }
      // perform test
  }

}

BankingTests.defaultTestSuite.run()






/*
Challenge 1: Singleton Pattern
A singleton is a design pattern that restricts the instantiation of a class to one object.
Use access modifiers to create a singleton class Logger. This Logger should:
Provide shared, public, global access to the single Logger object.
Not be able to be instantiated by consuming code.
Have a method log() that will print a string to the console.
Challenge 2: Stack
Declare a generic type Stack. A stack is a LIFO (last-in-first-out) data structure that supports the following operations:
peek: returns the top element on the stack without removing it. Returns nil if the stack is empty.
push: adds an element on top of the stack.
pop: returns and removes the top element on the stack. Returns nil if the stack is empty.
count: returns the size of the stack.
Ensure that these operations are the only exposed interface. In other words, additional properties or methods needed to implement the type should not be visible.
Challenge 3: Character Battle
Utilize something called a static factory method to create a game of Wizards vs. Elves vs. Giants.
Add a file Characters.swift in the Sources folder of your playground.
To begin:
Create an enum GameCharacterType that defines values for elf, giant and wizard.
Create a protocol GameCharacter that inherits from AnyObject and has properties name, hitPoints and attackPoints. Implement this protocol for every character type.
Create a struct GameCharacterFactory with a single static method make(ofType: GameCharacterType) -> GameCharacter.
Create a global function battle that pits two characters against each other — with the first character striking first! If a character reaches 0 hit points, they have lost.
Hints:
The playground should not be able to see the concrete types that implement GameCharacter.
Elves have 3 hit points and 10 attack points. Wizards have 5 hit points and 5 attack points. Giants have 10 hit points and 3 attack points.
The playground should know none of the above!
In your playground, you should use the following scenario as a test case:
let elf = GameCharacterFactory.make(ofType: .elf)
let giant = GameCharacterFactory.make(ofType: .giant)
let wizard = GameCharacterFactory.make(ofType: .wizard)

 ```
 let elf = GameCharacterFactory.make(ofType: .elf)
 let giant = GameCharacterFactory.make(ofType: .giant)
 let wizard = GameCharacterFactory.make(ofType: .wizard)

 battle(elf, vs: giant) // Giant defeated!
 battle(wizard, vs: giant) // Giant defeated!
 battle(wizard, vs: elf) // Elf defeated!
 ```

*/
