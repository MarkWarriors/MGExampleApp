//
//  EventCellView.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import UIKit
import CommonUI
import CommonComponents

struct EventTableViewCellViewModel {
  let title: String
  let description: String
}

class EventTableViewCell: UITableViewCell {
  static let reuseIdentifier = "EventTableViewCell"

  @TitleLabel() @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    style()
  }

  private func style() {
    titleLabel.font = Fonts.Timeburner.h2
    titleLabel.textColor = Colors.primaryText

    descriptionLabel.font = Fonts.Timeburner.b1
    descriptionLabel.textColor = Colors.secondaryText
  }

  func configure(with viewModel: EventTableViewCellViewModel) {
    titleLabel.text = viewModel.title
    descriptionLabel.text = viewModel.description
  }

}
