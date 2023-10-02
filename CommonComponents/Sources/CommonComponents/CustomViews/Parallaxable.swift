//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public protocol Parallaxable: AnyObject {
  /// A value in the range of -1 to +1
  var parallax: CGFloat { get set }
  var frame: CGRect { get }
}

extension UITableView {
  public func parallaxVisibleCells(against view: UIView)  {
    let cells = visibleCells.compactMap { $0 as? Parallaxable }
    parallax(items: cells, against: view)
  }
}

extension UICollectionView {
  public func parallaxVisibleCells(against view: UIView)  {
    let cells = visibleCells.compactMap { $0 as? Parallaxable }
    parallax(items: cells, against: view)
  }
}

extension UIScrollView {
  public func parallax(items: [Parallaxable], against view: UIView) {
    items.forEach { item in
      let cellMidpointInOwnCordinateSpace = CGPoint(x: 0, y: item.frame.midY)
      let midpointOfCellInMainViewController = view.convert(cellMidpointInOwnCordinateSpace, from: self)
      let parallaxAsAPercentage = midpointOfCellInMainViewController.y / frame.height

      // these calculations below transform the percentage from 0 - 1 (as %) to the range of -1 to +1
      let parallaxOffsetToAllowForNegativeRange = parallaxAsAPercentage - 0.5
      let parallaxAsRange = -parallaxOffsetToAllowForNegativeRange * 2
      item.parallax = parallaxAsRange
    }
  }
}
