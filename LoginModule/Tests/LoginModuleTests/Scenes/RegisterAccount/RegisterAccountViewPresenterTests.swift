//
//  RegisterAccountViewPresenterTests.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import XCTest
import CommonTests
import CommonDomain
@testable import LoginModule

final class RegisterAccountViewPresenterTests: XCTestCase {
  private var mockRouter: MockLoginModuleRouter!
  private var mockView: MockRegisterAccountPresentableView!
  private var mockRegisterAccountUseCase: MockRegisterAccountUseCase!
  private var presenter: RegisterAccountViewPresenter!
  private let mockCorrectAnswers = RegisterAccountFormAnswers(name: "Marco", surname: "Marco", username: "Marco", email: "marco@marco.com", confirmEmail: "marco@marco.com", password: "Marco", confirmPassword: "Marco")
  private let mockIncorrectAnswers = RegisterAccountFormAnswers(name: "M", surname: "M", username: "M", email: "M", confirmEmail: "A", password: "M", confirmPassword: "A")

  override func setUp() {
    mockView = MockRegisterAccountPresentableView()
    mockRegisterAccountUseCase = MockRegisterAccountUseCase()
    mockRouter = MockLoginModuleRouter()
    presenter = RegisterAccountViewPresenter(registerAccountUseCase: mockRegisterAccountUseCase, router: mockRouter)
  }

  func test_viewModel_isCorrectlyPassed_whenSetup_isCalled() {
    when_setupIsCalledOnSubject()
    then_viewModel_isCorrectlyPassed()
  }

  func test_registerAccountUseCase_setupAsSuccess_and_registerButtonTapped_then_routerDismissIsCalled() {
    given_setupHasBeenCalledOnSubject()
    given_registerAccountUseCase_setupAsSuccess()
    when_didTapOnRegisterButton(answers: mockCorrectAnswers)
    then_routerDismissIsCalled()
  }

  func test_registerAccountUseCase_setupAsFailure_and_registerButtonTapped_then_errorIsShown() {
    given_setupHasBeenCalledOnSubject()
    given_registerAccountUseCase_setupAsFailure()
    when_didTapOnRegisterButton(answers: mockCorrectAnswers)
    then_errorIsShown()
  }

  func test_wrongAnswersGiven_and_registerAccountUseCase_setupAsSuccess_and_registerButtonTapped_then_routerDismissIsCalled() {
    given_setupHasBeenCalledOnSubject()
    given_registerAccountUseCase_setupAsSuccess()
    when_didTapOnRegisterButton(answers: mockIncorrectAnswers)
    then_errorIsShownForIncorrectFormAnswers()
  }

  func test_registerAccountUseCase_setupAsSuccess_and_retryTapped_then_routerDismissIsCalled() {
    given_setupHasBeenCalledOnSubject()
    given_registerAccountUseCase_setupAsSuccess()
    when_retryOnErrorAlertTapped(answers: mockCorrectAnswers)
    then_routerDismissIsCalled()
  }

  func test_registerAccountUseCase_setupAsFailure_and_retryTapped_then_errorIsShown() {
    given_setupHasBeenCalledOnSubject()
    given_registerAccountUseCase_setupAsFailure()
    when_retryOnErrorAlertTapped(answers: mockCorrectAnswers)
    then_errorIsShown()
  }

  func test_wrongAnswersGiven_and_registerAccountUseCase_setupAsSuccess_and_retryTapped_then_routerDismissIsCalled() {
    given_setupHasBeenCalledOnSubject()
    given_registerAccountUseCase_setupAsSuccess()
    when_retryOnErrorAlertTapped(answers: mockIncorrectAnswers)
    then_errorIsShownForIncorrectFormAnswers()
  }

  // MARK: Given

  private func given_setupHasBeenCalledOnSubject() {
    presenter.setup(with: mockView)
    mockView.reset()
  }

  private func given_registerAccountUseCase_setupAsSuccess() {
    mockRegisterAccountUseCase.resultToReturn = .success(MockRegisterResponse.mock())
  }

  private func given_registerAccountUseCase_setupAsFailure() {
    mockRegisterAccountUseCase.resultToReturn = .failure(NSError())
  }

  // MARK: When

  private func when_setupIsCalledOnSubject() {
    presenter.setup(with: mockView)
  }

  private func when_retryOnErrorAlertTapped(answers: RegisterAccountFormAnswers) {
    presenter.retryOnErrorAlertTapped(answers: answers)
  }

  private func when_didTapOnRegisterButton(answers: RegisterAccountFormAnswers) {
    presenter.didTapOnRegisterButton(answers: answers)
  }

  // MARK: Then

