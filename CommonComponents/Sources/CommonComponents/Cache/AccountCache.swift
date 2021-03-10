//
//  AccountCache.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 10/03/2021.
//


import Foundation

public struct Account: Codable {
  public let name: String

  public init(name: String) {
    self.name = name
  }
}

public protocol AccountCacheType: AnyObject {
  var currentAccount: Account? { get set }
  func saveCurrentAccount(_ account: Account?)
  func removeCurrentAccount()
}

public final class AccountCache: AccountCacheType {
  public var currentAccount: Account? {
    get { return fetchCurrentAccount() }
    set { saveCurrentAccount(newValue) }
  }

  private static let profileKey: String = "ACCOUNT_STORAGE_KEY"
  private let storage: UserDefaults

  public init(with storage: UserDefaults) {
    self.storage = storage
  }

  public func saveCurrentAccount(_ account: Account?) {
    let data = try? PropertyListEncoder().encode(account)
    storage.setValue(data, forKey: AccountCache.profileKey)
  }

  public func removeCurrentAccount() {
    storage.removeObject(forKey: AccountCache.profileKey)
  }

  private func fetchCurrentAccount() -> Account? {
    guard let data = storage.data(forKey: AccountCache.profileKey) else {
      return nil
    }
    let account = try? PropertyListDecoder().decode(Account.self, from: data)
    return account
  }

  private func clearProfile() {
    currentAccount = nil
    removeCurrentAccount()
  }
}
