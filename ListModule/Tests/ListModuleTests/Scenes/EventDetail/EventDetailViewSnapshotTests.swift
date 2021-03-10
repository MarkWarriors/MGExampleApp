//
//  EventDetailViewSnapshotTests.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import SnapshotTesting
import XCTest
import CommonUI
@testable import ListModule

private class MockEventDetailViewPresenter: EventDetailViewPresenterType {
  func setup(with view: EventDetailViewPresentable) {
    view.configure(with: EventDetailViewModel(imageUrl: "http://imageUrl",
                                              titleLabel: "Title label",
                                              descriptionLabel: "Description Label",
                                              priceLabel: "12£"))
  }
}

class EventDetailViewSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    CommonUI.initializeFonts()
//    isRecording = true
  }

  func test_EventDetailViewController() {
    let vc = EventDetailViewController(presenter: MockEventDetailViewPresenter())
    assertSnapshot(matching: vc, as: .image)
  }
}
