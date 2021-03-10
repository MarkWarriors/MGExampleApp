//
//  LoginModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import CommonComponents

public protocol LoginModuleRouterType: Router {
  func userDidLogin()
  func presentRegisterAccount()
}

final class LoginModuleRouter: LoginModuleRouterType {
  weak var parentRouter: Router?
  var childRouter: Router?
  let context: Context

  private let appEventBroadcaster = LoginModuleDependencies.shared.appEventBroadcaster()

  init(context: Context) {
    self.context = context
    let viewController = LoginModuleDependencies.shared.loginViewController(router: self)
    context.setViewControllers([viewController])
  }

  func userDidLogin() {
    appEventBroadcaster.broadcast(event: .userDidLogin)
  }

  func presentRegisterAccount() {
    let vc = LoginModuleDependencies.shared.registerAccountViewController(router: self)
    context.present(vc)
  }

}
