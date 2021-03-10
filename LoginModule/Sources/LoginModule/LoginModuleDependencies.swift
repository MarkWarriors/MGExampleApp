//
//  LoginModuleDependencies.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonComponents
import CommonInstances
import CommonStrings

final class LoginModuleDependencies {
  public static let shared = LoginModuleDependencies()
  
  private init() {}
  
  func loginViewController(router: LoginModuleRouterType) -> LoginViewController {
    return LoginViewController(presenter: loginViewPresenter(router: router))
  }
  
  func registerAccountViewController(router: LoginModuleRouterType) -> RegisterAccountViewController {
    return RegisterAccountViewController(presenter: registerAccountViewPresenter(router: router))
  }
  
  private func loginViewPresenter(router: LoginModuleRouterType) -> LoginViewPresenterType {
    return LoginViewPresenter(loginUseCase: loginUseCase(),
                              accountCache: accountCache(),
                              router: router)
  }
  
  private func registerAccountViewPresenter(router: LoginModuleRouterType) -> RegisterAccountViewPresenterType {
    return RegisterAccountViewPresenter(registerAccountUseCase: registerAccountUseCase(),
                                        router: router)
  }
  
  private func loginUseCase() -> LoginUseCaseType {
    return LoginUseCase()
  }
  
  private func registerAccountUseCase() -> RegisterAccountUseCaseType {
    return RegisterAccountUseCase()
  }

  private func accountCache() -> AccountCacheType {
    return AccountCache(with: CommonInstances.shared.userDefaults)
  }

  func appEventBroadcaster() -> AppEventBroadcasterType {
    return AppEventBroadcaster(notificationCenter: CommonInstances.shared.notificationCenter)
  }
}
