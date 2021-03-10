//
//  SettingsViewContract.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit
import CommonComponents
import CommonDomain

protocol SettingsViewPresentable: Trackable {
  func configure(with viewModel: SettingsViewModel)
}

protocol SettingsViewPresenterType {
  func setup(with view: SettingsViewPresentable)
  func logoutButtonTapped()
}

struct SettingsViewModel {
  let navBarTitle: String
  let logoutButtonTitle: String
}
