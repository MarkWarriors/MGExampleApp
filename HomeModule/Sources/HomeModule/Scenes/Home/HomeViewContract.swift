//
//  HomeViewContract.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit
import CommonComponents
import CommonDomain

protocol HomeViewPresentable: Trackable {
  func configure(with viewModel: HomeViewModel)
  func showNextEventInfo(_ event: Event)
  func showError(viewModel: HomeViewErrorViewModel)
}

protocol HomeViewPresenterType {
  func setup(with view: HomeViewPresentable)
  func retryOnErrorAlertTapped()
}

struct HomeViewModel {
  let navBarTitle: String
  let imageOnTop: UIImage
  let titleLabel: String
  let descriptionLabel: String
  let specialLabel: String
  let nextEventTitleLabel: String
}

struct HomeViewErrorViewModel {
  let title: String
  let message: String
  let retryAction: String?
  let cancelAction: String
}
