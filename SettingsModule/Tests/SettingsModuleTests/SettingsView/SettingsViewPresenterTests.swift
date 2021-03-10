//
//  SettingsViewPresenterTests.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import XCTest
import CommonTests
@testable import SettingsModule

final class SettingsViewPresenterTests: XCTestCase {
  private var mockRouter: MockSettingsModuleRouter!
  private var mockView: MockSettingsPresentableView!
  private var presenter: SettingsViewPresenter!

  override func setUp() {
    mockView = MockSettingsPresentableView()
    mockRouter = MockSettingsModuleRouter()
    presenter = SettingsViewPresenter(router: mockRouter)
  }

  func test_routerLogoutCalled_when_logoutButtonTapped() {
    given_setupIsCalledOnSubject()
    when_logoutButtonTapped()
    then_routerLogoutIsCalled()
  }

  // MARK: Given

  private func given_setupIsCalledOnSubject() {
    presenter.setup(with: mockView)
  }

  // MARK: When

  private func when_setupIsCalledOnSubject() {
    presenter.setup(with: mockView)
  }

  private func when_logoutButtonTapped() {
    presenter.logoutButtonTapped()
  }

  // MARK: Then

  private func then_viewModel_isCorrectlyPassed() {
    let viewModel = try! XCTUnwrap(mockView.viewModel)
    XCTAssertEqual(viewModel.logoutButtonTitle, "Logout")
    XCTAssertEqual(viewModel.navBarTitle, "Settings")
  }

  private func then_routerLogoutIsCalled() {
    XCTAssertTrue(mockRouter.userDidLogoutCalled)
  }
}

private class MockSettingsPresentableView: SettingsViewPresentable {

  var className = "MOCK_VIEW"
  var viewModel: SettingsViewModel?

  func configure(with viewModel: SettingsViewModel) {
    self.viewModel = viewModel
  }

}