  private func then_viewModel_isCorrectlyPassed() {
    let viewModel = try! XCTUnwrap(mockView.viewModel)
    XCTAssertEqual(viewModel.titleLabel, "Register Account")
    XCTAssertEqual(viewModel.nameTextField.title,  "Name")
    XCTAssertEqual(viewModel.nameTextField.highlightTextInTitle,  nil)
    XCTAssertEqual(viewModel.nameTextField.style,  .normal)
    XCTAssertEqual(viewModel.nameTextField.status,  .empty)
    XCTAssertEqual(viewModel.nameTextField.regexAcceptedInput,  Regex.regexForName)
    XCTAssertEqual(viewModel.nameTextField.validation,  .minLength(value: 2, error: "Min 2 characters"))
    XCTAssertEqual(viewModel.nameTextField.showErrorLabel,  true)

    XCTAssertEqual(viewModel.surnameTextField.title, "Surname")
    XCTAssertEqual(viewModel.surnameTextField.highlightTextInTitle, nil)
    XCTAssertEqual(viewModel.surnameTextField.style, .normal)
    XCTAssertEqual(viewModel.surnameTextField.status, .empty)
    XCTAssertEqual(viewModel.surnameTextField.regexAcceptedInput, Regex.regexForName)
    XCTAssertEqual(viewModel.surnameTextField.validation, .minLength(value: 2, error: "Min 2 characters"))
    XCTAssertEqual(viewModel.surnameTextField.showErrorLabel, true)

    XCTAssertEqual(viewModel.usernameTextField.title, "Username")
    XCTAssertEqual(viewModel.usernameTextField.highlightTextInTitle, nil)
    XCTAssertEqual(viewModel.usernameTextField.style, .normal)
    XCTAssertEqual(viewModel.usernameTextField.status, .empty)
    XCTAssertEqual(viewModel.usernameTextField.regexAcceptedInput, Regex.regexForName)
    XCTAssertEqual(viewModel.usernameTextField.validation, .minLength(value: 2, error: "Min 2 characters"))
    XCTAssertEqual(viewModel.usernameTextField.showErrorLabel, true)

    XCTAssertEqual(viewModel.emailTextField.title, "Email")
    XCTAssertEqual(viewModel.emailTextField.highlightTextInTitle, nil)
    XCTAssertEqual(viewModel.emailTextField.style, .normal)
    XCTAssertEqual(viewModel.emailTextField.status, .empty)
    XCTAssertEqual(viewModel.emailTextField.regexAcceptedInput, Regex.regexForAnything)
    XCTAssertEqual(viewModel.emailTextField.validation, .email(error: "Invalid email"))
    XCTAssertEqual(viewModel.emailTextField.showErrorLabel, true)

    XCTAssertEqual(viewModel.confirmEmailTextField.title, "Confirm Email")
    XCTAssertEqual(viewModel.confirmEmailTextField.highlightTextInTitle, nil)
    XCTAssertEqual(viewModel.confirmEmailTextField.style, .normal)
    XCTAssertEqual(viewModel.confirmEmailTextField.status, .empty)
    XCTAssertEqual(viewModel.confirmEmailTextField.regexAcceptedInput, Regex.regexForAnything)
    XCTAssertEqual(viewModel.confirmEmailTextField.validation, .email(error: "Invalid email"))
    XCTAssertEqual(viewModel.confirmEmailTextField.showErrorLabel, true)

    XCTAssertEqual(viewModel.passwordTextField.title, "Password")
    XCTAssertEqual(viewModel.passwordTextField.highlightTextInTitle, nil)
    XCTAssertEqual(viewModel.passwordTextField.style, .normal)
    XCTAssertEqual(viewModel.passwordTextField.status, .empty)
    XCTAssertEqual(viewModel.passwordTextField.regexAcceptedInput, Regex.regexForAnything)
    XCTAssertEqual(viewModel.passwordTextField.validation, .minLength(value: 2, error: "This is not a valid password"))
    XCTAssertEqual(viewModel.passwordTextField.showErrorLabel, true)

    XCTAssertEqual(viewModel.confirmPasswordTextField.title, "Confirm Password")
    XCTAssertEqual(viewModel.confirmPasswordTextField.highlightTextInTitle, nil)
    XCTAssertEqual(viewModel.confirmPasswordTextField.style, .normal)
    XCTAssertEqual(viewModel.confirmPasswordTextField.status, .empty)
    XCTAssertEqual(viewModel.confirmPasswordTextField.regexAcceptedInput, Regex.regexForAnything)
    XCTAssertEqual(viewModel.confirmPasswordTextField.validation, .minLength(value: 2, error: "This is not a valid password"))
    XCTAssertEqual(viewModel.confirmPasswordTextField.showErrorLabel, true)
  }

  private func then_errorIsShown() {
    XCTAssertEqual(mockView.showErrorViewModel?.title, "Attention")
    XCTAssertEqual(mockView.showErrorViewModel?.message, "An error has occured while registering the account")
    XCTAssertEqual(mockView.showErrorViewModel?.retryAction, "Retry")
    XCTAssertEqual(mockView.showErrorViewModel?.cancelAction, "Cancel")
  }

  private func then_errorIsShownForIncorrectFormAnswers() {
    XCTAssertEqual(mockView.showErrorViewModel?.title, "Attention")
    XCTAssertEqual(mockView.showErrorViewModel?.message, "Form is not valid")
    XCTAssertEqual(mockView.showErrorViewModel?.retryAction, "Retry")
    XCTAssertEqual(mockView.showErrorViewModel?.cancelAction, "Cancel")
  }

  private func then_routerDismissIsCalled() {
    XCTAssertTrue(mockRouter.dismissCalled)
  }
}

private class MockRegisterAccountPresentableView: RegisterAccountViewPresentable {
  var className = "MOCK_VIEW"
  var viewModel: RegisterAccountViewModel?
  var updateRegisterButtonEnabled: Bool?
  var showErrorViewModel: RegisterAccountViewErrorViewModel?

  func configure(with viewModel: RegisterAccountViewModel) {
    self.viewModel = viewModel
  }

  func updateRegisterButton(enabled: Bool) {
    updateRegisterButtonEnabled = enabled
  }


  func showError(viewModel: RegisterAccountViewErrorViewModel) {
    showErrorViewModel = viewModel
  }

  func reset() {
    viewModel = nil
    updateRegisterButtonEnabled = nil
    showErrorViewModel = nil
  }

}
