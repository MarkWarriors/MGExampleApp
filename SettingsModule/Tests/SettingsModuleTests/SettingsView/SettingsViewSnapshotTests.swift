//
//  SettingsViewSnapshotTests.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import SnapshotTesting
import XCTest
import CommonUI
@testable import SettingsModule

private class MockSettingsViewPresenter: SettingsViewPresenterType {
  func logoutButtonTapped() {}

  func setup(with view: SettingsViewPresentable) {
    view.configure(with: SettingsViewModel(navBarTitle: "Settings",
                                           logoutButtonTitle: "Logout Button"))
  }
}

class SettingsViewSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    CommonUI.initializeFonts()
//    isRecording = true
  }

  func test_SettingsViewController() {
    let vc = SettingsViewController(presenter: MockSettingsViewPresenter())
    assertSnapshot(matching: vc, as: .image)
  }
}
