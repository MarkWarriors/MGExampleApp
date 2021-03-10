//
//  LoginViewSnapshotTests.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import SnapshotTesting
import XCTest
import CommonUI
import CommonDomain
@testable import LoginModule

private class MockLoginViewPresenter: LoginViewPresenterType {

  func setup(with view: LoginViewPresentable) {
    view.configure(with: LoginViewModel(imageOnTop: Images.logo,
                                        titleLabel: "Login",
                                        usernameTextView: LoginViewModel.InputText(text: "", placeholder: "Username", state: .normal),
                                        passwordTextView: LoginViewModel.InputText(text: "", placeholder: "Password", state: .normal),
                                        loginButton: LoginViewModel.Button(title: "Login", tapable: false),
                                        registerAccountButton: LoginViewModel.Button(title: "Register", tapable: true)))
  }

  func userInsertText(username: String, password: String) {}

  func loginButtonTapped(username: String, password: String) {}

  func registerButtonTapped() {}

  func retryOnErrorAlertTapped(username: String, password: String) {}
}

class LoginViewSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    CommonUI.initializeFonts()
//    isRecording = true
  }

  func test_LoginViewController() {
    let vc = LoginViewController(presenter: MockLoginViewPresenter())
    assertSnapshot(matching: vc, as: .image)
  }
}
