//
//  ListViewPresenterTests.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import XCTest
import CommonDomain
import CommonTests
@testable import ListModule

final class ListViewPresenterTests: XCTestCase {
  private var mockRouter:  MockListModuleRouter!
  private var mockView: MockListPresentableView!
  private var mockEventsListUseCase: MockEventsListUseCase!
  private var presenter: ListViewPresenter!

  override func setUp() {
    mockView = MockListPresentableView()
    mockEventsListUseCase = MockEventsListUseCase()
    mockRouter = MockListModuleRouter()
    presenter = ListViewPresenter(eventsListUseCase: mockEventsListUseCase, router: mockRouter)
  }

  func test_viewModel_isCorrectlyPassed_whenSetup_isCalled() {
    when_setupIsCalledOnSubject()
    then_viewModel_isCorrectlyPassed()
  }

  func test_retryOnErrorAlertTapped_then_correctEventIsReceived() {
    given_setupHasBeenCalled()
    given_eventsUseCase_setupAsSuccessWithEvents()
    when_retryOnErrorAlertTapped()
    then_startLoadingIsCalled()
    then_endLoadingIsCalled()
    then_correctEventIsReceived()
  }

  func test_userPulledToRefreshIsCalled_then_correctEventIsReceived() {
    given_setupHasBeenCalled()
    given_eventsUseCase_setupAsSuccessWithEvents()
    when_userPulledToRefreshIsCalled()
    then_startLoadingIsCalled()
    then_endLoadingIsCalled()
    then_correctEventIsReceived()
  }

  func test_eventsUseCase_setupAsFailure_then_errorIsShown() {
    given_eventsUseCase_setupAsFailure()
    when_setupIsCalledOnSubject()
    then_startLoadingIsCalled()
    then_endLoadingIsCalled()
    then_errorIsShown()
  }

  func test_eventsUseCase_setupAsSuccessWithNoEvents_then_noNextEventsIsShown() {
    given_eventsUseCase_setupAsSuccessWithNoEvents()
    when_setupIsCalledOnSubject()
    then_startLoadingIsCalled()
    then_endLoadingIsCalled()
    then_noNextEventsIsShown()
  }

  func test_eventsUseCase_setupAsSuccessWithEvents_then_correctEventIsReceived() {
    given_eventsUseCase_setupAsSuccessWithEvents()
    when_setupIsCalledOnSubject()
    then_startLoadingIsCalled()
    then_endLoadingIsCalled()
    then_correctEventIsReceived()
  }

  func test_didTapOnEventIsCalled_then_routerPresentEventDetails() {
    given_setupHasBeenCalled()
    when_didTapOnEventIsCalled()
    then_routerPresentEventDetails()
  }

  // MARK: Given

  private func given_setupHasBeenCalled() {
    presenter.setup(with: mockView)
    mockView.reset()
  }

  private func given_eventsUseCase_setupAsSuccessWithEvents() {
    mockEventsListUseCase.resultToReturn = .success([MockEvent.mock(id: "anId"),
                                                     MockEvent.mock(id: "anotherId")])
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

  private func when_userPulledToRefreshIsCalled() {
    presenter.userPulledToRefresh()
  }

  private func when_didTapOnEventIsCalled() {
    presenter.didTapOnEvent(MockEvent.mock())
  }

  // MARK: Then

  private func then_viewModel_isCorrectlyPassed() {
    let viewModel = try! XCTUnwrap(mockView.viewModel)
    XCTAssertEqual(viewModel.titleLabel, "Events")
  }

  private func then_startLoadingIsCalled() {
    XCTAssertTrue(mockView.startLoadingCalled)
  }

  private func then_endLoadingIsCalled() {
    XCTAssertTrue(mockView.endLoadingCalled)
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
    XCTAssertEqual(mockView.updateEvents?.count, 2)
    XCTAssertEqual(mockView.updateEvents?[0], MockEvent.mock(id: "anId"))
    XCTAssertEqual(mockView.updateEvents?[1], MockEvent.mock(id: "anotherId"))
  }

  private func then_routerPresentEventDetails() {
    XCTAssertTrue(mockRouter.presentEventDetailsCalled)
  }
}

private class MockListPresentableView: ListViewPresentable {
  var className = "MOCK_VIEW"
  var viewModel: ListViewModel?
  var updateEvents: [Event]?
  var showErrorViewModel: ListViewErrorViewModel?
  var startLoadingCalled = false
  var endLoadingCalled = false

  func configure(with viewModel: ListViewModel) {
    self.viewModel = viewModel
  }

  func update(with events: [Event]) {
    updateEvents = events
  }

  func startLoading() {
    startLoadingCalled = true
  }

  func endLoading() {
    endLoadingCalled = true
  }

  func showError(viewModel: ListViewErrorViewModel) {
    showErrorViewModel = viewModel
  }

  func reset() {
    viewModel = nil
    updateEvents = nil
    showErrorViewModel = nil
    startLoadingCalled = false
    endLoadingCalled = false
  }
}

