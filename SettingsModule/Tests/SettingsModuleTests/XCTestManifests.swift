import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SettingsModuleTests.allTests),
    ]
}
#endif
