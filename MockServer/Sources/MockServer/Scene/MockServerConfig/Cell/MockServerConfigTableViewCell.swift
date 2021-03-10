//
//  MockServerConfigTableViewCell.swift
//  
//
//  Created by Marco Guerrieri on 30/03/2021.
//

import UIKit

class MockServerConfigTableViewCell: UITableViewCell {
  static let reuseIdentifier = "MockServerConfigTableViewCell"

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

}
