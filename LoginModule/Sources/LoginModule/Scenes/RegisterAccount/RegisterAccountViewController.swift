//
//  RegisterAccountViewController.swift
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

final class RegisterAccountViewController: UIViewController {
  @IBOutlet private var scrollView: UIScrollView!
  @TitleLabel() @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var nameTextField: RegisterAccountTextField!
  @IBOutlet private var surnameTextField: RegisterAccountTextField!
  @IBOutlet private var usernameTextField: RegisterAccountTextField!
  @IBOutlet private var emailTextField: RegisterAccountTextField!
  @IBOutlet private var confirmEmailTextField: RegisterAccountTextField!
  @IBOutlet private var passwordTextField: RegisterAccountTextField!
  @IBOutlet private var confirmPasswordTextField: RegisterAccountTextField!
  @IBOutlet private var descriptionTextView: UITextView!
  @IBOutlet private var registerButton: UIButton!

  private var activeTextInput: UIView?
  private var currentKeyboardHeight: CGFloat = 0

  private let presenter: RegisterAccountViewPresenterType

  init(presenter: RegisterAccountViewPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: .module)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.setup(with: self)
    style()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerForKeyboardNotifications()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForKeyboardNotifications()
  }

  @objc private func viewTapped() {
    activeTextInput?.resignFirstResponder()
  }

  private func style() {
    titleLabel.font = Fonts.Cyberpunk.h1
    titleLabel.textColor = Colors.primaryText
    registerButton.isEnabled = false
    descriptionTextView.delegate = self
  }

  @IBAction private func didTapOnRegisterButton(sender: AnyObject) {
    guard let answers = getAnswersViewModel() else { return }
    presenter.didTapOnRegisterButton(answers: answers)
  }
}

extension RegisterAccountViewController: RegisterAccountViewPresentable {
  func configure(with viewModel: RegisterAccountViewModel) {
    titleLabel.text = viewModel.titleLabel
    nameTextField.configure(with: viewModel.nameTextField, delegate: self)
    surnameTextField.configure(with: viewModel.surnameTextField, delegate: self)
    usernameTextField.configure(with: viewModel.usernameTextField, delegate: self)
    emailTextField.configure(with: viewModel.emailTextField, delegate: self)
    confirmEmailTextField.configure(with: viewModel.confirmEmailTextField, delegate: self)
    passwordTextField.configure(with: viewModel.passwordTextField, delegate: self)
    confirmPasswordTextField.configure(with: viewModel.confirmPasswordTextField, delegate: self)
  }

  func showError(viewModel: RegisterAccountViewErrorViewModel) {
    let alert = UIAlertController(title: viewModel.title,
                                  message: viewModel.message,
                                  preferredStyle: .alert)

    if let retryActionTitle = viewModel.retryAction {
      let retryAction = UIAlertAction(title: retryActionTitle,
                                      style: .default) { [weak self] _ in
        guard
          let self = self,
          let answers = self.getAnswersViewModel()
        else { return }
        self.presenter.retryOnErrorAlertTapped(answers: answers)
      }
      alert.addAction(retryAction)
    }

    let cancelAction = UIAlertAction(title: viewModel.cancelAction,
                                     style: .cancel)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }

  func updateRegisterButton(enabled: Bool) {
    registerButton.isEnabled = enabled
  }

  func getAnswersViewModel() -> RegisterAccountFormAnswers? {
    guard
      let name = nameTextField.text,
      let surname = surnameTextField.text,
      let username = usernameTextField.text,
      let email = emailTextField.text,
      let confirmEmail = confirmEmailTextField.text,
      let password = passwordTextField.text,
      let confirmPassword = confirmPasswordTextField.text
    else { return nil }

    return RegisterAccountFormAnswers(name: name,
                                      surname: surname,
                                      username: username,
                                      email: email,
                                      confirmEmail: confirmEmail,
                                      password: password,
                                      confirmPassword: confirmPassword)

  }
}

extension RegisterAccountViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    if activeTextInput != textView { activeTextInput = textView }
    return true
  }

  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    if activeTextInput == textView { activeTextInput = nil }
    return true
  }
}

extension RegisterAccountViewController: RegisterAccountTextFieldDelegate {
  func textFieldDidBeginEditing(textField: RegisterAccountTextField) {
    if activeTextInput != textField { activeTextInput = textField }
  }

  func textFieldDidEndEditing(textField: RegisterAccountTextField) {
    if activeTextInput == textField { activeTextInput = nil }
  }

  func textFieldDidChangeInput(textField: RegisterAccountTextField) {
    checkAndSignalFieldsValidity()
  }

  func checkAndSignalFieldsValidity() {
    let allTextfields = [nameTextField, surnameTextField, usernameTextField, emailTextField, confirmEmailTextField, passwordTextField, confirmPasswordTextField].compactMap { $0 }
    let formIsValid = allTextfields.allSatisfy({ $0.textFieldIsValidated() })
    registerButton.isEnabled = formIsValid
  }
}

// Keyboard handling
extension RegisterAccountViewController {
  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  private func unregisterForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    guard
      let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
    else { return }
    adjustScrollForKeyboardShowing(keyboardHeight: keyboardHeight)
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    adjustScrollForKeyboardHiding()

  }

  private func adjustScrollForKeyboardHiding() {
    var newInsets = scrollView.contentInset
    newInsets.bottom -= currentKeyboardHeight
    scrollView.contentInset = newInsets
    scrollView.scrollIndicatorInsets = newInsets
    currentKeyboardHeight = 0
  }

  private func adjustScrollForKeyboardShowing(keyboardHeight: CGFloat) {
    guard
      let textInput = activeTextInput
    else { return }

    if currentKeyboardHeight != keyboardHeight {
      var newInsets = scrollView.contentInset
      newInsets.bottom += (keyboardHeight - currentKeyboardHeight)
      scrollView.contentInset = newInsets
      scrollView.scrollIndicatorInsets = newInsets
    }
    currentKeyboardHeight = keyboardHeight

    var currentFrame = view.frame
    currentFrame.size.height -= keyboardHeight

    if !currentFrame.contains(textInput.frame.origin) {
      scrollView.scrollRectToVisible(textInput.frame, animated: true)
    }
  }

}

extension RegisterAccountViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//    guard touch.view is CheckBox || touch.view is RadioButton else {
//      return true
//    }
//    activeTextInput?.resignFirstResponder()
    return true
  }
}
