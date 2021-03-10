//
//  AppDependencies.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

final class AppDependencies {
  static let shared = AppDependencies()

  private init() { }

  func mainViewController(router: AppRouter) -> MainViewController {
    let tabBarVC =  MainViewController()
    return tabBarVC
  }

}
