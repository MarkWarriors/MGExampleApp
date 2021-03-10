//
//  HomeModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation
import CommonComponents

public protocol HomeModuleRouterType: Router {
}

final class HomeModuleRouter: HomeModuleRouterType {
  weak var parentRouter: Router?
  var childRouter: Router?
  let context: Context

  init(with context: Context) {
    context.get().tabBarItem = HomeModuleDependencies.shared.tabBarItem()
    self.context = context
    let viewController = HomeModuleDependencies.shared.homeViewController(router: self)
    context.setViewControllers([viewController])
  }
}
