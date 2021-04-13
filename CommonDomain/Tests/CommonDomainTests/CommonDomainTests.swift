import XCTest
@testable import CommonDomain

final class CommonDomainTests: XCTestCase {

  func test_propertyWrapperHelper() {

    struct Object: Decodable {
      @Default @StringConvertible var value: Double
    }

    let json = """
    {
      "value": "100"
    }
    """
    let object = try? JSONDecoder().decode(Object.self, from: json.data(using: .utf8)!)
    XCTAssertEqual(object?.value, 100)


    let json2 = """
    {
      "value": "no double here"
    }
    """
    let object2 = try? JSONDecoder().decode(Object.self, from: json2.data(using: .utf8)!)
    XCTAssertEqual(object2?.value, 0.0)
  }
}
