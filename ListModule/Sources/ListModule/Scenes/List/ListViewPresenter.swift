//
//  ListViewPresenter.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import Foundation
import CommonDomain
import CommonUI
import CommonStrings

final class ListViewPresenter: ListViewPresenterType {
  typealias Strings = ModuleStrings.Scenes.List

  private let eventsListUseCase: EventsListUseCaseType
  private weak var router: ListModuleRouterType?

  private weak var view: ListViewPresentable?

  init(eventsListUseCase: EventsListUseCaseType,
       router: ListModuleRouterType) {
    self.eventsListUseCase = eventsListUseCase
    self.router = router
  }

  func setup(with view: ListViewPresentable) {
    self.view = view
    view.configure(with: createViewModel())
    loadEvents()
  }

  func didTapOnEvent(_ event: Event) {
    router?.presentEventDetails(for: event)
  }

  func userPulledToRefresh() {
    loadEvents()
  }

  func retryOnErrorAlertTapped() {
    loadEvents()
  }

  private func createViewModel() -> ListViewModel {
    return ListViewModel(navBarTitle: ModuleStrings.TabItem.name,
                         imageOnTop: Images.logoInline,
                         titleLabel: Strings.title)
  }

  private func loadEvents() {
    view?.startLoading()
    eventsListUseCase.fetch(filterCategory: nil) { [weak self] (result) in
      guard let self = self, let view = self.view else { return }
      view.endLoading()
      switch result {
      case let .success(events):
        if events.count > 0 {
          view.update(with: events)
        } else {
          self.handleNoEventsFound()
        }
      case .failure:
        self.handleLoadNextEventFailure()
      }
    }
  }
  
  private func handleNoEventsFound() {
    let viewModel = ListViewErrorViewModel(title: CommonStrings.Alert.attention,
                                           message: Strings.Errors.noEventsInFuture,
                                           retryAction: nil,
                                           cancelAction: CommonStrings.Actions.okActionTitle)
    view?.showError(viewModel: viewModel)
  }

  private func handleLoadNextEventFailure() {
    let viewModel = ListViewErrorViewModel(title: CommonStrings.Alert.attention,
                                           message: CommonStrings.Errors.generic,
                                           retryAction: CommonStrings.Actions.retryActionTitle,
                                           cancelAction: CommonStrings.Actions.cancelActionTitle)
    view?.showError(viewModel: viewModel)
  }

}
