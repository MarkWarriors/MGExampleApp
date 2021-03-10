//
//  EventDetailViewPresenterTests.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import XCTest
import CommonTests
import CommonDomain
@testable import ListModule

final class EventDetailViewPresenterTests: XCTestCase {
  private var mockRouter = MockListModuleRouter()
  private var mockView = MockEventDetailPresentableView()
  private var mockEvent = MockEvent.mock()
  private lazy var presenter: EventDetailViewPresenter = EventDetailViewPresenter(event: mockEvent,
                                                                                  router: mockRouter)

  override func setUp() {
    mockRouter = MockListModuleRouter()
    mockView = MockEventDetailPresentableView()
  }

  func test_viewModel_isCorrectlyPassed_whenSetup_isCalled() {
    when_setupIsCalledOnSubject()
    then_viewModel_isCorrectlyPassed()
  }

  // MARK: Given


  // MARK: When

  private func when_setupIsCalledOnSubject() {
    presenter.setup(with: mockView)
  }

  // MARK: Then

  private func then_viewModel_isCorrectlyPassed() {
    let viewModel = try! XCTUnwrap(mockView.viewModel)
    XCTAssertEqual(viewModel.titleLabel, "Event Name")
    XCTAssertEqual(viewModel.imageUrl, "http://imageUrl")
    XCTAssertEqual(viewModel.priceLabel, "12 £")
    XCTAssertEqual(viewModel.descriptionLabel, "Event Description")
  }
}

private class MockEventDetailPresentableView: EventDetailViewPresentable {
  var className = "MOCK_VIEW"
  var viewModel: EventDetailViewModel?

  func configure(with viewModel: EventDetailViewModel) {
    self.viewModel = viewModel
  }

}
