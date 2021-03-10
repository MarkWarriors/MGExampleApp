//
//  MockContext.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit
import CommonComponents

public class MockContext: Context {
  var presentScreenVCCalled = false
  var presentScreenNCCalled = false
  var pushCalled = false
  var setViewControllersCalled = false
  var dismissCalled = false
  var backCalled = false
  var popToRootCalled = false

  public init() {
  }

  public func present(_ screen: UIViewController) {
    presentScreenVCCalled = true
  }

  public func present(_ screen: UINavigationController) {
    presentScreenNCCalled = true
  }

  public func push(_ screen: UIViewController) {
    pushCalled = true
  }

  public func get() -> UINavigationController {
    return UINavigationController()
  }

  public func setViewControllers(_ viewControllers: [UIViewController]) {
    setViewControllersCalled = true
  }

  public func dismiss() {
    dismissCalled = true
  }

  public func back() {
    backCalled = true
  }

  public func popToRoot() {
    popToRootCalled = true
  }
}
