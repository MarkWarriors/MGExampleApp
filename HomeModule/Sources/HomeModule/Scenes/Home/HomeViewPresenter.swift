//
//  HomeViewPresenter.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import Foundation
import CommonUI
import CommonDomain
import CommonStrings

final class HomeViewPresenter: HomeViewPresenterType {
  typealias Strings = ModuleStrings.Scenes.Home

  private let eventsListUseCase: EventsListUseCaseType
  private weak var router: HomeModuleRouterType?

  private weak var view: HomeViewPresentable?

  init(eventsListUseCase: EventsListUseCaseType, router: HomeModuleRouterType) {
    self.eventsListUseCase = eventsListUseCase
    self.router = router
  }

  func setup(with view: HomeViewPresentable) {
    self.view = view
    view.configure(with: createViewModel())
    loadNextEvent()
  }

  func retryOnErrorAlertTapped() {
    loadNextEvent()
  }

  private func createViewModel() -> HomeViewModel {
    return HomeViewModel(navBarTitle: ModuleStrings.TabItem.name,
                         imageOnTop: Images.logo,
                         titleLabel: Strings.title,
                         descriptionLabel: Strings.description,
                         specialLabel: Strings.specialLabel,
                         nextEventTitleLabel: Strings.nextEventTitleLabel)
  }

  private func loadNextEvent() {
    eventsListUseCase.fetch(filterCategory: nil) { [weak self] (result) in
      guard let self = self, let view = self.view else { return }
      switch result {
      case let .success(events):
        if let nextEvent = events.first {
          view.showNextEventInfo(nextEvent)
        } else {
          self.handleNoNextEventFound()
        }
      case .failure:
        self.handleLoadNextEventFailure()
      }
    }
  }

  private func handleNoNextEventFound() {
    let viewModel = HomeViewErrorViewModel(title: CommonStrings.Alert.attention,
                                           message: Strings.Errors.noEventsInFuture,
                                           retryAction: nil,
                                           cancelAction: CommonStrings.Actions.okActionTitle)
    view?.showError(viewModel: viewModel)
  }

  private func handleLoadNextEventFailure() {
    let viewModel = HomeViewErrorViewModel(title: CommonStrings.Alert.attention,
                                           message: CommonStrings.Errors.generic,
                                           retryAction: CommonStrings.Actions.retryActionTitle,
                                           cancelAction: CommonStrings.Actions.cancelActionTitle)
    view?.showError(viewModel: viewModel)
  }

}
