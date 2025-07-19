import Foundation

// MARK: - Basic Protocol Examples
// Demonstrates common built-in protocols with explicit implementations

// Identity, Equality, and Hashing Protocols
fileprivate struct Point: Hashable, Identifiable, Equatable {
    public var id = UUID()  // Identifiable protocol implementation
    var x, y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    // Equatable protocol implementation
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    // Hashable protocol implementation
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// Enum Protocols: RawRepresentable and CaseIterable
fileprivate enum Direction: String, CaseIterable, RawRepresentable {
    case north = "North"
    case south = "South"
    case east = "East"
    case west = "West"
    
    // RawRepresentable protocol implementation
    var rawValue: String {
        switch self {
        case .north:
            return "North"
        case .south:
            return "South"
        case .east:
            return "East"
        case .west:
            return "West"
        }
    }
}

// Comparison Protocol
fileprivate struct Score: Comparable {
    var points: Int
    
    // Comparable protocol implementation
    static func <(lhs: Score, rhs: Score) -> Bool {
        return lhs.points < rhs.points
    }
}

// String Representation Protocol
fileprivate struct Coordinate: CustomStringConvertible {
    var x: Double
    var y: Double
    
    // CustomStringConvertible protocol implementation
    var description: String {
        return "Coordinate(x: \(x), y: \(y))"
    }
}

// MARK: - Literal Expressible Protocols
// Allow types to be initialized with literals

// String Literal Protocol
fileprivate struct Message: ExpressibleByStringLiteral {
    var content: String
    
    // ExpressibleByStringLiteral protocol implementation
    init(stringLiteral value: StringLiteralType) {
        self.content = value
    }
}

// Array Literal Protocol
fileprivate struct NumberSet: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Int
    var numbers: [Int]
    
    // ExpressibleByArrayLiteral protocol implementation
    init(arrayLiteral elements: Int...) {
        self.numbers = elements
    }
}

// MARK: - Codable Protocol
// JSON encoding/decoding with custom key mapping

fileprivate struct PProduct: Codable {
    var name: String
    var price: Double
    var isOnSale: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case isOnSale = "on_sale"
    }
    
    // Custom Decodable logic
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        isOnSale = try container.decode(Bool.self, forKey: .isOnSale)
    }
    
    // Custom Encodable logic
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(isOnSale, forKey: .isOnSale)
    }
}

// MARK: - Custom Protocol Examples
// Protocol inheritance and extensions

// Base protocol
protocol Describable {
    var description: String { get }
}

// Protocol inheritance
protocol DetailPrintable: Describable {
    var detailedDescription: String { get }
}

// Protocol extensions with default implementations
extension Describable {
    var description: String {
        return "This is a Describable object"
    }
}

extension DetailPrintable {
    var detailedDescription: String {
        return "Detailed Description: \(description)"
    }
}

// Protocol with additional requirements
protocol AgeDescribable: Describable {
    var age: Int { get }
}

// Conforming types
struct Book: DetailPrintable {
    var title: String
    var author: String
    var description: String {
        return "Book: \(title) by \(author)"
    }
    // Uses DetailPrintable's default implementation
}

struct Person: AgeDescribable {
    var name: String
    var age: Int
    var description: String {
        return "Person: \(name), age \(age)"
    }
}

// Polymorphic behavior
func printDescription(_ describable: Describable) {
    print(describable.description)
}

func exampleOfProtocol() {
    // Usage examples
    let myBook = Book(title: "Swift Programming", author: "John Doe")
    print(myBook.description)
    print(myBook.detailedDescription)
    
    let someone = Person(name: "Alice", age: 30)
    print(someone.description)
    
    // Polymorphic behavior
    printDescription(myBook)
    printDescription(someone)
}


// MARK: - Associated Types
// Protocols with generic constraints

protocol Job {
    associatedtype SkillId
    var id: SkillId { get set }
}

protocol JobSearchingPerson {
    associatedtype SkillId
    var knows: SkillId { get set }
    
    func assign<J>(job: J) where J : Job, Self.SkillId == J.SkillId
}

// Concrete implementations
struct DeveloperJob: Job {
    typealias SkillId = String
    var id: SkillId
}

struct Developer: JobSearchingPerson {
    typealias SkillId = String
    var knows: SkillId
    
    func assign<J>(job: J) where J : Job, J.SkillId == SkillId {
        print("Developer assigned to job with ID: \(job.id)")
    }
}

func exampleOfAssociatedType() {
    // Usage example
    let job = DeveloperJob(id: "iOS")
    let developer = Developer(knows: "iOS")
    
    developer.assign(job: job)
}

/**
 中立的 Swift 开发人员将 Swift 称为“多范式”语言。Swift包含面向对象和面向协议编程
 
 协议和面向协议的编程是 Swift 语言的基础。例如，泛型系统使用协议来精确指定所使用的泛型类型的类型要求。如果您有m 个数据结构和n 个对这些数据结构进行操作的算法，则在某些语言中，您需要m * n代码块来实现它们。使用 Swift，使用协议，您只需要编写m + n块，无需重复。面向协议的编程为您提供了面向对象编程的所有优点，同时避免了大多数陷阱。
 
 下次面对编程任务时，请从值类型开始。看看您是否能找出跨类型的共同元素。这些成为协议的候选者，并且通常与所关注的问题领域密切相关。以这种方式思考可能会导致您获得更灵活和可扩展的解决方案。就像 Neo 可以在《黑客帝国》中看到红色连衣裙一样，你越养成这个习惯，就越容易看到协议抽象。
 
 关键点
 协议扩展允许您编写协议的实现代码，甚至可以编写协议所需方法的默认实现。
 协议扩展是面向协议编程的主要驱动程序，使您可以编写适用于符合协议的任何类型的代码。
 正式协议声明的接口部分是采用类型可以覆盖的定制点。
 协议扩展的类型约束提供了额外的上下文，让您可以编写更专门的实现。
 您可以使用特征和混合来装饰类型来扩展行为，而无需继承。
 如果使用得当，协议可以促进代码重用和封装。
 */
