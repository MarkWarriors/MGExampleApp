//
//  CommonStrings.swift
//
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

struct ModuleStrings {
  struct TabItem {
    static let name = "TabItem.name".localized()
  }

  struct Scenes {
    struct Settings {
      static let logoutButtonTitle = "Scenes.Settings.logoutButtonTitle".localized()
    }
  }

}

internal extension String {
  /// Return the localized version of the string
  func localized() -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: "", comment: "")
  }
}
