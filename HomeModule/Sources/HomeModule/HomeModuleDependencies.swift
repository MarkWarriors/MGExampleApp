//
//  HomeModuleDependencies.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import UIKit
import CommonDomain

final class HomeModuleDependencies {
  public static let shared = HomeModuleDependencies()

  private init() {}

  func tabBarItem() -> UITabBarItem {
    let title = ModuleStrings.TabItem.name
    let image = UIImage(systemName: "house")
    return UITabBarItem(title: title, image: image, selectedImage: nil)
  }

  func homeViewController(router: HomeModuleRouterType) -> HomeViewController {
    return HomeViewController(presenter: homeViewPresenter(router: router))
  }

  private func homeViewPresenter(router: HomeModuleRouterType) -> HomeViewPresenterType {
    return HomeViewPresenter(eventsListUseCase: eventsListUseCase(),
                             router: router)
  }

  private func eventsListUseCase() -> EventsListUseCaseType {
    return EventsListUseCase()
  }
}
