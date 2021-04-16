//
//  LoginViewController.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonUI
import Networking
import CommonDomain
import CommonComponents
import CommonStrings
import AuthenticationServices

final class LoginViewController: UIViewController {
  @TitleLabel() @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var logoImageView: UIImageView!
  @IBOutlet private var usernameTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var loginButton: UIButton!
  @IBOutlet private var signInWithAppleButton: ASAuthorizationAppleIDButton!
  @IBOutlet private var registerAccountButton: UIButton!
  
  private let presenter: LoginViewPresenterType
  
  private var activeTextInput: UIView?
  
  init(presenter: LoginViewPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: .module)
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
    presenter.setup(with: self)
    configureOutlets()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func viewTapped() {
    activeTextInput?.resignFirstResponder()
  }
  
  private func configureOutlets() {
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    signInWithAppleButton.addTarget(self, action: #selector(signInWithAppleButtonTapped), for: .touchUpInside)
  }
  
  @IBAction private func loginButtonTapped(sender: AnyObject) {
    guard
      let username = usernameTextField.text,
      let password = passwordTextField.text
    else { return }
    presenter.loginButtonTapped(username: username,
                                password: password)
  }

  @objc private func signInWithAppleButtonTapped() {
    presenter.signInWithAppleButtonTapped(context: self)
  }
  
  @IBAction private func registerButtonTapped(sender: AnyObject) {
    presenter.registerButtonTapped()
  }
}

extension LoginViewController: LoginViewPresentable {
  func configure(with viewModel: LoginViewModel) {
    titleLabel.text = viewModel.titleLabel
    logoImageView.image = viewModel.imageOnTop
    usernameTextField.text = viewModel.usernameTextView.text
    usernameTextField.placeholder = viewModel.usernameTextView.placeholder
    passwordTextField.text = viewModel.passwordTextView.text
    passwordTextField.placeholder = viewModel.passwordTextView.placeholder
    loginButton.setTitle(viewModel.loginButton.title, for: .normal)
    loginButton.isEnabled = viewModel.loginButton.tapable
    registerAccountButton.setTitle(viewModel.registerAccountButton.title, for: .normal)
    registerAccountButton.isEnabled = viewModel.registerAccountButton.tapable
  }
  
  func updateLoginButton(enabled: Bool) {
    loginButton.isEnabled = enabled
  }
  
  func showError(viewModel: LoginViewErrorViewModel) {
    let alert = UIAlertController(title: viewModel.title,
                                  message: viewModel.message,
                                  preferredStyle: .alert)
    
    if let retryActionTitle = viewModel.retryAction {
      let retryAction = UIAlertAction(title: retryActionTitle,
                                      style: .default) { [weak self] _ in
        guard
          let self = self,
          let username = self.usernameTextField.text,
          let password = self.passwordTextField.text
        else { return }
        self.presenter.retryOnErrorAlertTapped(username: username,
                                               password: password)
      }
      alert.addAction(retryAction)
    }
    
    let cancelAction = UIAlertAction(title: viewModel.cancelAction,
                                     style: .cancel)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let oldText = textField.text as NSString? else { return true }
    let newText = oldText.replacingCharacters(in: range, with: string)
    if textField == usernameTextField {
      presenter.userInsertText(username: newText, password: passwordTextField.text ?? "")
    } else {
      presenter.userInsertText(username: usernameTextField.text ?? "", password: newText)
    }
    
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if activeTextInput != textField { activeTextInput = textField }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if activeTextInput == textField { activeTextInput = nil }
  }
}

extension LoginViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    //    guard touch.view is CheckBox || touch.view is RadioButton else {
    //      return true
    //    }
    //    activeTextInput?.resignFirstResponder()
    //    return false
    return true
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
