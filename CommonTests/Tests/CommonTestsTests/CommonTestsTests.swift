import XCTest
@testable import CommonTests

final class CommonTestsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CommonTests().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
