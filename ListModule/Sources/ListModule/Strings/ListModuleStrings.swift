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
    struct List {
      static let title = "Scenes.List.title".localized()

      struct Errors {
        static let noEventsInFuture = "Scenes.List.noEventsInFuture".localized()
      }
    }

    struct EventDetail {
    }
  }

}

internal extension String {
  /// Return the localized version of the string
  func localized() -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: "", comment: "")
  }
}
