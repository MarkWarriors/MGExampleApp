//
//  CommonStrings.swift
//
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

struct ModuleStrings {
  struct Scenes {
    struct Login {
      static let title = "Scenes.Login.title".localized()
      static let usernamePlaceholder = "Scenes.Login.usernamePlaceholder".localized()
      static let passwordPlaceholder = "Scenes.Login.passwordPlaceholder".localized()
      static let loginButton = "Scenes.Login.loginButton".localized()
      static let registerAccountButton = "Scenes.Login.registerAccountButton".localized()

      struct Errors {
        static let wrongCredentials = "Scenes.Login.Errors.wrongCredentials".localized()
      }
    }

    struct RegisterAccount {
      static let title = "Scenes.RegisterAccount.title".localized()

      struct Errors {
        static let formNotValid = "Scenes.Login.Errors.formNotValid".localized()
        static let errorRegisteringAccount = "Scenes.Login.Errors.errorRegisteringAccount".localized()
      }

      struct Form {
        struct Name {
          static let title = "Scenes.RegisterAccount.Form.Name.title".localized()
          static let error = "Scenes.RegisterAccount.Form.Name.error".localized()
        }

        struct Surname {
          static let title = "Scenes.RegisterAccount.Form.Surname.title".localized()
          static let error = "Scenes.RegisterAccount.Form.Surname.error".localized()
        }

        struct Username {
          static let title = "Scenes.RegisterAccount.Form.Username.title".localized()
          static let error = "Scenes.RegisterAccount.Form.Username.error".localized()
        }

        struct Email {
          static let title = "Scenes.RegisterAccount.Form.Email.title".localized()
          static let error = "Scenes.RegisterAccount.Form.Email.error".localized()
        }

        struct ConfirmEmail {
          static let title = "Scenes.RegisterAccount.Form.ConfirmEmail.title".localized()
          static let error = "Scenes.RegisterAccount.Form.ConfirmEmail.error".localized()
        }

        struct Password {
          static let title = "Scenes.RegisterAccount.Form.Password.title".localized()
          static let error = "Scenes.RegisterAccount.Form.Password.error".localized()
        }

        struct ConfirmPassword {
          static let title = "Scenes.RegisterAccount.Form.ConfirmPassword.title".localized()
          static let error = "Scenes.RegisterAccount.Form.ConfirmPassword.error".localized()
        }
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
