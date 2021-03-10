//
//  MockListModuleRouter.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit
import CommonTests
import CommonComponents
import CommonDomain
@testable import ListModule

class MockListModuleRouter: ListModuleRouterType {
  var context: Context
  var childRouter: Router?
  var parentRouter: Router?

  var presentEventDetailsCalled = false
  var presentEventDetailsEvent: Event?
  var getEventDetailsViewControllerEvent: Event?

  init() {
    context = MockContext()
  }

  func presentEventDetails(for event: Event) {
    presentEventDetailsCalled = true
    presentEventDetailsEvent = event
  }

  func getEventDetailsViewController(for event: Event) -> UIViewController {
    getEventDetailsViewControllerEvent = event
    return UIViewController()
  }
}
