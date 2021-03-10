import UIKit
import CommonComponents

public struct HomeModule {

  public static func start(context: Context) -> HomeModuleRouterType {
    let navigationViewController = UINavigationController()
    navigationViewController.tabBarItem = HomeModuleDependencies.shared.tabBarItem()
    let context = RouterContext(with: navigationViewController)
    return HomeModuleRouter(with: context)
  }
  
}
