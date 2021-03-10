//
//  SettingsModuleDependencies.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonComponents
import CommonInstances

final class SettingsModuleDependencies {
  public static let shared = SettingsModuleDependencies()

  private init() {}

  func tabBarItem() -> UITabBarItem {
    let title = ModuleStrings.TabItem.name
    let image = UIImage(systemName: "gear")
    return UITabBarItem(title: title, image: image, selectedImage: nil)
  }

  func settingsViewController(router: SettingsModuleRouterType) -> SettingsViewController {
    return SettingsViewController(presenter: settingsViewPresenter(router: router))
  }

  private func settingsViewPresenter(router: SettingsModuleRouterType) -> SettingsViewPresenterType {
    return SettingsViewPresenter(router: router)
  }

  func appEventBroadcaster() -> AppEventBroadcasterType {
    return AppEventBroadcaster(notificationCenter: CommonInstances.shared.notificationCenter)
  }
}
