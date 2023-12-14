// TODO: 自己练几遍

// Documents:
/* https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/#Result-Builders
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes/#resultBuilder

 Blogs: https://fatbobman.com/posts/viewBuilder1/
        https://fatbobman.com/posts/viewBuilder2/
        https://itnext.io/viewbuilder-research-part-1-mastering-result-builders-65ac4f8dcf0d
        https://itnext.io/viewbuilder-research-part-2-creating-a-viewbuilder-imitation-7832ab96506b
 
 https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md
*/

/*:
 结果生成器首先作为 Apple SwiftUI 的一项功能出现，让您以紧凑、易于阅读的方式声明您的用户界面。此后它被扩展为通用语言功能，允许您通过组合表达式序列来构建值。使用结果构建器来定义 HTML 文档、正则表达式和数据库模式等内容可能会变得司空见惯。
 
 
 
 
 
 
 */


import UIKit
import SwiftUI

// Insight about SwiftUI @ViewBuilder
struct CustomView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
          SwiftUI.Text("Header")
                .font(.subheadline)
                .foregroundColor(.blue)
            content()
        }
    }
}




func greet(name: String) -> NSAttributedString {
  let attributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
  let message = NSMutableAttributedString()
  message.append(NSAttributedString(string: "Hello "))
  message.append(NSAttributedString(string: name, attributes: attributes))
  let attributes2 = [
    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
    NSAttributedString.Key.foregroundColor : UIColor.blue
  ]
  message.append(NSAttributedString(string: ", Mother of Dragons", attributes: attributes2))
  return message
}

greet(name: "Daenerys")


@resultBuilder
enum AttributedStringBuilder {
  // no buildBlock method, then
  // error: 20-result-builders.xcplaygroundpage:160:25: error: result builder 'AttributedStringBuilder' does not implement any 'buildBlock' or a combination of 'buildPartialBlock(first:)' and 'buildPartialBlock(accumulated:next:)' with sufficient availability for this call site
  
  // buildBlock, buildPartialBlock之一必须实现
  // 该方法使用可变参数 ( NSAttributedString...)，这意味着结果生成器可以支持任意数量的组件。
  static func buildBlock(_ components: NSAttributedString...) -> NSAttributedString {
    let attributedString = NSMutableAttributedString()
    for component in components {
      attributedString.append(component)
    }
    return attributedString
  }

  static func buildOptional(_ component: NSAttributedString?) -> NSAttributedString {
    component ?? NSAttributedString()
  }

  static func buildEither(first component: NSAttributedString) -> NSAttributedString {
    component
  }

  static func buildEither(second component: NSAttributedString) -> NSAttributedString {
    component
  }

  static func buildArray(_ components: [NSAttributedString]) -> NSAttributedString {
    let attributedString = NSMutableAttributedString()
    for component in components {
      attributedString.append(component)
    }
    return attributedString
  }

  static func buildExpression(_ expression: SpecialCharacters) -> NSAttributedString {
    switch expression {
    case .lineBreak:
      return Text("\n")
    case .comma:
      return Text(",")
    }
  }

  static func buildExpression(_ expression: NSAttributedString) -> NSAttributedString {
    expression
  }
}

enum SpecialCharacters {
  case lineBreak
  case comma
}

typealias Text = NSMutableAttributedString

extension NSMutableAttributedString {
  public func color(_ color : UIColor) -> NSMutableAttributedString {
    self.addAttribute(NSAttributedString.Key.foregroundColor,
                      value: color,
                      range: NSRange(location: 0, length: self.length))
    return self
  }

  public func font(_ font : UIFont) -> NSMutableAttributedString {
    self.addAttribute(NSAttributedString.Key.font,
                      value: font,
                      range: NSRange(location: 0, length: self.length))
    return self
  }

  convenience init(_ string: String) {
    self.init(string: string)
  }
}

@AttributedStringBuilder
func greetBuilder(name: String, title: String) -> NSAttributedString {
  Text("Hello ")
  Text(name)
    .color(.red)
  if !title.isEmpty {
    Text(", ")
    Text(title)
      .font(.systemFont(ofSize: 20))
      .color(.blue)
  } else {
    Text(", No title")
  }
}

greetBuilder(name: "Daenerys", title: "Mother of Dragons")

@AttributedStringBuilder
func greetBuilder(name: String, titles: [String]) -> NSAttributedString {
  Text("Hello ")
  Text(name)
    .color(.red)
  if !titles.isEmpty {
    for title in titles {
      SpecialCharacters.comma
      SpecialCharacters.lineBreak
      Text(title)
        .font(.systemFont(ofSize: 20))
        .color(.blue)
    }
  } else {
    Text(", No title")
  }
}

let titles = ["Khaleesi",
              "Mhysa",
              "First of Her Name",
              "Silver Lady",
              "The Mother of Dragons"]
greetBuilder(name: "Daenerys", titles: titles)




/**
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/#Result-Builders
 
 结果生成器是您定义的一种类型，它添加用于以自然的声明性方式创建嵌套数据（例如列表或树）的语法。使用结果生成器的代码可以包含普通的 Swift 语法（例如if and for）来处理条件数据或重复数据。

 下面的代码定义了几种使用星号和文本在单行上绘图的类型。
 */

