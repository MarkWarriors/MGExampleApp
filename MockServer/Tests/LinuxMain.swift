import XCTest

import MockServerTests

var tests = [XCTestCaseEntry]()
tests += MockServerTests.allTests()
XCTMain(tests)
