//
//  Router.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//


import UIKit

public protocol Router: AnyObject {
  var context: Context { get }
  var childRouter: Router? { get set }
  var parentRouter: Router? { get set }
  func addChildRouter(router: Router)
  func childDidDismiss()
  func dismiss()
  func back()
  func popToRoot()
}

public extension Router {
  func dismiss() {
    context.dismiss()
    parentRouter?.childDidDismiss()
  }

  func childDidDismiss() {
    childRouter = nil
  }

  func addChildRouter(router: Router) {
    router.parentRouter = self
    childRouter = router
  }

  func back() {
    context.back()
  }

  func popToRoot() {
    context.popToRoot()
  }
}

public protocol Context {
  func present(_ screen: UIViewController)
  func push(_ screen: UIViewController)
  func get() -> UINavigationController
  func setViewControllers(_ viewControllers: [UIViewController])
  func dismiss()
  func back()
  func popToRoot()
}

public final class RouterContext: Context {
  private let context: UINavigationController

  public init(with context: UINavigationController) {
    self.context = context
    self.context.view.backgroundColor = .white
//    self.context.navigationBar.titleTextAttributes = [
//      NSAttributedString.Key.font: Font,
//      NSAttributedString.Key.foregroundColor: UIColor.black
//    ]
  }

  public func present(_ screen: UIViewController) {
    context.present(screen, animated: true)
  }

  public func push(_ screen: UIViewController) {
    context.pushViewController(screen, animated: true)
  }

  public func get() -> UINavigationController {
    return context
  }

  public func setViewControllers(_ viewControllers: [UIViewController]) {
    context.viewControllers = viewControllers
  }

  public func dismiss() {
    context.dismiss(animated: true, completion: nil)
  }

  public func back() {
    context.popViewController(animated: true)
  }

  public func popToRoot() {
    context.popToRootViewController(animated: true)
  }
}
