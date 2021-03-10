import UIKit
import CommonComponents

public struct LoginModule {

  public static func start(context: Context) -> LoginModuleRouterType {
    let navigationViewController = UINavigationController()
    let context = RouterContext(with: navigationViewController)
    return LoginModuleRouter(context: context)
  }

}
