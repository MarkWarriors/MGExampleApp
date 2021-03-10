//
//  SettingsModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import CommonComponents

public protocol SettingsModuleRouterType: Router {
  func userDidLogout()
}

final class SettingsModuleRouter: SettingsModuleRouterType {
  private let appEventBroadcaster = SettingsModuleDependencies.shared.appEventBroadcaster()

  weak var parentRouter: Router?
  var childRouter: Router?
  let context: Context

  init(context: Context) {
    context.get().tabBarItem = SettingsModuleDependencies.shared.tabBarItem()
    self.context = context
    let viewController = SettingsModuleDependencies.shared.settingsViewController(router: self)
    context.setViewControllers([viewController])
  }

  func userDidLogout() {
    appEventBroadcaster.broadcast(event: .userDidLogout)
  }

}
