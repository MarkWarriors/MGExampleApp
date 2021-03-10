//
//  CurrentDateProvider.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

/// Used for unit testing date logics.
public protocol CurrentDateProviderType {
  func currentDate() -> Date
}

public struct CurrentDateProvider: CurrentDateProviderType {
  public init() {}
  
  public func currentDate() -> Date {
    return Date()
  }
}
