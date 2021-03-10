//
//  ListViewSnapshotTests.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import SnapshotTesting
import XCTest
import CommonUI
import CommonDomain
@testable import ListModule

private class MockListViewPresenter: ListViewPresenterType {
  func setup(with view: ListViewPresentable) {
    CommonUI.initializeFonts()
    view.configure(with: ListViewModel(navBarTitle: "Title",
                                       imageOnTop: Images.logoInline,
                                       titleLabel: "Title label"))
    view.update(with: [MockEvent.mock(),
                       MockEvent.mock(),
                       MockEvent.mock(),
                       MockEvent.mock(),
                       MockEvent.mock(),
                       MockEvent.mock()])
  }

  func didTapOnEvent(_ event: Event) {}

  func userPulledToRefresh() {}

  func retryOnErrorAlertTapped() {}

}

class ListViewSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    CommonUI.initializeFonts()
    //    isRecording = true
  }

  func test_ListViewController() {
    let vc = ListViewController(presenter: MockListViewPresenter())
    assertSnapshot(matching: vc, as: .image)
  }
}
