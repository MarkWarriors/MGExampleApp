//
//  RegisterAccountViewSnapshotTests.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import SnapshotTesting
import XCTest
import CommonUI
import CommonDomain
@testable import LoginModule

private class MockRegisterAccountViewPresenter: RegisterAccountViewPresenterType {

  func setup(with view: RegisterAccountViewPresentable) {
    view.configure(with: RegisterAccountViewModelFactory().createInitialViewModel())
  }

  func retryOnErrorAlertTapped(answers: RegisterAccountFormAnswers) {}

  func formHasChanged(allFieldsAreValid: Bool) { }

  func didTapOnRegisterButton(answers: RegisterAccountFormAnswers) { }
}

class RegisterAccountViewSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    CommonUI.initializeFonts()
//    isRecording = true
  }

  func test_RegisterAccountViewController() {
    let vc = RegisterAccountViewController(presenter: MockRegisterAccountViewPresenter())
    assertSnapshot(matching: vc, as: .image)
  }
}
