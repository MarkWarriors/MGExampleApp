//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import CommonUI
import CommonDomain
import CommonStrings
import CommonComponents

final class LoginViewPresenter: LoginViewPresenterType {
  typealias Strings = ModuleStrings.Scenes.Login

  private let loginUseCase: LoginUseCaseType
  private let accountCache: AccountCacheType
  private weak var router: LoginModuleRouterType?
  
  private weak var view: LoginViewPresentable?
  
  init(loginUseCase: LoginUseCaseType,
       accountCache: AccountCacheType,
       router: LoginModuleRouterType) {
    self.loginUseCase = loginUseCase
    self.accountCache = accountCache
    self.router = router
  }
  
  func setup(with view: LoginViewPresentable) {
    self.view = view
    view.configure(with: createViewModel())
  }
  
  func retryOnErrorAlertTapped(username: String, password: String) {
    login(username: username, password: username)
  }
  
  private func login(username: String, password: String) {
    loginUseCase.fetch(username: username, password: password) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success:
        self.handleLoginSuccess(username: username)
      case .failure:
        self.handleLoginError()
      }
    }
  }
  
  func userInsertText(username: String, password: String) {
    let canLogin = usernameIsValid(username) && passwordIsValid(password)
    view?.updateLoginButton(enabled: canLogin)
  }
  
  func loginButtonTapped(username: String, password: String) {
    login(username: username, password: username)
  }
  
  func registerButtonTapped() {
    router?.presentRegisterAccount()
  }

  private func handleLoginSuccess(username: String) {
    let loggedAccount = Account(name: username)
    accountCache.saveCurrentAccount(loggedAccount)
    router?.userDidLogin()
  }

  private func handleLoginError() {
    view?.showError(viewModel: LoginViewErrorViewModel(title: CommonStrings.Alert.attention,
                                                       message: Strings.Errors.wrongCredentials,
                                                       retryAction: CommonStrings.Actions.retryActionTitle,
                                                       cancelAction: CommonStrings.Actions.cancelActionTitle))
  }
  
  private func createViewModel() -> LoginViewModel {
    return LoginViewModel(imageOnTop: Images.logo,
                          titleLabel: Strings.title,
                          usernameTextView: LoginViewModel.InputText(text: "",
                                                                     placeholder: Strings.usernamePlaceholder,
                                                                     state: .normal),
                          passwordTextView: LoginViewModel.InputText(text: "",
                                                                     placeholder: Strings.passwordPlaceholder,
                                                                     state: .normal),
                          loginButton: LoginViewModel.Button(title: Strings.loginButton,
                                                             tapable: false),
                          registerAccountButton: LoginViewModel.Button(title: Strings.registerAccountButton,
                                                                       tapable: true))
  }
  
  private func usernameIsValid(_ username: String) -> Bool {
    return username.count > 2
  }
  
  private func passwordIsValid(_ password: String) -> Bool {
    return password.count > 2
  }
}
