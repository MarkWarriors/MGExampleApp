//
//  AppDelegate.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 15/12/2020.
//

import UIKit
import CommonUI
import Networking
import CommonDomain

#if DEBUG
import MockServer
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    configurePackages()

    #if DEBUG
    startMockServerIfNeeded()
    #endif

    return true
  }

  private func configurePackages() {
    CommonUI.initializeFonts()
    Networking.setup(with: MainAppConfig.self)
  }

  #if DEBUG
  private func startMockServerIfNeeded() {
    if MainAppConfig.isTestEnv {
      MockServer().start()
    }
  }
  #endif

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }

}

#if DEBUG
extension UIWindow {
  public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if MainAppConfig.isTestEnv {
      if motion == .motionShake {
        showDebugMenu()
      }
    } else {
      assertionFailure("This should never be triggered in non-test environment")
    }
  }

  private func showDebugMenu() {
    let vc = MockServerConfig.getViewController()
    UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
  }

}
#endif
