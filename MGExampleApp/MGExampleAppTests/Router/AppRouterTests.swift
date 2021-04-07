//
//  AppRouterTests.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 07/04/2021.
//

import XCTest
import CommonComponents
import CommonTests
import LoginModule
import HomeModule
import ListModule
import SettingsModule
@testable import MGExampleApp

class AppRouterTests: XCTestCase {
  private var subject: AppRouterType!
  private var mockEventDetailsUseCase = MockEventDetailsUseCase()
  private var mockAppEventListener = MockAppEventListener()
  private var mockAccountCache = MockAccountCache()
  private var mockContext = MockContext()
  private var startVCReceived: UIViewController?
  private let mockAccount = Account(name: "TestAccount")

  override func setUp() {
    super.setUp()
    startVCReceived = nil
    mockEventDetailsUseCase = MockEventDetailsUseCase()
    mockAppEventListener = MockAppEventListener()
    mockAccountCache = MockAccountCache()
    mockContext = MockContext()
  }

  func test_subjectCreated_then_appEventListenerIsConfigured() {
    when_subjectIsCreated()
    then_appEventListener_isConfigured()
    then_startVCisNotReceived()
  }

  func test_startViewControllerCalled_and_accountCacheHasAccount_then_startVCisReceived_withCorrectTabBarViewControllers() {
    given_subjectIsCreated()
    given_accountCacheHasAccountStored()
    when_startViewControllerCalled()
    then_startVCReceived_isNotNil_andContainsMainTabsVCs()
  }

  func test_startViewControllerCalled_and_accountCacheHasNoAccount_then_startVCisReceived_withCorrectTabBarViewControllers() {
    given_subjectIsCreated()
    given_accountCacheHasNoAccountStored()
    when_startViewControllerCalled()
    then_startVCReceived_isNotNil_andContainsLoginVC()
  }

  func test_subjectDeepLinkActionToPerformCalled_and_given_userDidLoginCalled_and_AccountCacheHasNoAccountStored_then_mockEventDetailsUseCase_isCalled() {
    given_subjectIsCreated()
    given_accountCacheHasAccountStored()
    given_userDidLoginCalled()
    when_deepLinkActionToPerformCalled_withOpenEvent()
    then_mockEventDetailsUseCase_isCalled(true)
  }

  func test_subjectDeepLinkActionToPerformCalled_andAccountCacheHasAccountStored_then_mockEventDetailsUseCase_isNotCalled() {
    given_subjectIsCreated()
    given_accountCacheHasNoAccountStored()
    when_deepLinkActionToPerformCalled_withOpenEvent()
    then_mockEventDetailsUseCase_isCalled(false)
  }

  func test_subjectUserDidLogin_andAccountCacheHasAccountStored_then_startVCReceived_isNotNil_andContainsMainTabsVCs() {
    given_subjectIsCreated()
    given_accountCacheHasAccountStored()
    given_startViewControllerCalled()
    when_userDidLoginCalled()
    then_startVCReceived_isNotNil_andContainsMainTabsVCs()
  }

  func test_subjectUserDidLogin_andAccountCacheHasNoAccountStored_then_startVCReceived_isNotNil_andContainsLoginVC() {
    given_subjectIsCreated()
    given_accountCacheHasNoAccountStored()
    given_startViewControllerCalled()
    when_userDidLoginCalled()
    then_startVCReceived_isNotNil_andContainsLoginVC()
  }

  func test_subjectUserDidLogout_then_startVCReceived_isNotNil_andContainsLoginVC() {
    given_subjectIsCreated()
    given_startViewControllerCalled()
    given_accountCacheHasAccountStored()
    when_userDidLogoutCalled()
    then_accountCache_hasNoAccountStored()
    then_startVCReceived_isNotNil_andContainsLoginVC()
  }

  // MARK: - Given

  private func given_subjectIsCreated() {
    subject = AppRouter(eventDetailUseCase: mockEventDetailsUseCase,
                        appEventListener: mockAppEventListener,
                        accountCache: mockAccountCache,
                        context: mockContext)
  }

  private func given_accountCacheHasAccountStored() {
    mockAccountCache.saveCurrentAccount(mockAccount)
  }

  private func given_accountCacheHasNoAccountStored() {
    mockAccountCache.removeCurrentAccount()
  }

  private func given_startViewControllerCalled() {
    startVCReceived = subject.startViewController()
  }

  private func given_userDidLoginCalled() {
    subject.userDidLogin()
  }

  // MARK: - When

  private func when_subjectIsCreated() {
    subject = AppRouter(eventDetailUseCase: mockEventDetailsUseCase,
                        appEventListener: mockAppEventListener,
                        accountCache: mockAccountCache,
                        context: mockContext)
  }

  private func when_startViewControllerCalled() {
    startVCReceived = subject.startViewController()
  }

  private func when_deepLinkActionToPerformCalled_withOpenEvent() {
    subject.deepLinkActionToPerform(.openEvent(id: "eventId"))
  }

  private func when_userDidLoginCalled() {
    subject.userDidLogin()
  }

  private func when_userDidLogoutCalled() {
    subject.userDidLogout()
  }

  // MARK: - Then

  private func then_appEventListener_isConfigured() {
    XCTAssertNotNil(mockAppEventListener.delegate)
    XCTAssertTrue(mockAppEventListener.subscribeCalled)
    XCTAssertTrue(mockAppEventListener.keysAdded.contains(.userDidLogin))
    XCTAssertTrue(mockAppEventListener.keysAdded.contains(.userDidLogout))
  }

  private func then_startVCisNotReceived() {
    XCTAssertNil(startVCReceived)
  }

  private func then_startVCReceived_isNotNil_andContainsLoginVC() {
    XCTAssertNotNil(startVCReceived)
    let vc = try! XCTUnwrap(startVCReceived as? MainViewController)
    XCTAssertEqual(vc.viewControllers?.count, 1)
  }

  private func then_startVCReceived_isNotNil_andContainsMainTabsVCs() {
    XCTAssertNotNil(startVCReceived)
    let vc = try! XCTUnwrap(startVCReceived as? MainViewController)
    XCTAssertEqual(vc.viewControllers?.count, 3)
  }

  private func then_accountCache_hasAccountStored() {
    XCTAssertEqual(mockAccountCache.currentAccount?.name, mockAccount.name)
  }

  private func then_accountCache_hasNoAccountStored() {
    XCTAssertNil(mockAccountCache.currentAccount)
  }

  private func then_mockEventDetailsUseCase_isCalled(_ called: Bool) {
    XCTAssertEqual(mockEventDetailsUseCase.fetchCalled, called)
  }

}
