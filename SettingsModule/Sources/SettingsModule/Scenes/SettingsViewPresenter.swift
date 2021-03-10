//
//  SettingsViewPresenter.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import CommonUI
import CommonComponents

final class SettingsViewPresenter: SettingsViewPresenterType {
  private weak var router: SettingsModuleRouterType?

  private weak var view: SettingsViewPresentable?

  init(router: SettingsModuleRouterType) {
    self.router = router
  }

  func setup(with view: SettingsViewPresentable) {
    self.view = view
    view.configure(with: createViewModel())
  }

  func logoutButtonTapped() {
    router?.userDidLogout()
  }

  private func createViewModel() -> SettingsViewModel {
    return SettingsViewModel(navBarTitle: ModuleStrings.TabItem.name,
                             logoutButtonTitle: ModuleStrings.Scenes.Settings.logoutButtonTitle)
  }
}
