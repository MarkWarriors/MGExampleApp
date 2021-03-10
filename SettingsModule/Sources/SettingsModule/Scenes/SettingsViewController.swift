//
//  SettingsViewController.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit

final class SettingsViewController: UIViewController {
  @IBOutlet private var logoutButton: UIButton!

  private let presenter: SettingsViewPresenterType

  init(presenter: SettingsViewPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: .module)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.setup(with: self)
    style()
  }

  private func style() {
  }

  @IBAction private func logoutButtonTapped(sender: Any) {
    presenter.logoutButtonTapped()
  }
}

extension SettingsViewController: SettingsViewPresentable {
  func configure(with viewModel: SettingsViewModel) {
    self.title = viewModel.navBarTitle
    logoutButton.setTitle(viewModel.logoutButtonTitle, for: .normal)
  }
}
