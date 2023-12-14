/*:
 https://www.kodeco.com/books/expert-swift
 
 引言
 欢迎来到 Swift 专家！这本书适合希望提高技能和对语言的理解的中级 Swift 开发人员。
 Swift 是一种强大而美妙的语言，世界各地的许多开发人员都使用它来构建 iOS、macOS、tvOS 和 watchOS 应用程序。如果您正在阅读本书，那么您可能已经自己构建了一些应用程序。
 raywanderlich.com 上的大多数书籍都是“教程”，但这本书有点不同。由于这是一本高级书籍，我们没有为每一章编写教程。相反，我们通过涵盖低级概念和高级抽象来深入研究，通过使用示例项目来说明如何在现实生活中使用高级主题。
 你应该期待一些更长的章节。尝试解释高级主题（例如本书所涵盖的主题）并不是一件容易的事。不过，获得这些高级知识是值得的，当您阅读本书时，您会发现自己想要跳转到现有的应用程序并实施您学到的技术。
 深呼吸，享受旅程！
 如何阅读这本书
 本书的每一章都介绍了有关当前主题的一些理论，以及用于演示您所学内容的实际应用的 Swift 代码。
 这些章节是独立的，这意味着您可以按照您喜欢的任何顺序阅读它们。唯一的例外是协议（第 3 章）和泛型（第 4 章）章节，它们共享一个示例项目。
 有些章节提供了一个入门项目，而有些章节中您将使用游乐场从头开始编写代码。
 本书分为三个主要部分：
 第一节：核心概念
 本书的第一部分涵盖了 Swift 语言的基本构建块：类型系统（枚举、结构和类）、协议和泛型。我们将从每个主题的简短回顾开始，然后直接跳到幕后实现。
 本节的内容将揭示类型系统的内部工作原理，并让您熟悉协议和泛型。
 第二节：标准库
 本节涵盖了编写 Swift 程序的基础层：数字、范围、字符串、序列、集合、可编码以及不太明显但非常重要的主题 - 不安全。
 正如您对一本高级书籍所期望的那样，我们不仅解释了这些主题，而且还研究了它们的构建方式、表示方式以及如何有效地使用它们。
 第三节：技术
 本书的最后一部分介绍了增强 Swift 能力的高级技术，并使用 Swift 提供的所有功能。
 我们将涵盖高阶函数、函数反应式编程、Objective-C 互操作性、使用 Instrumentation 和 API 设计等主题。
 */


/*:
 简介
 雷·菲克斯 编剧
 2010 年，Chris Lattnermkdir shiny在笔记本电脑上打字，最终 Swift 语言诞生了。Shiny 最初是他在晚上和周末完成的个人项目。
 该项目有许多雄心勃勃的目标。拉特纳在采访和播客中提到了其中一些，包括：
 采用允许新编程范例的现代语言功能。
 使用自动内存管理来避免垃圾收集的开销。
 在库而不是编译器中定义尽可能多的语言。
 使语言默认值安全以避免代价高昂的未定义行为。
 让初学者轻松学习。
 
 斯威夫特发布
 文档 https://www.swift.org/
 完整源代码 https://github.com/apple/swift
 */

