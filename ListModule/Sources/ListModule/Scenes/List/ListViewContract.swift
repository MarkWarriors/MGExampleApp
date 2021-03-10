//
//  ListViewContract.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit
import CommonComponents
import CommonDomain

protocol ListViewPresentable: Trackable {
  func configure(with viewModel: ListViewModel)
  func update(with events: [Event])
  func startLoading()
  func endLoading()
  func showError(viewModel: ListViewErrorViewModel)
}

protocol ListViewPresenterType {
  func setup(with view: ListViewPresentable)
  func didTapOnEvent(_ event: Event)
  func userPulledToRefresh()
  func retryOnErrorAlertTapped()
}

struct ListViewModel {
  let navBarTitle: String
  let imageOnTop: UIImage
  let titleLabel: String
}

struct ListViewErrorViewModel {
  let title: String
  let message: String
  let retryAction: String?
  let cancelAction: String
}
