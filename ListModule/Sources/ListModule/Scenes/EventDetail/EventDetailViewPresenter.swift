//
//  EventDetailViewPresenter.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit
import CommonDomain

final class EventDetailViewPresenter: EventDetailViewPresenterType {
  private let event: Event
  private weak var router: ListModuleRouterType?
  
  private weak var view: EventDetailViewPresentable?

  init(event: Event,
       router: ListModuleRouterType) {
    self.event = event
    self.router = router
  }

  func setup(with view: EventDetailViewPresentable) {
    self.view = view
    view.configure(with: createViewModel())
  }

  private func createViewModel() -> EventDetailViewModel {
    return EventDetailViewModel(imageUrl: event.imageURL,
                                titleLabel: event.name,
                                descriptionLabel: event.description,
                                priceLabel: "\(event.price) \(event.currency)")
  }

}
