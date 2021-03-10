//
//  MockSettingsModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import UIKit
import CommonTests
import CommonComponents
@testable import SettingsModule

class MockSettingsModuleRouter: SettingsModuleRouterType {
  var context: Context
  var childRouter: Router?
  var parentRouter: Router?

  var userDidLogoutCalled = false

  init() {
    context = MockContext()
  }

  func userDidLogout() {
    userDidLogoutCalled = true
  }

}
