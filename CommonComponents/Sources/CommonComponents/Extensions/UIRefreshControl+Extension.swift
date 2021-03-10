//
//  UIRefreshControl+Extension.swift
//  
//
//  Created by Marco Guerrieri on 23/03/2021.
//

import UIKit

public extension UIRefreshControl {

  func restartSpinnerAnimationIfNeeded() {
    guard let scrollView = superview as? UIScrollView else { return }
    if isRefreshing {
      triggerPullToRefresh()
    } else if scrollView.contentOffset.y < 0 {
      scrollView.setContentOffset(.zero, animated: false)
    }
  }

  func triggerPullToRefresh() {
    guard let scrollView = superview as? UIScrollView else { return }
    endRefreshing()
    scrollView.contentOffset = .zero
    scrollView.setContentOffset(CGPoint(x: 0, y: -frame.height), animated: true)
    beginRefreshing()
  }
}
