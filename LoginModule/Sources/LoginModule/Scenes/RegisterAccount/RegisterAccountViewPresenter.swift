//
//  RegisterAccountViewPresenter.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import CommonUI
import CommonDomain

final class RegisterAccountViewPresenter: RegisterAccountViewPresenterType {
  private let registerAccountUseCase: RegisterAccountUseCaseType
  private let viewModelFactory: RegisterAccountViewModelFactory
  private weak var router: LoginModuleRouterType?

  private weak var view: RegisterAccountViewPresentable?

  init(registerAccountUseCase: RegisterAccountUseCaseType,
       router: LoginModuleRouterType) {
    self.registerAccountUseCase = registerAccountUseCase
    self.router = router
    self.viewModelFactory = RegisterAccountViewModelFactory()
  }

  func setup(with view: RegisterAccountViewPresentable) {
    self.view = view
    view.configure(with: viewModelFactory.createInitialViewModel())
  }

  func retryOnErrorAlertTapped(answers: RegisterAccountFormAnswers) {
    registerNewAccount(answers: answers)
  }

  func formHasChanged(allFieldsAreValid: Bool) {
    view?.updateRegisterButton(enabled: allFieldsAreValid)
  }

  func didTapOnRegisterButton(answers: RegisterAccountFormAnswers) {
    registerNewAccount(answers: answers)
  }

  private func validForm(answers: RegisterAccountFormAnswers) -> Bool {
    guard
      answers.email.count > 3,
      answers.password.count > 2,
      answers.confirmEmail == answers.email,
      answers.confirmPassword == answers.password,
      answers.name.count > 2,
      answers.surname.count > 2,
      answers.username.count > 2
    else {
      // TODO: Handle each failure case with correct message and add correct validation
      return false
    }

    return true
  }

  private func registerNewAccount(answers: RegisterAccountFormAnswers) {
    guard validForm(answers: answers) else {
      view?.showError(viewModel: viewModelFactory.createInvalidFormErrorViewModel())
      return
    }
    
    registerAccountUseCase.fetch { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success:
        self.router?.dismiss()
      case .failure:
        self.view?.showError(viewModel: self.viewModelFactory.createRegistrationErrorViewModel())
        break
      }
    }
  }

}
