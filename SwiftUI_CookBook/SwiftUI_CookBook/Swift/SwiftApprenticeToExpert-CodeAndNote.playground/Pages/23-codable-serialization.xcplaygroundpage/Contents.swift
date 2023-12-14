import Foundation
import XCTest

/*:
 使用 CodingKeys 重命名属性
 
 事实证明，礼品部门 API 要求员工 ID 显示为 ，employeeId而不是id。幸运的是，Swift 为此类问题提供了解决方案。
 
 CodingKey 协议和 CodingKeys 枚举
 
 */
struct Employee {
  var name: String
  var id: Int
  var favoriteToy: Toy?

  enum CodingKeys: String, CodingKey {
    case id = "employeeId"
    case name
    case gift
  }
}

extension Employee: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(id, forKey: .id)
    try container.encodeIfPresent(favoriteToy?.name, forKey: .gift)
  }
}

extension Employee: Decodable {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    id = try values.decode(Int.self, forKey: .id)
    if let gift = try values.decodeIfPresent(String.self, forKey: .gift) {
      favoriteToy = Toy(name: gift)
    }
  }
}

//: JSONEncoder 和 JSONDecoder

struct Toy: Codable {
  var name: String
}

let toy1 = Toy(name: "Teddy Bear")
let employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)
let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(employee1)
print(jsonData)

let jsonString = String(data: jsonData, encoding: .utf8)!
print(jsonString)

let jsonDecoder = JSONDecoder()
let employee2 = try jsonDecoder.decode(Employee.self, from: jsonData)

class EncoderDecoderTests: XCTestCase {
  var jsonEncoder: JSONEncoder!
  var jsonDecoder: JSONDecoder!
  var toy1: Toy!
  var employee1: Employee!

  override func setUp() {
    super.setUp()
    jsonEncoder = JSONEncoder()
    jsonDecoder = JSONDecoder()
    toy1 = Toy(name: "Teddy Bear")
    employee1 = Employee(name: "John Appleseed", id: 7, favoriteToy: toy1)
  }
  
  func testEncoder() {
    let jsonData = try? jsonEncoder.encode(employee1)
    XCTAssertNotNil(jsonData, "Encoding failed")
    
    let jsonString = String(data: jsonData!, encoding: .utf8)!
    XCTAssertEqual(jsonString, "{\"name\":\"John Appleseed\",\"gift\":\"Teddy Bear\",\"employeeId\":7}")
  }
  
  func testDecoder() {
    let jsonData = try! jsonEncoder.encode(employee1)
    let employee2 = try? jsonDecoder.decode(Employee.self, from: jsonData)
    XCTAssertNotNil(employee2)
    
    XCTAssertEqual(employee1.name, employee2!.name)
    XCTAssertEqual(employee1.id, employee2!.id)
    XCTAssertEqual(employee1.favoriteToy?.name, employee2!.favoriteToy?.name)
  }
}

EncoderDecoderTests.defaultTestSuite.run()
