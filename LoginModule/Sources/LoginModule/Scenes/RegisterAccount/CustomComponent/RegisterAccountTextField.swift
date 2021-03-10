//
//  RegisterAccountTextField.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonComponents

struct RegisterAccountTextFieldViewModel {
  let title: String
  let highlightTextInTitle: String?
  let style: InputStyle
  let status: Status
  let regexAcceptedInput: String
  let validation: Validation
  let showErrorLabel: Bool

  enum InputStyle: Equatable {
    case normal
    case customWith(separator: String, afterNumberOfDigits: Int)
  }

  enum Status: Equatable {
    case error(message: String)
    case focussed
    case valid
    case empty
  }

  enum Validation: Equatable {
    case noValidation
    case email(error: String)
    case minLength(value: Int, error: String)
    case exactLength(value: Int, error: String)
    case dateBoundaries(minDate: Date, maxDate: Date, error: String)
  }
}

@objc protocol RegisterAccountTextFieldDelegate: AnyObject {
  @objc optional func textFieldDidChangeInput(textField: RegisterAccountTextField)
  @objc optional func textFieldDidEndEditing(textField: RegisterAccountTextField)
  @objc optional func textFieldDidBeginEditing(textField: RegisterAccountTextField)
  @objc optional func textFieldShouldEndEditing(textField: RegisterAccountTextField) -> Bool
  @objc optional func textFieldShouldBeginEditing(textField: RegisterAccountTextField) -> Bool
}

final class RegisterAccountTextField: UITextField, UITextFieldDelegate {
  private weak var textFieldDelegate: RegisterAccountTextFieldDelegate?

  private let errorLabel = UILabel()
  private var regex: String?
  private var validation: RegisterAccountTextFieldViewModel.Validation?
  private var status: RegisterAccountTextFieldViewModel.Status = .empty
  private var inputStyle: RegisterAccountTextFieldViewModel.InputStyle?

  override func awakeFromNib() {
    super.awakeFromNib()
    style()
  }

  private func style() {
    styleErrorView()
    layer.borderWidth = 1.5
    layer.cornerRadius = 8
    textColor = .black
  }

  private func styleErrorView() {
    addSubview(errorLabel)
    clipsToBounds = false
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    errorLabel.textColor = .red
    errorLabel.font = UIFont.systemFont(ofSize: 8)
    NSLayoutConstraint.activate([
      errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
      rightAnchor.constraint(equalTo: errorLabel.rightAnchor, constant: 2),
      errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 2),
      errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
    ])
  }

  func configure(with viewModel: RegisterAccountTextFieldViewModel, delegate: RegisterAccountTextFieldDelegate) {
    self.delegate = self
    self.textFieldDelegate = delegate
    inputStyle = viewModel.style
    regex = viewModel.regexAcceptedInput
    validation = viewModel.validation
    status = viewModel.status
    errorLabel.isHidden = !viewModel.showErrorLabel
    updateUIForCurrentStatus()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    status = .focussed
    updateUIForCurrentStatus()
    textFieldDelegate?.textFieldDidBeginEditing?(textField: self)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    validateInput()
    updateUIForCurrentStatus()
    textFieldDelegate?.textFieldDidEndEditing?(textField: self)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return textFieldDelegate?.textFieldShouldBeginEditing?(textField: self) ?? true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return textFieldDelegate?.textFieldShouldEndEditing?(textField: self) ?? true
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let oldText = textField.text as NSString?, let inputType = self.inputStyle else { return true }
    let newText = oldText.replacingCharacters(in: range, with: string)
    var textToShow: String
    switch inputType {
    case .normal:
      textToShow = textToBeShownInTextField(text: newText)
    case let .customWith(separator, afterNumberOfDigits):
      textToShow = textToBeShownInTextField(newText, with: separator, every: afterNumberOfDigits)
    }

    if textField.text == textToShow {
      Haptic.selection.generate(prepareForReuse: true)
    } else {
      textField.text = textToShow
    }
    validateInput()
    textFieldDelegate?.textFieldDidChangeInput?(textField: self)
    return false
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func textFieldIsValidated() -> Bool {
    return status == .valid
  }

  override func closestPosition(to point: CGPoint) -> UITextPosition? {
    guard let inputStyle = self.inputStyle, inputStyle != .normal else {
      return super.closestPosition(to: point)
    }
    let beginning = self.beginningOfDocument
    let end = self.position(from: beginning, offset: self.text?.count ?? 0)
    return end
  }

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    guard let inputStyle = self.inputStyle, inputStyle != .normal else {
      return super.canPerformAction(action, withSender: sender)
    }
    if [#selector(selectAll(_:)), #selector(select(_:))].contains(action) {
      return super.canPerformAction(action, withSender: sender)
    }
    return false
  }

  private func validateInput() {
    guard let validation = validation else {
      status = .valid
      return
    }
    let text: String
    switch inputStyle {
    case let .customWith(separator, _):
      text = self.text?.replacingOccurrences(of: separator, with: "") ?? ""
    default:
      text = self.text ?? ""
    }

    switch validation {
    case let .email(error):
      status = isValidEmail(text) ? .valid : .error(message: error)
    case let .exactLength(value, error):
      status = text.count == value ? .valid : .error(message: error)
    case let .minLength(value, error):
      status = text.count >= value ? .valid : .error(message: error)
    case let .dateBoundaries(minDate, maxDate, error):
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMyy"
      if let insertedDate = dateFormatter.date(from: text), text.count == 4, insertedDate >= minDate && insertedDate < maxDate {
        status = .valid
      } else {
        status = .error(message: error)
      }
    case .noValidation:
      status = .valid
    }
  }

  private func isValidEmail(_ mail: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: mail)
  }

  private func textToBeShownInTextField(text: String) -> String {
    return matchRegex(text: text) ? text: (self.text ?? "")
  }

  private func textToBeShownInTextField(_ text: String, with separator: String, every numberOfDigits: Int) -> String {
    let textRemovingStyle = text.replacingOccurrences(of: separator, with: "")
    guard matchRegex(text: textRemovingStyle) else { return (self.text ?? "") }
    return split(string: textRemovingStyle, by: numberOfDigits).joined(separator: separator)
  }

  private func matchRegex(text: String) -> Bool {
    guard let regex = self.regex else { return true }
    let range = NSRange(location: 0, length: text.count)
    let expression = try? NSRegularExpression(pattern: regex)
    return expression?.firstMatch(in: text, options: [], range: range) != nil
  }

  private func split(string: String, by length: Int) -> [String] {
    var startIndex = string.startIndex
    var results: [Substring] = []
    while startIndex < string.endIndex {
      let endIndex = string.index(startIndex, offsetBy: length, limitedBy: string.endIndex) ?? string.endIndex
      results.append(string[startIndex..<endIndex])
      startIndex = endIndex
    }
    return results.map { String($0) }
  }

  private func updateUIForCurrentStatus() {
    let color: UIColor
    let errorMessage: String
    switch status {
    case let .error(message):
      color = .red
      errorMessage = message
    case .focussed:
      color = .black
      errorMessage = ""
    case .valid, .empty:
      color = UIColor.clear
      errorMessage = ""
    }
    if !errorLabel.isHidden { errorLabel.text = errorMessage }
    layer.borderColor = color.cgColor
    tintColor = color
  }
}
