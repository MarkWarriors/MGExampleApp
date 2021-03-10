//
//  MainAppConfig.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation
import Networking

// MainAppConfig conform to Package Protocol
extension MainAppConfig: NetworkingConfigType {}

class MainAppConfig {
  static let baseURL = ConfigLoader.parsedConfig.baseURL
  static let isTestEnv = ConfigLoader.parsedConfig.testFlags?.isTestConfig ?? false
  static let isProdEnv = !(ConfigLoader.parsedConfig.testFlags?.isTestConfig ?? true)
}

struct Configuration: Decodable {
  let config: String
  let baseURL: URL
  let testFlags: TestFlags?

  struct TestFlags: Decodable {
    let isTestConfig: Bool
  }

  enum CodingKeys: String, CodingKey {
    case config, baseURL, testFlags
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.baseURL = try URL(string: container.decode(String.self, forKey: .baseURL))!
    self.config = try container.decode(String.self, forKey: .config)
    self.testFlags = try container.decode(TestFlags.self, forKey: .testFlags)
  }
}

private class ConfigLoader {
  static let ConfigName = "Config.plist"
  static var parsedConfig: Configuration = parseFile()

  static func parseFile(named fileName: String = ConfigName) -> Configuration {
    guard let filePath = Bundle.main.path(forResource: fileName, ofType: nil),
          let fileData = FileManager.default.contents(atPath: filePath)
    else {
      fatalError("Config file '\(fileName)' not loadable!")
    }

    do {
      return try PropertyListDecoder().decode(Configuration.self,
                                              from: fileData)
    } catch {
      fatalError("Configuration not decodable from '\(fileName)': \(error)")
    }
  }
}
