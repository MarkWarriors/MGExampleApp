//
//  LoginViewContract.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonComponents
import CommonDomain

protocol LoginViewPresentable: Trackable {
  func configure(with viewModel: LoginViewModel)
  func showError(viewModel: LoginViewErrorViewModel)
  func updateLoginButton(enabled: Bool)
}

protocol LoginViewPresenterType {
  func setup(with view: LoginViewPresentable)
  func userInsertText(username: String, password: String)
  func retryOnErrorAlertTapped(username: String, password: String)
  func loginButtonTapped(username: String, password: String)
  func registerButtonTapped()
}

struct LoginViewModel {
  let imageOnTop: UIImage
  let titleLabel: String
  let usernameTextView: InputText
  let passwordTextView: InputText
  let loginButton: Button
  let registerAccountButton: Button

  struct Button {
    let title: String
    let tapable: Bool
  }

  struct InputText {
    let text: String
    let placeholder: String
    let state: State

    enum State {
      case normal
      case error
    }
  }
}

struct LoginViewErrorViewModel {
  let title: String
  let message: String
  let retryAction: String?
  let cancelAction: String
}
