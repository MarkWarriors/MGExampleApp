//
//  MockServerConfig.swift
//  
//
//  Created by Marco Guerrieri on 30/03/2021.
//

import UIKit

public final class MockServerConfig {

  enum BasicResponse: String, CaseIterable {
    case success, failure
  }

  static func getAllRoutesAndMapToResponse() -> [String: BasicResponse] {
    var dict = [String: BasicResponse]()
    Routes.allRoutes().keys.forEach { (url) in
      if let storedValue = MockServerStore.shared.get(key: url) {
        dict[url] = storedValue
      } else {
        dict[url] = .success
        MockServerStore.shared.store(key: url, response: .success)
      }
    }

    return dict
  }

  public static func getViewController() -> UIViewController {
    return MockServerConfigViewController()
  }

}

class MockServerStore: NSObject {
  public static let shared = MockServerStore()
  public let storage = UserDefaults(suiteName: "MockServerStore")!

  public func store(key: String, response: MockServerConfig.BasicResponse) {
    storage.set(response.rawValue, forKey: key)
  }

  public func get(key: String) -> MockServerConfig.BasicResponse? {
    if let value = storage.string(forKey: key),
       let response = MockServerConfig.BasicResponse(rawValue: value) {
      return response
    }
    return nil
  }

  public func printStore() {
    print("MOCK SERVER STORE: \(storage.dictionaryRepresentation())")
  }
}
