//
//  HomeViewPresenterTests.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import XCTest
import CommonTests
import CommonDomain
@testable import HomeModule

final class HomeViewPresenterTests: XCTestCase {
  private var mockRouter: MockHomeModuleRouter!
  private var mockView: MockHomePresentableView!
  private var mockEventsListUseCase: MockEventsListUseCase!
  private var presenter: HomeViewPresenter!

  override func setUp() {
    mockView = MockHomePresentableView()
    mockEventsListUseCase = MockEventsListUseCase()
    mockRouter = MockHomeModuleRouter()
    presenter = HomeViewPresenter(eventsListUseCase: mockEventsListUseCase, router: mockRouter)
  }

  func test_viewModel_isCorrectlyPassed_whenSetup_isCalled() {
    when_setupIsCalledOnSubject()
    then_viewModel_isCorrectlyPassed()
  }

  func test_eventsUseCase_setupAsFailure_then_errorIsShown() {
    given_eventsUseCase_setupAsFailure()
    when_setupIsCalledOnSubject()
    then_errorIsShown()
  }

  func test_eventsUseCase_setupAsSuccessWithNoEvents_then_noNextEventsIsShown() {
    given_eventsUseCase_setupAsSuccessWithNoEvents()
    when_setupIsCalledOnSubject()
    then_noNextEventsIsShown()
  }

  func test_eventsUseCase_setupAsSuccessWithEvents_then_correctEventIsReceived() {
    given_eventsUseCase_setupAsSuccessWithEvents()
    when_setupIsCalledOnSubject()
    then_correctEventIsReceived()
  }

  func test_retryOnErrorAlertTapped_then_correctEventIsReceived() {
    given_setupHasBeenCalledOnSubject()
    given_eventsUseCase_setupAsSuccessWithEvents()
    when_retryOnErrorAlertTapped()
    then_correctEventIsReceived()
  }

  // MARK: Given

  private func given_setupHasBeenCalledOnSubject() {
    presenter.setup(with: mockView)
    mockView.reset()
  }

  private func given_eventsUseCase_setupAsSuccessWithEvents() {
    mockEventsListUseCase.resultToReturn = .success([MockEvent.mock()])
  }

  private func given_eventsUseCase_setupAsSuccessWithNoEvents() {
    mockEventsListUseCase.resultToReturn = .success([])
  }

  private func given_eventsUseCase_setupAsFailure() {
    mockEventsListUseCase.resultToReturn = .failure(NSError())
  }

  // MARK: When

  private func when_setupIsCalledOnSubject() {
    presenter.setup(with: mockView)
  }

  private func when_retryOnErrorAlertTapped() {
    presenter.retryOnErrorAlertTapped()
  }

  // MARK: Then

  private func then_viewModel_isCorrectlyPassed() {
    let viewModel = try! XCTUnwrap(mockView.viewModel)
    XCTAssertEqual(viewModel.titleLabel, "Home")
    XCTAssertEqual(viewModel.specialLabel, "This is a very special label")
    XCTAssertEqual(viewModel.nextEventTitleLabel, "Next Art Event:")
    XCTAssertEqual(viewModel.descriptionLabel, "This is a description label")
  }

  private func then_errorIsShown() {
    XCTAssertEqual(mockView.showErrorViewModel?.title, "Attention")
    XCTAssertEqual(mockView.showErrorViewModel?.message, "Unexpected error")
    XCTAssertEqual(mockView.showErrorViewModel?.retryAction, "Retry")
    XCTAssertEqual(mockView.showErrorViewModel?.cancelAction, "Cancel")
  }

  private func then_noNextEventsIsShown() {
    XCTAssertEqual(mockView.showErrorViewModel?.title, "Attention")
    XCTAssertEqual(mockView.showErrorViewModel?.message, "No events in the near future")
    XCTAssertNil(mockView.showErrorViewModel?.retryAction)
    XCTAssertEqual(mockView.showErrorViewModel?.cancelAction, "Ok")
  }

  private func then_correctEventIsReceived() {
    XCTAssertNil(mockView.showErrorViewModel)
    XCTAssertEqual(mockView.showNextEventInfo, MockEvent.mock())
  }
}

private class MockHomePresentableView: HomeViewPresentable {

  var className = "MOCK_VIEW"
  var viewModel: HomeViewModel?
  var showNextEventInfo: Event?
  var showErrorViewModel: HomeViewErrorViewModel?

  func configure(with viewModel: HomeViewModel) {
    self.viewModel = viewModel
  }

  func showNextEventInfo(_ event: Event) {
    showNextEventInfo = event
  }

  func showError(viewModel: HomeViewErrorViewModel) {
    showErrorViewModel = viewModel
  }

  func reset() {
    viewModel = nil
    showNextEventInfo = nil
    showErrorViewModel = nil
  }

}
