//
//  AppRouter.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import UIKit
import LoginModule
import HomeModule
import ListModule
import SettingsModule
import CommonComponents
import CommonDomain

protocol AppRouterType: AnyObject {
  func startViewController() -> UIViewController
  func userDidLogin()
  func userDidLogout()
  func deepLinkActionToPerform(_ action: DeepLinkAction)
}

final class AppRouter: AppRouterType {
  // MARK: - Properties
  private let appEventListener: AppEventListenerType
  private let accountCache: AccountCacheType
  private let context: Context

  private var loginRouter: LoginModuleRouterType?
  private var homeRouter: HomeModuleRouterType?
  private var listRouter: ListModuleRouterType?
  private var settingsRouter: SettingsModuleRouterType?

  private var storedDeepLinkAction: DeepLinkAction?

  init(appEventListener: AppEventListenerType,
       accountCache: AccountCacheType,
       context: Context) {
    self.appEventListener = appEventListener
    self.accountCache = accountCache
    self.context = context
    configureAppEventListener()
  }

  private func configureAppEventListener() {
    appEventListener.delegate = self
    appEventListener.subscribe(to: [.userDidLogin, .userDidLogout])
  }

  private lazy var mainViewController: MainViewController = {
    AppDependencies.shared.mainViewController(router: self)
  }()

  func startViewController() -> UIViewController {
    if accountCache.currentAccount != nil {
      navigateToMainApp()
    } else {
      navigateToLogin()
    }
    return mainViewController
  }

  func userDidLogin() {
    guard accountCache.currentAccount != nil else { return }
    loginRouter = nil
    navigateToMainApp()
    checkForStoredDeepLinkActions()
  }

  func userDidLogout() {
    homeRouter = nil
    listRouter = nil
    settingsRouter = nil
    accountCache.removeCurrentAccount()
    navigateToLogin()
  }

  func deepLinkActionToPerform(_ action: DeepLinkAction) {
    switch action {
    case .openEvent(let id):
      presentEvent(with: id, action: action)
    }
  }

  private func presentEvent(with id: String, action: DeepLinkAction) {
    guard let router = listRouter else {
      storedDeepLinkAction = action
      return
    }
    let useCase = MainAppDependencies.shared.eventDetailUseCase()
    useCase.fetch(eventId: id) { [weak self] (result) in
      guard case let .success(event) = result else {return}
      let vc = router.getEventDetailsViewController(for: event)
      self?.mainViewController.present(vc, animated: true, completion: nil)
    }
  }

  private func checkForStoredDeepLinkActions() {
    guard let action = storedDeepLinkAction else { return }
    storedDeepLinkAction = nil
    deepLinkActionToPerform(action)
  }

  private func navigateToMainApp() {
    homeRouter = HomeModule.start(context: context)
    listRouter = ListModule.start(context: context)
    settingsRouter = SettingsModule.start(context: context)
    mainViewController.tabBar.isHidden = false
    mainViewController.viewControllers = tabBarViewControllerList()
  }

  private func tabBarViewControllerList() -> [UIViewController] {
    return [homeRouter?.context.get(),
            listRouter?.context.get(),
            settingsRouter?.context.get()].compactMap{ $0 }
  }

  private func navigateToLogin() {
    loginRouter = LoginModule.start(context: context)
    mainViewController.tabBar.isHidden = true
    mainViewController.viewControllers = [loginRouter?.context.get()].compactMap{ $0 }
  }
}

extension AppRouter: AppEventListenerDelegate {
  func eventReceived(_ event: AppEventKey) {
    switch event {
    case .userDidLogin:
      userDidLogin()
    case .userDidLogout:
      userDidLogout()
    }
  }
}
