//
//  ShrinkingTableViewCell.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

open class ShrinkingTableViewCell: UITableViewCell {

  enum CellState {
    case normal
    case constrict
  }

  private var cellState: CellState = .normal
  open var shrinkingView: UIView?

  open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    shrinkCell(shouldShrink: highlighted)
    super.setHighlighted(highlighted, animated: animated)
  }

  open override func setSelected(_ selected: Bool, animated: Bool) {
    shrinkCell(shouldShrink: selected)
    super.setSelected(selected, animated: animated)
  }

  private func shrinkCell(shouldShrink: Bool) {
    guard ((cellState == .normal && shouldShrink) || (cellState == .constrict && !shouldShrink)) else { return }
    self.cellState = shouldShrink ? .constrict : .normal
    layer.speed = 0.0
    let newScale: CGFloat = shouldShrink ? 0.95 : 1
    let viewToShrink = shrinkingView ?? self
    UIView.animate(withDuration: 0.15, animations: {
      viewToShrink.transform = CGAffineTransform(scaleX: newScale, y: newScale)
    })
    layer.speed = 1.0
  }
}
