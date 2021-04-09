//
//  ShrinkingCollectionViewCell.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

open class ShrinkingCollectionViewCell: UICollectionViewCell {

  enum CellState {
    case normal
    case constrict
  }
  private var cellState: CellState = .normal

  open override var isHighlighted: Bool {
    didSet {
      shrinkCell(shouldShrink: isHighlighted)
    }
  }

  open override var isSelected: Bool {
    didSet {
      shrinkCell(shouldShrink: isSelected)
    }
  }

  private func shrinkCell(shouldShrink: Bool) {
    guard ((cellState == .normal && shouldShrink) || (cellState == .constrict && !shouldShrink)) else { return }
    self.cellState = shouldShrink ? .constrict : .normal
    layer.speed = 0.0
    let newScale: CGFloat = shouldShrink ? 0.95 : 1
    UIView.animate(withDuration: 0.15, animations: {
      self.transform = CGAffineTransform(scaleX: newScale, y: newScale)
    })
    layer.speed = 1.0
  }
}

