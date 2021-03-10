//
//  LoginViewPresenterTests.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import XCTest
import CommonTests
import CommonDomain
@testable import LoginModule

final class LoginViewPresenterTests: XCTestCase {
  private var mockRouter: MockLoginModuleRouter!
  private var mockView: MockLoginPresentableView!
  private var mockLoginUseCase: MockLoginUseCase!
  private var mockAccountCache: MockAccountCache!
  private var presenter: LoginViewPresenter!

  override func setUp() {
    mockView = MockLoginPresentableView()
    mockLoginUseCase = MockLoginUseCase()
    mockAccountCache = MockAccountCache()
    mockRouter = MockLoginModuleRouter()
    presenter = LoginViewPresenter(loginUseCase: mockLoginUseCase, accountCache: mockAccountCache, router: mockRouter)
  }

  func test_viewModel_isCorrectlyPassed_whenSetup_isCalled() {
    when_setupIsCalledOnSubject()
    then_viewModel_isCorrectlyPassed()
  }

  func test_loginUseCase_setupAsFailure_and_loginButtonTapped_then_errorIsShown() {
    given_setupHasBeenCalledOnSubject()
    given_loginUseCase_setupAsFailure()
    when_loginButtonTapped()
    then_errorIsShown()
  }

  func test_loginUseCase_setupAsSuccess_and_loginButtonTapped_then_routerUserDidLoginCalled() {
    given_setupHasBeenCalledOnSubject()
    given_loginUseCase_setupAsSuccess()
    when_loginButtonTapped()
    then_routerUserDidLoginCalled()
  }

  func test_loginUseCase_setupAsFailure_and_retryTapped_then_errorIsShown() {
    given_setupHasBeenCalledOnSubject()
    given_loginUseCase_setupAsFailure()
    when_retryOnErrorAlertTapped()
    then_errorIsShown()
  }

  func test_loginUseCase_setupAsSuccess_and_retryTapped_then_routerUserDidLoginCalled() {
    given_setupHasBeenCalledOnSubject()
    given_loginUseCase_setupAsSuccess()
    when_retryOnErrorAlertTapped()
    then_routerUserDidLoginCalled()
  }

  func test_userInsertValidUsernameAndPassword_then_loginButtonEnabled() {
    given_setupHasBeenCalledOnSubject()
    when_userInsertValidUsernameAndPassword()
    then_loginButtonUpdated(enabled: true)
  }

  func test_userInsertInalidUsernameAndPassword_then_loginButtonDisabled() {
    given_setupHasBeenCalledOnSubject()
    when_userInsertInvalidUsernameAndPassword()
    then_loginButtonUpdated(enabled: false)
  }

  // MARK: Given

  private func given_setupHasBeenCalledOnSubject() {
    presenter.setup(with: mockView)
    mockView.reset()
  }

  private func given_loginUseCase_setupAsSuccess() {
    mockLoginUseCase.resultToReturn = .success(MockLoginResponse.mock())
  }

  private func given_loginUseCase_setupAsFailure() {
    mockLoginUseCase.resultToReturn = .failure(NSError())
  }

  // MARK: When

  private func when_setupIsCalledOnSubject() {
    presenter.setup(with: mockView)
  }

  private func when_loginButtonTapped() {
    presenter.loginButtonTapped(username: "Username", password: "Password")
  }

  private func when_registerButtonTapped() {
    presenter.registerButtonTapped()
  }

  private func when_retryOnErrorAlertTapped() {
    presenter.retryOnErrorAlertTapped(username: "Username", password: "Password")
  }

  private func when_userInsertValidUsernameAndPassword() {
    presenter.userInsertText(username: "Foo", password: "Bar")
  }

  private func when_userInsertInvalidUsernameAndPassword() {
    presenter.userInsertText(username: "F", password: "B")
  }

  // MARK: Then

  private func then_viewModel_isCorrectlyPassed() {
    let viewModel = try! XCTUnwrap(mockView.viewModel)
    XCTAssertEqual(viewModel.titleLabel, "Login")
    XCTAssertNotNil(viewModel.imageOnTop)
    XCTAssertEqual(viewModel.usernameTextView.placeholder, "Username")
    XCTAssertEqual(viewModel.usernameTextView.text, "")
    XCTAssertEqual(viewModel.usernameTextView.state, .normal)
    XCTAssertEqual(viewModel.passwordTextView.placeholder, "Password")
    XCTAssertEqual(viewModel.passwordTextView.text, "")
    XCTAssertEqual(viewModel.passwordTextView.state, .normal)
    XCTAssertEqual(viewModel.loginButton.title, "Login")
    XCTAssertFalse(viewModel.loginButton.tapable)
    XCTAssertEqual(viewModel.registerAccountButton.title, "Register New Account")
    XCTAssertTrue(viewModel.registerAccountButton.tapable)
  }

  private func then_errorIsShown() {
    XCTAssertEqual(mockView.showErrorViewModel?.title, "Attention")
    XCTAssertEqual(mockView.showErrorViewModel?.message, "Wrong credentials inserted")
    XCTAssertEqual(mockView.showErrorViewModel?.retryAction, "Retry")
    XCTAssertEqual(mockView.showErrorViewModel?.cancelAction, "Cancel")
  }

  private func then_routerUserDidLoginCalled() {
    XCTAssertTrue(mockRouter.userDidLoginCalled)
  }

  private func then_loginButtonUpdated(enabled: Bool) {
    XCTAssertEqual(mockView.updateLoginButtonEnabled, enabled)
  }

}

private class MockLoginPresentableView: LoginViewPresentable {
  var className = "MOCK_VIEW"
  var viewModel: LoginViewModel?
  var updateLoginButtonEnabled: Bool?
  var showErrorViewModel: LoginViewErrorViewModel?

  func configure(with viewModel: LoginViewModel) {
    self.viewModel = viewModel
  }

  func updateLoginButton(enabled: Bool) {
    updateLoginButtonEnabled = enabled
  }

  func showError(viewModel: LoginViewErrorViewModel) {
    showErrorViewModel = viewModel
  }

  func reset() {
    viewModel = nil
    updateLoginButtonEnabled = nil
    showErrorViewModel = nil
  }

}
