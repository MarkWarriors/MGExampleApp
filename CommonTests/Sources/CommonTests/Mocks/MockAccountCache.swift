//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 01/04/2021.
//

import Foundation
import CommonComponents

public class MockAccountCache: AccountCacheType {
  public var currentAccount: Account?

  public init() {}

  public func removeCurrentAccount() {
    currentAccount = nil
  }

  public func saveCurrentAccount(_ account: Account?) {
    currentAccount = account
  }
}
