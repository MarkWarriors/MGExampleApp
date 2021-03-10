//
//  MainViewController.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import UIKit
import HomeModule
import ListModule
import CommonStrings
import CommonComponents

final class MainViewController: UITabBarController {
  init() {
    super.init(nibName: nil, bundle: .main)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  private func configure() {
    delegate = self
  }

}

extension MainViewController: UITabBarControllerDelegate {

  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    return true
  }

}
