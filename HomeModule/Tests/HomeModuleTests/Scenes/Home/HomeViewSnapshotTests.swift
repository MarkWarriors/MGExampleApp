//
//  HomeViewSnapshotTests.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import SnapshotTesting
import XCTest
import CommonUI
import CommonDomain
@testable import HomeModule

private class MockHomeViewPresenter: HomeViewPresenterType {
  func setup(with view: HomeViewPresentable) {
    view.configure(with: HomeViewModel(navBarTitle: "Title",
                                       imageOnTop: Images.logo,
                                       titleLabel: "Title label",
                                       descriptionLabel: "Description Label",
                                       specialLabel: "Special Label",
                                       nextEventTitleLabel: "Next Event Title Label"))
    view.showNextEventInfo(MockEvent.mock())
  }

  func retryOnErrorAlertTapped() {}
}

class HomeViewSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    CommonUI.initializeFonts()
    //    isRecording = true
  }

  func test_HomeViewController() {
    let vc = HomeViewController(presenter: MockHomeViewPresenter())
    assertSnapshot(matching: vc, as: .image)
  }
}
