//
//  RegisterAccountViewModelFactory.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import Foundation
import CommonStrings

struct RegisterAccountViewModelFactory {
  typealias Strings = ModuleStrings.Scenes.RegisterAccount

  func createInitialViewModel() -> RegisterAccountViewModel {
    typealias FormStrings = Strings.Form
    let nameTextField = RegisterAccountTextFieldViewModel(title: FormStrings.Name.title,
                                                          highlightTextInTitle: nil,
                                                          style: .normal,
                                                          status: .empty,
                                                          regexAcceptedInput: Regex.regexForName,
                                                          validation: .minLength(value: 2, error: FormStrings.Name.error),
                                                          showErrorLabel: true)

    let surnameTextField = RegisterAccountTextFieldViewModel(title: FormStrings.Surname.title,
                                                             highlightTextInTitle: nil,
                                                             style: .normal,
                                                             status: .empty,
                                                             regexAcceptedInput: Regex.regexForName,
                                                             validation: .minLength(value: 2, error: FormStrings.Surname.error),
                                                             showErrorLabel: true)

    let usernameTextField = RegisterAccountTextFieldViewModel(title: FormStrings.Username.title,
                                                              highlightTextInTitle: nil,
                                                              style: .normal,
                                                              status: .empty,
                                                              regexAcceptedInput: Regex.regexForName,
                                                              validation: .minLength(value: 2, error: FormStrings.Username.error),
                                                              showErrorLabel: true)

    let emailTextField = RegisterAccountTextFieldViewModel(title: FormStrings.Email.title,
                                                           highlightTextInTitle: nil,
                                                           style: .normal,
                                                           status: .empty,
                                                           regexAcceptedInput: Regex.regexForAnything,
                                                           validation: .email(error: FormStrings.Email.error),
                                                           showErrorLabel: true)

    let confirmEmailTextField = RegisterAccountTextFieldViewModel(title: FormStrings.ConfirmEmail.title,
                                                                  highlightTextInTitle: nil,
                                                                  style: .normal,
                                                                  status: .empty,
                                                                  regexAcceptedInput: Regex.regexForAnything,
                                                                  validation: .email(error: FormStrings.ConfirmEmail.error),
                                                                  showErrorLabel: true)

    let passwordTextField = RegisterAccountTextFieldViewModel(title: FormStrings.Password.title,
                                                              highlightTextInTitle: nil,
                                                              style: .normal,
                                                              status: .empty,
                                                              regexAcceptedInput: Regex.regexForAnything,
                                                              validation: .minLength(value: 2, error: FormStrings.Password.error),
                                                              showErrorLabel: true)

    let confirmPasswordTextField =  RegisterAccountTextFieldViewModel(title: FormStrings.ConfirmPassword.title,
                                                                      highlightTextInTitle: nil,
                                                                      style: .normal,
                                                                      status: .empty,
                                                                      regexAcceptedInput: Regex.regexForAnything,
                                                                      validation: .minLength(value: 2, error: FormStrings.ConfirmPassword.error),
                                                                      showErrorLabel: true)

    return RegisterAccountViewModel(titleLabel: Strings.title,
                                    nameTextField: nameTextField,
                                    surnameTextField: surnameTextField,
                                    usernameTextField: usernameTextField,
                                    emailTextField: emailTextField,
                                    confirmEmailTextField: confirmEmailTextField,
                                    passwordTextField: passwordTextField,
                                    confirmPasswordTextField: confirmPasswordTextField)
  }

  func createInvalidFormErrorViewModel() -> RegisterAccountViewErrorViewModel {
    return RegisterAccountViewErrorViewModel(title: CommonStrings.Alert.attention,
                                             message: Strings.Errors.formNotValid,
                                             retryAction: CommonStrings.Actions.retryActionTitle,
                                             cancelAction: CommonStrings.Actions.cancelActionTitle)
  }

  func createRegistrationErrorViewModel() -> RegisterAccountViewErrorViewModel {
    return RegisterAccountViewErrorViewModel(title: CommonStrings.Alert.attention,
                                             message: Strings.Errors.errorRegisteringAccount,
                                             retryAction: CommonStrings.Actions.retryActionTitle,
                                             cancelAction: CommonStrings.Actions.cancelActionTitle)
  }
}

struct Regex {
  static let regexForAnything = ".{0,}"
  static let regexForEmail = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{0,64}$"
  static let regexForPassword = ".{0,64}"
  // Regex check any alphanumeric or - _ ' ‘ ’ . , symbol and max 256 chars
  static let regexForName = "^[a-zA-Z0-9\\s-_'‘’.,]{0,256}$"
  // Regex check if there are numbers have 0 to 16 digits
  static let regexForCardNumber = "^\\d{0,16}$"
  // Regex check if string is empty or have 0 or 1 as first number
  // then if is 0 check if the second number is between 1 to 9
  // else if is 1 check if the second number is 0, 1 or 2 (so we cover all the months from 01 to 12
  // after that it check if there is nothing, another number or 2 others number (numbers for year)
  static let regexForExpiryDate = "^(0|1){0,1}$|^((0[1-9]|1[012])([0-9]{0,2}))$"
  // Regex check if there are numbers have 0 to 3 digits
  static let regexForCVV = "^\\d{0,3}$"
  // Regex check max length 256
  static let regexForAddressLine = "^.{0,256}$"
  // Regex check max length 60
  static let regexForTown = "^.{0,60}$"
  // Regex check max length 10
  static let regexForPostcode = "^.{0,10}$"
}
