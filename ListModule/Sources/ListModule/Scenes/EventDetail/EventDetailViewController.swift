//
//  EventDetailViewController.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 18/12/2020.
//

import UIKit
import CommonUI
import CommonDomain
import CommonComponents

final class EventDetailViewController: UIViewController {
  @IBOutlet private var imageOnTop: UIImageView!
  @TitleLabel() @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var priceLabel: UILabel!

  private let presenter: EventDetailViewPresenterType

  init(presenter: EventDetailViewPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: .module)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    style()
    presenter.setup(with: self)
  }

  private func style() {
    titleLabel.font = Fonts.Cyberpunk.h1
    titleLabel.textColor = Colors.primaryText

    descriptionLabel.font = Fonts.Timeburner.b1
    descriptionLabel.textColor = Colors.secondaryText

    priceLabel.font = Fonts.Timeburner.b2
    priceLabel.textColor = Colors.specialText
  }
}


extension EventDetailViewController: EventDetailViewPresentable {
  func configure(with viewModel: EventDetailViewModel) {
    imageOnTop.load(url: viewModel.imageUrl)
    titleLabel.text = viewModel.titleLabel
    descriptionLabel.text = viewModel.descriptionLabel
    priceLabel.text = viewModel.priceLabel
  }

}
