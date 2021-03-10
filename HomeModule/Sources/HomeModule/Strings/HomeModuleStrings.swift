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
    struct Home {
      static let title = "Scenes.Home.title".localized()
      static let description = "Scenes.Home.description".localized()
      static let specialLabel = "Scenes.Home.specialLabel".localized()
      static let nextEventTitleLabel = "Scenes.Home.nextEventTitleLabel".localized()

      struct Errors {
        static let noEventsInFuture = "Scenes.Errors.noEventsInFuture".localized()
      }
    }
  }

}

internal extension String {
  /// Return the localized version of the string
  func localized() -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: "", comment: "")
  }
}
