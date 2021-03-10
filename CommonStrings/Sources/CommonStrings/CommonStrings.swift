//
//  CommonStrings.swift
//
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

public struct CommonStrings {
  public struct General {
    public static let appName = "CommonStrings.General.appName".localized()
  }

  public struct Actions {
    public static let okActionTitle = "CommonStrings.Actions.okActionTitle".localized()
    public static let cancelActionTitle = "CommonStrings.Actions.cancelActionTitle".localized()
    public static let doneActionTitle = "CommonStrings.Actions.doneActionTitle".localized()
    public static let retryActionTitle = "CommonStrings.Actions.retryActionTitle".localized()
  }

  public struct Errors {
    public static let generic = "CommonStrings.Errors.generic".localized()
  }

  public struct Alert {
    public static let attention = "CommonStrings.Alert.attention".localized()
    public static let error = "CommonStrings.Alert.error".localized()
  }
}

internal extension String {
  /// Return the localized version of the string
  func localized() -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: "", comment: "")
  }
}
