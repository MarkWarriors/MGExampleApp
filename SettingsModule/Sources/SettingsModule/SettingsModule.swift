import UIKit
import CommonComponents

public struct SettingsModule {

  public static func start(context: Context) -> SettingsModuleRouterType {
    let navigationViewController = UINavigationController()
    navigationViewController.tabBarItem = SettingsModuleDependencies.shared.tabBarItem()
    let context = RouterContext(with: navigationViewController)
    return SettingsModuleRouter(context: context)
  }

}
