//
//  ListModuleDependencies.swift
//
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import UIKit
import CommonDomain

final class ListModuleDependencies {
  public static let shared = ListModuleDependencies()

  private init() {}

  func tabBarItem() -> UITabBarItem {
    let title = ModuleStrings.TabItem.name
    let image = UIImage(systemName: "table")
    return UITabBarItem(title: title, image: image, selectedImage: nil)
  }

  func listViewController(router: ListModuleRouterType) -> ListViewController {
    return ListViewController(presenter: listViewPresenter(router: router))
  }

  private func listViewPresenter(router: ListModuleRouterType) -> ListViewPresenterType {
    return ListViewPresenter(eventsListUseCase: eventsListUseCase(),
                             router: router)
  }

  func eventDetailViewController(event: Event, router: ListModuleRouterType) -> EventDetailViewController {
    return EventDetailViewController(presenter: eventDetailViewPresenter(event: event, router: router))
  }

  private func eventDetailViewPresenter(event: Event, router: ListModuleRouterType) -> EventDetailViewPresenterType {
    return EventDetailViewPresenter(event: event, router: router)
  }

  private func eventsListUseCase() -> EventsListUseCaseType {
    return EventsListUseCase()
  }
}
