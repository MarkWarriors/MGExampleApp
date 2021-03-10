//
//  MockHomeModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit
import CommonTests
import CommonComponents
@testable import HomeModule

class MockHomeModuleRouter: HomeModuleRouterType {
  var context: Context
  var childRouter: Router?
  var parentRouter: Router?

  init() {
    context = MockContext()
  }
}