//
//protocol Drawable {
//    func draw() -> String
//}
//struct Line: Drawable {
//    var elements: [Drawable]
//    func draw() -> String {
//        return elements.map { $0.draw() }.joined(separator: "")
//    }
//}
//struct TextT: Drawable {
//    var content: String
//    init(_ content: String) { self.content = content }
//    func draw() -> String { return content }
//}
//struct Space: Drawable {
//    func draw() -> String { return " " }
//}
//struct Stars: Drawable {
//    var length: Int
//    func draw() -> String { return String(repeating: "*", count: length) }
//}
//struct AllCaps: Drawable {
//    var content: Drawable
//    func draw() -> String { return content.draw().uppercased() }
//}
//
///**
// 该Drawable协议定义了对可绘制事物（例如线条或形状）的要求：类型必须实现方法draw()。该Line结构代表单线绘图，它为大多数绘图提供顶级容器。要绘制Line，该结构会调用draw()该行的每个组件，然后将生成的字符串连接成单个字符串。该Text结构包裹一个字符串，使其成为绘图的一部分。该结构包装并修改另一个绘图，将绘图中的任何文本转换为大写。AllCaps
//
// 可以通过调用它们的初始值设定项来使用这些类型进行绘图：
// */
//
//let name: String? = "Ravi Patel"
//let manualDrawing = Line(elements: [
//     Stars(length: 3),
//     TextT("Hello"),
//     Space(),
//     AllCaps(content: TextT((name ?? "World") + "!")),
//     Stars(length: 2),
//])
//print(manualDrawing.draw())
//// Prints "***Hello RAVI PATEL!**"
//
///**
// 这段代码可以工作，但是有点尴尬。后面嵌套得很深的括号很难阅读。使用“World”的回退逻辑必须使用运算符内联完成，这对于任何更复杂的事情来说都是困难的。如果您需要包含开关或循环来构建绘图的一部分，则无法做到这一点。结果生成器允许您重写这样的代码，使其看起来像正常的 Swift 代码。AllCapsnamenil??for
//
// 要定义结果生成器，您可以在类型声明中写入属性。例如，此代码定义了一个名为 的结果构建器，它允许您使用声明性语法来描述绘图：@resultBuilderDrawingBuilder
// */
//
//@resultBuilder
//struct DrawingBuilder {
//    static func buildBlock(_ components: Drawable...) -> Drawable {
//        return Line(elements: components)
//    }
//    static func buildEither(first: Drawable) -> Drawable {
//        return first
//    }
//    static func buildEither(second: Drawable) -> Drawable {
//        return second
//    }
//}
//
///**
// 该结构定义了三个方法来实现部分结果生成器语法。该方法添加了对在代码块中编写一系列行的支持。它将该块中的组件组合成一个. 和方法添加了对-的支持。DrawingBuilderbuildBlock(_:)LinebuildEither(first:)buildEither(second:)ifelse
//
// 您可以将该属性应用于函数的参数，这会将传递给函数的闭包转换为结果构建器从该闭包创建的值。例如：@DrawingBuilder
// */
//func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
//    return content()
//}
//func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
//    return AllCaps(content: content())
//}
//
//
//func makeGreeting(for name: String? = nil) -> Drawable {
//    let greeting = draw {
//        Stars(length: 3)
//        TextT("Hello")
//        Space()
//        caps {
//            if let name = name {
//                TextT(name + "!")
//            } else {
//                TextT("World!")
//            }
//        }
//        Stars(length: 2)
//    }
//    return greeting
//}
//let genericGreeting = makeGreeting()
//print(genericGreeting.draw())
//// Prints "***Hello WORLD!**"
//
//
//let personalGreeting = makeGreeting(for: "Ravi Patel")
//print(personalGreeting.draw())
//// Prints "***Hello RAVI PATEL!**"
//
//
///**
// 该函数接受一个参数并使用它来绘制个性化问候语。和函数都采用单个闭包作为参数，该闭包用属性标记。当您调用这些函数时，您使用定义的特殊语法。Swift 将绘图的声明性描述转换为对方法的一系列调用，以构建作为函数参数传递的值。例如，Swift 将该示例中的调用转换为如下代码：makeGreeting(for:)namedraw(_:)caps(_:)@DrawingBuilderDrawingBuilderDrawingBuildercaps(_:)
// */
//
//let capsDrawing = caps {
//    let partialDrawing: Drawable
//    if let name = name {
//        let text = TextT(name + "!")
//        partialDrawing = DrawingBuilder.buildEither(first: text)
//    } else {
//        let text = TextT("World!")
//        partialDrawing = DrawingBuilder.buildEither(second: text)
//    }
//    return partialDrawing
//}
//
//
///**
// Swift 将if-else块转换为对和方法的调用。尽管您不在自己的代码中调用这些方法，但显示转换结果可以让您在使用语法时更轻松地了解 Swift 如何转换代码。buildEither(first:)buildEither(second:)DrawingBuilder
//
// 要添加对for在特殊绘图语法中编写循环的支持，请添加一个方法。buildArray(_:)
// */
//
//extension DrawingBuilder {
//    static func buildArray(_ components: [Drawable]) -> Drawable {
//        return Line(elements: components)
//    }
//}
//let manyStars = draw {
//    Text("Stars:")
//    for length in 1...3 {
//        Space()
//        Stars(length: length)
//    }
//}

/**
 在上面的代码中，for循环创建了一个绘图数组，并且该方法将该数组转换为.buildArray(_:)Line

 有关 Swift 如何将构建器语法转换为对构建器类型的方法的调用的完整列表，请参阅resultBuilder。
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes/#resultBuilder
 */
