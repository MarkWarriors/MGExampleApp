//
//  EventDetailViewController.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import Foundation
import CommonComponents
import CommonDomain

protocol EventDetailViewPresentable: Trackable {
  func configure(with viewModel: EventDetailViewModel)
}

protocol EventDetailViewPresenterType {
  func setup(with view: EventDetailViewPresentable)
}

struct EventDetailViewModel {
  let imageUrl: String
  let titleLabel: String
  let descriptionLabel: String
  let priceLabel: String
}
