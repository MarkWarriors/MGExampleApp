import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
}

class TestInitializer: NSObject {
  override init() {
    Networking.setup(with: MockConfig.self)
  }
}

private class MockConfig: NetworkingConfigType {
  static var baseURL = URL(string: "https://mockBaseUrl.com")!
}