/*:
 ![compiler](compiler.png)
 
 
 将 Swift 等高级语言转换为可以在实际硬件上高效运行的机器代码的过程称为“降低”。上面显示的圆角矩形是由矩形表示的阶段的输入或输出的数据。从高层次上理解每一个步骤都是值得的：
 解析：Swift 源代码首先被解析为标记并放入抽象语法树或AST中。您可以将其视为一棵树，其中每个表达式都是一个节点。这些节点还保存源位置信息，因此，如果检测到错误，该节点可以准确地告诉您问题发生的位置。
 语义分析（Sema）：在这一步中，编译器使用 AST 来分析程序的含义。这是类型检查发生的地方。它将经过类型检查的 AST 传递到SILGen阶段。
 SILGen：此阶段与以前的编译器管道（例如Clang ）不同，后者没有此步骤。AST 降级为Swift 中间语言( SIL )。SIL 包含基本计算块并了解 Swift 类型、引用计数和调度规则。SIL 有两种风格：原始的和规范的。原始 SIL 通过最少的一组优化传递（即使所有优化均已关闭）运行，得到规范的 SIL 结果。SIL 还包含源位置信息，因此它可以产生有意义的错误。
 IRGen：该工具将 SIL 降低为 LLVM 的中间表示。此时，指令不再是 Swift 特定的。（每个基于 LLVM 的都使用这种表示形式。）IR 仍然相当抽象。与 SIL 一样，IR 也采用静态单一赋值 (SSA) 形式。它将机器建模为具有无限数量的寄存器，从而更容易找到优化。它对 Swift 类型一无所知。
 LLVM：最后一步优化 IR 并将其降低为特定平台的机器指令。后端（输出机器指令）包括 ARM、x86、Wasm 等。
 上图显示了 Swift 编译器如何生成目标代码。其他工具（例如源代码格式化程序、重构工具、文档生成器和语法突出显示器）可以利用中间结果（例如 AST），使最终结果更加稳健和一致。
 历史记录：在Apple采用LLVM和Clang作为Xcode的编译器技术之前，语法高亮、文档生成、调试和编译都使用不同的解析器。大多数时候，这工作得很好。但如果它们不同步，事情也会变得奇怪。
 
 
 
 
 The process of taking a high-level language such as Swift and transforming it into machine code that can run efficiently on actual hardware is called lowering. The rounded rectangles shown above are data that are inputs or outputs of the phases represented by rectangles. It’s worth understanding each one of the steps from a high level:
 Parse: Swift source code is first parsed into tokens and put into an abstract syntax tree or AST. You can think of this being a tree in which each expression is a node. The nodes also hold source location information so, if an error is detected, the node can tell you exactly where the problem occurred.
 Semantic Analysis (Sema): In this step, the compiler uses the AST to analyze your program’s meaning. This is where type checking occurs. It passes the type-checked AST to the SILGen phase.
 SILGen: This phase departs from previous compiler pipelines such as Clang, which didn’t have this step. The AST gets lowered into Swift Intermediate Language (SIL). SIL contains basic blocks of computation and understands Swift Types, reference counting and dispatch rules. There are two flavors of SIL: raw and canonical. Canonical SIL results from raw SIL run through a minimum set of optimization passes (even when all optimizations are turned off). SIL also contains source location information so it can produce meaningful errors.
 IRGen: This tool lowers SIL to LLVM’s intermediate representation. At this point, the instructions are no longer Swift specific. (Every LLVM-based uses this representation.) IR is still quite abstract. Like SIL, IR is in Static single assignment (SSA) form. It models machines as having an unlimited number of registers, making it easier to find optimizations. It doesn’t know anything about Swift types.
 LLVM: This final step optimizes the IR and lowers it to machine instructions for a particular platform. Backends (which output machine instructions) include ARM, x86, Wasm and more.
 The diagram above shows how the Swift compiler generates object code. Other tools, such as source code formatters, refactoring tools, documentation generators and syntax highlighters can tap into the intermediate results, such as the AST, making the final results more robust and consistent.
 Historical note: Before Apple adopted LLVM and Clang for Xcode’s compiler technology, the syntax highlighting, document generation, debugging and compiling all used different parsers. Most of the time, this worked fine. But things could also get weird if they got out of sync.
 */


