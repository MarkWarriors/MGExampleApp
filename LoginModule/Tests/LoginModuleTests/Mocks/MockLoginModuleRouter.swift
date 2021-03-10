//
//  MockLoginModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import UIKit
import CommonTests
import CommonComponents
@testable import LoginModule

class MockLoginModuleRouter: LoginModuleRouterType {
  var context: Context
  var childRouter: Router?
  var parentRouter: Router?

  var userDidLoginCalled = false
  var presentRegisterAccountCalled = false
  var dismissCalled = false

  init() {
    context = MockContext()
  }

  func userDidLogin() {
    userDidLoginCalled = true
  }

  func presentRegisterAccount() {
    presentRegisterAccountCalled = true
  }

  func dismiss() {
    dismissCalled = true
  }
}
