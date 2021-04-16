//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 15/04/2021.
//

import UIKit

@propertyWrapper
class Styled<T> {
  var wrappedValue: T? {
    didSet {
      wrappedValue.map(applyStyle)
    }
  }
  private let applyStyle: (T) -> Void
  init(_ applyStyle: @escaping (T) -> Void) {
    self.applyStyle = applyStyle
  }
}

extension Styled where T == UIButton {
  convenience init(_ style: UIButton.Style) {
    self.init({ _ in
      switch style {
      case .normal:
        break
      case .cancel:
        break
      }
    })
  }
}

extension UIButton {
  enum Style {
    case normal
    case cancel
  }
}