/*:
 关键点
 本章讨论了构建 Swift 语言的一些动机以及 Swift 的库和编译器如何协同工作以创建强大的抽象。以下是一些要点：
 Swift 是一种多范式语言，支持多种编程风格，包括命令式、函数式、面向对象、面向协议和泛型范式。
 Swift 的目标是选择合理的默认值，使未定义的行为难以触发。
 斯威夫特拥护渐进披露的理念。您只需在需要时才需要了解更高级的语言功能。
 Swift 是一种通用编程语言，具有强大的类型系统和类型推断功能。
 Swift 的大部分内容是在其富有表现力的标准库中定义的，而不是作为编译器的一部分。
 Swift 编译器阶段包括解析、语义分析、SILGen、IRGen 和 LLVM。
 源位置信息驻留在 AST 和 SIL 中，从而可以更好地报告错误。
 SIL 是使用以 SSA 形式编写的基本指令块的低级描述。它理解 Swift 类型的语义，从而实现许多纯 LLVM IR 无法实现的优化。
 SIL 有助于支持明确的初始化、内存分配优化和去虚拟化。
 Any是 Swift 中的终极类型擦除，但使用起来很容易出错。泛型通常是更好的选择。
 将闭包作为参数传递，该参数返回一个值以将参数的计算推迟到函数体内。
 @autoclosure是一种实现短路行为的方法，因为它推迟了表达式参数的执行。
 rethrow是一种从可能标记或未标记的闭包中传播错误的方法throws。
 @inlinable向编译器提示函数的指令应发送到调用站点。
 编译器消除了源代码的大部分（如果不是全部）抽象成本。如果不同的源代码具有相同的语义，编译器可能会发出相同的机器指令。
 抽象应该为自己付出代价。在创建新的语言功能之前要仔细考虑。
 
 
 
 从这往哪儿走？
 本章的大部分内容讨论了 Swift 编译器如何通过 SIL 将高级类型和语句降低为高效的机器表示。降低是一个激烈（且利基）的话题。如果您有兴趣了解更多信息，请查看编译器工程师 Slava Pestov 撰写的这篇稍旧但仍然非常相关的博客文章http://bit.ly/slava-types。这是对 Swift 类型和降级的极其深入的研究，因此在处理它之前，您可能需要阅读本节有关类型、协议和泛型的其余部分。
 Swift 编译器团队的成员，包括 Chris Lattner、Slava Pestov、Joseph Groff、John McCall 和 Doug Gregor，出现在 LLVM 会议上有关编译器实现的演讲中。http://bit.ly/swift-sil是一个不错的起点。
 最后，查看在线工具https://godbolt.org，它可以让您在网络浏览器中编辑多种不同语言（包括 Swift）的代码，并查看它们如何降低。您可能想尝试使用编译器标志-O, -Onone, -Ounchecked。在 Web 界面中的输出设置下，您可能需要取消选中“Intel asm 语法”以获取汇编输出，如本章所示。
 */


@inlinable
func ifelse<V>(_ condition: Bool,
               _ valueTrue: @autoclosure () throws -> V,
               _ valueFalse: @autoclosure () throws -> V) rethrows -> V {
  condition ? try valueTrue() : try valueFalse()
}

// Usage examples:

func expensiveValue1() -> Int {
  print("side-effect-1")
  return 2
}

func expensiveValue2() -> Int {
  print("side-effect-2")
  return 1729
}

func expensiveFailingValue1() throws -> Int {
  print("side-effect-1")
  return 2
}

func expensiveFailingValue2() throws -> Int {
  print("side-effect-2")
  return 1729
}

let value = ifelse(.random(), 100, 0 )

let taxicab = ifelse(.random(),
                     expensiveValue1(),
                     expensiveValue2())

let taxicab2 = try ifelse(.random(),
                          try expensiveFailingValue1(),
                          try expensiveFailingValue2())
let taxicab3 = try ifelse(.random(),
                          expensiveValue1(),
                          try expensiveFailingValue2())
let taxicab4 = try ifelse(.random(),
                          try expensiveFailingValue1(),
                          expensiveValue2())








let numbers = [1, 2, 4, 10, -1, 2, -10]

example("imperative") {
  var total = 0
  for value in numbers {
    total += value
  }
  print(total)
}

example("functional") {
  let total = numbers.reduce(0, +)
  print(total)
}

example("functional, early-exit") {
  let total = numbers.reduce((accumulating: true, total: 0)) { (state, value) in
    if state.accumulating && value >= 0 {
      return (accumulating: true, state.total + value)
    }
    else {
      return (accumulating: false, state.total)
    }
  }.total
  print(total)
}

example("imperative, early-exit") {
  var total = 0
  for value in numbers {
    guard value >= 0 else { break }
    total += value
  }
  print(total)
}

example("imperative, early-exit with just-in-time mutability") {
  let total: Int = {
    // same-old imperative code
    var total = 0
    for value in numbers {
      guard value >= 0 else { break }
      total += value
    }
    return total
  }()
  print(total)
}
