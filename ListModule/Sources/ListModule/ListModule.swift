import UIKit
import CommonComponents

public struct ListModule {

  public static func start(context: Context) -> ListModuleRouterType {
    let navigationViewController = UINavigationController()
    navigationViewController.tabBarItem = ListModuleDependencies.shared.tabBarItem()
    let context = RouterContext(with: navigationViewController)
    return ListModuleRouter(with: context)
  }

}
