//
//  ListModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import UIKit
import CommonComponents
import CommonDomain

public protocol ListModuleRouterType: Router {
  func presentEventDetails(for event: Event)
  func getEventDetailsViewController(for event: Event) -> UIViewController
}

final class ListModuleRouter: ListModuleRouterType {
  weak var parentRouter: Router?
  var childRouter: Router?
  let context: Context

  init(with context: Context) {
    context.get().tabBarItem = ListModuleDependencies.shared.tabBarItem()
    self.context = context
    let viewController = ListModuleDependencies.shared.listViewController(router: self)
    context.setViewControllers([viewController])
  }

  func presentEventDetails(for event: Event) {
    let vc = getEventDetailsViewController(for: event)
    context.present(vc)
  }

  func getEventDetailsViewController(for event: Event) -> UIViewController {
    return ListModuleDependencies.shared.eventDetailViewController(event: event, router: self)
  }
}
