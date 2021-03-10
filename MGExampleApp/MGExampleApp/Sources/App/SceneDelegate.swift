//
//  SceneDelegate.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 15/12/2020.
//

import UIKit
import LoginModule
import HomeModule
import ListModule
import AssetsLibrary
import CommonComponents

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  private var appRouter: AppRouter?
  private let rootNavigationController = UINavigationController()
  private lazy var appContext = RouterContext(with: rootNavigationController)

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    appRouter = AppRouter(appEventListener: MainAppDependencies.shared.appEventListener(),
                          accountCache: MainAppDependencies.shared.accountCache(),
                          context: appContext)

    window = UIWindow(windowScene: windowScene)
    rootNavigationController.setNavigationBarHidden(true, animated: false)
    
    guard let rootViewController = appRouter?.startViewController() else {
      assertionFailure("No app router found")
      return
    }
    appContext.setViewControllers([rootViewController])
    
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()

    if let deepLinkAction = checkForDeepLinkAction(URLContexts: connectionOptions.urlContexts) {
      appRouter?.deepLinkActionToPerform(deepLinkAction)
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let deepLinkAction = checkForDeepLinkAction(URLContexts: URLContexts) {
      appRouter?.deepLinkActionToPerform(deepLinkAction)
    }
  }

  private func checkForDeepLinkAction(URLContexts: Set<UIOpenURLContext>) -> DeepLinkAction? {
    guard
      let url = URLContexts.first?.url, let scheme = url.scheme,
      let foundLink = AcceptedDeepLink.allCases.first(where: { scheme.localizedCaseInsensitiveCompare($0.rawValue) == .orderedSame })
    else { return nil }

    switch foundLink {
    case .widget:
      if let eventId = getEventId(from: url) { return .openEvent(id: eventId) }
    }

    return nil
  }

  private func getEventId(from url: URL) -> String? {
    guard
      let eventIdParam = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "event" }),
      let eventId = eventIdParam.value
    else { return nil }
    return eventId
  }
}

enum DeepLinkAction {
  case openEvent(id: String)
}

private enum AcceptedDeepLink: String, CaseIterable {
  case widget = "eventsWidget"
}
