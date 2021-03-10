//
//  NetworkingConfig.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

public protocol NetworkingConfigType {
  static var baseURL: URL { get }
}

internal final class ConfigType {
  static internal var shared: ConfigType?

  let baseURL: URL

  internal init(_ config: NetworkingConfigType.Type) {
    baseURL = config.baseURL
  }
}

internal var Config: ConfigType {
  if let config = ConfigType.shared {
    return config
  } else {
    fatalError("Please set the Config for \(Bundle(for: ConfigType.self))")
  }
}
