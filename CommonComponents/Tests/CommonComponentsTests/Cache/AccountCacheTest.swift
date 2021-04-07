//
//  AccountCacheTest.swift
//  
//
//  Created by Marco Guerrieri on 07/04/2021.
//

import Foundation
import XCTest
import CommonComponents

final class AccountCacheTest: XCTestCase {
  var subject: AccountCache!

  private let mockAccount = Account(name: "MockAccount")
  private let mockUserDefault = UserDefaults(suiteName: "TestUserDefaults")!

  // MARK: - Tests

  override func tearDown() {
    super.tearDown()
    mockUserDefault.dictionaryRepresentation().keys.forEach { key in
      mockUserDefault.removeObject(forKey: key)
    }
  }

  func test_newCacheCreated_then_noAccountIsStored() {
    given_cacheIsCreated()
    then_currentAccount_isNil()
  }

  func test_cacheHasNoAccount_andStoreAccountIsCalled_then_accountIsStored() {
    given_cacheIsCreated()
    when_saveCurrentAccountCalled()
    then_currentAccount_isNotNil()
  }

  func test_cacheHasAccount_andClearCacheIsCalled_then_noAccountIsStored() {
    given_cacheIsCreated_withAccountStored()
    when_removeCurrentAccountIsCalled()
    then_currentAccount_isNil()
  }

  // MARK: - Given

  private func given_cacheIsCreated() {
    subject = AccountCache(with: mockUserDefault)
  }

  private func given_cacheIsCreated_withAccountStored() {
    subject = AccountCache(with: mockUserDefault)
    subject.saveCurrentAccount(mockAccount)
  }

  // MARK: - When

  private func when_removeCurrentAccountIsCalled() {
    subject.removeCurrentAccount()
  }

  private func when_saveCurrentAccountCalled() {
    subject.saveCurrentAccount(mockAccount)
  }

  // MARK: - Then

  private func then_currentAccount_isNil() {
    XCTAssertNil(subject.currentAccount)
  }

  private func then_currentAccount_isNotNil() {
    XCTAssertNotNil(subject.currentAccount)
    XCTAssertEqual(subject.currentAccount?.name, mockAccount.name)
  }

}
