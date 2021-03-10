//
//  RegisterAccountViewContract.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonComponents
import CommonDomain

protocol RegisterAccountViewPresentable: Trackable {
  func configure(with viewModel: RegisterAccountViewModel)
  func showError(viewModel: RegisterAccountViewErrorViewModel)
  func updateRegisterButton(enabled: Bool)
}

protocol RegisterAccountViewPresenterType {
  func setup(with view: RegisterAccountViewPresentable)
  func retryOnErrorAlertTapped(answers: RegisterAccountFormAnswers)
  func formHasChanged(allFieldsAreValid: Bool)
  func didTapOnRegisterButton(answers: RegisterAccountFormAnswers)
}

struct RegisterAccountViewModel {
  let titleLabel: String
  let nameTextField: RegisterAccountTextFieldViewModel
  let surnameTextField: RegisterAccountTextFieldViewModel
  let usernameTextField: RegisterAccountTextFieldViewModel
  let emailTextField: RegisterAccountTextFieldViewModel
  let confirmEmailTextField: RegisterAccountTextFieldViewModel
  let passwordTextField: RegisterAccountTextFieldViewModel
  let confirmPasswordTextField: RegisterAccountTextFieldViewModel
}

struct RegisterAccountViewErrorViewModel {
  let title: String
  let message: String
  let retryAction: String?
  let cancelAction: String
}

struct RegisterAccountFormAnswers {
  let name: String
  let surname: String
  let username: String
  let email: String
  let confirmEmail: String
  let password: String
  let confirmPassword: String
}
