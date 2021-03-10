import XCTest
@testable import CommonStrings

final class CommonStringsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CommonStrings().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
