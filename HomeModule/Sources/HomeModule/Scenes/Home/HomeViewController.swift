//
//  HomeViewController.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 15/12/2020.
//

import UIKit
import CommonUI
import Networking
import CommonDomain
import CommonComponents

final class HomeViewController: UIViewController {
  @TitleLabel() @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var specialLabel: UILabel!
  @IBOutlet private var imageOnTop: UIImageView!

  @IBOutlet private var eventImage: UIImageView!
  @IBOutlet private var nextEventTitleLabel: UILabel!
  @IBOutlet private var nextEventNameLabel: UILabel!
  @IBOutlet private var nextEventDescriptionLabel: UILabel!

  private let presenter: HomeViewPresenterType
  private var nextEvent: Event?

  init(presenter: HomeViewPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: .module)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.setup(with: self)
    style()
  }

  private func style() {
    titleLabel.font = Fonts.Cyberpunk.h1
    titleLabel.textColor = Colors.primaryText

    descriptionLabel.font = Fonts.Timeburner.b1
    descriptionLabel.textColor = Colors.secondaryText

    specialLabel.font = Fonts.GitSans.b2
    specialLabel.textColor = Colors.specialText

    nextEventTitleLabel.font = Fonts.Timeburner.h1
    nextEventTitleLabel.textColor = Colors.specialText
    nextEventNameLabel.font = Fonts.Timeburner.h2
    nextEventNameLabel.textColor = Colors.primaryText
    nextEventDescriptionLabel.font = Fonts.Timeburner.b2
    nextEventDescriptionLabel.textColor = Colors.secondaryText
  }
}

extension HomeViewController: HomeViewPresentable {
  func configure(with viewModel: HomeViewModel) {
    title = viewModel.navBarTitle
    imageOnTop.image = viewModel.imageOnTop
    titleLabel.text = viewModel.titleLabel
    descriptionLabel.text = viewModel.descriptionLabel
    specialLabel.text = viewModel.specialLabel
    nextEventTitleLabel.text = viewModel.nextEventTitleLabel
  }

  func showNextEventInfo(_ event: Event) {
    nextEventNameLabel.text = event.name
    nextEventDescriptionLabel.text = event.description
    eventImage.load(url: event.imageURL)
  }

  func showError(viewModel: HomeViewErrorViewModel) {
    let alert = UIAlertController(title: viewModel.title,
                                  message: viewModel.message,
                                  preferredStyle: .alert)

    if let retryActionTitle = viewModel.retryAction {
      let retryAction = UIAlertAction(title: retryActionTitle,
                                      style: .default) { [weak self] _ in
        self?.presenter.retryOnErrorAlertTapped()
      }
      alert.addAction(retryAction)
    }

    let cancelAction = UIAlertAction(title: viewModel.cancelAction,
                                    style: .cancel)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
}
