//
//  UIView+Extension.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import UIKit

public extension UIView {
  private static var nib: UINib {
    return UINib(nibName: "\(classForCoder())", bundle: Bundle(for: self))
  }

  static func loadFromNib<T>() -> T {
    return nib.instantiate(withOwner: nil, options: nil).first as! T
  }

  /// Pins a view to another view with a constant of `0` for the top, right, bottom, and left anchor constraints.
  /// Additionally it will set `translatesAutoresizingMaskIntoConstraints` to `false` before pinning it.
  ///
  /// - Parameter view: The view to pin self to
  /// - Parameter insets: The insets for the pinning, defaults to zero
  func pin(toView view: UIView, withInsets insets: UIEdgeInsets = .zero) {
    self.translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right).isActive = true
    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).isActive = true
    leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
  }

  func pinToBottomOf(view: UIView, withInsets insets: UIEdgeInsets = .zero) {
    self.translatesAutoresizingMaskIntoConstraints = false
    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right).isActive = true
    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).isActive = true
    leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
  }

  func center(inView view: UIView) {
    self.translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  func constraintHeightToZero(removeSubviews: Bool) {
    if removeSubviews {
      subviews.forEach { $0.removeFromSuperview() }
    }
    self.translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 0).isActive = true
  }

  func calculateViewHeightInScreenFullWidth() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    return systemLayoutSizeFitting(CGSize(width: screenWidth, height: .greatestFiniteMagnitude)).height
  }

  func viewLayoutSize(with width: CGFloat) -> CGSize {
    var fittingSize = UIView.layoutFittingCompressedSize
    fittingSize.width = width
    let size = systemLayoutSizeFitting(fittingSize,
                                       withHorizontalFittingPriority: .required,
                                       verticalFittingPriority: .fittingSizeLevel)
    return size
  }

}
