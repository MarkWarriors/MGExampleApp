//
//  Labels.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit

@propertyWrapper
public class TitleLabel<T> {
  public var wrappedValue: T? {
    didSet {
      wrappedValue.map(applyStyle)
    }
  }
  private let applyStyle: (T) -> Void
  public init(_ applyStyle: @escaping (T) -> Void) {
    self.applyStyle = applyStyle
  }
}

extension TitleLabel where T == UILabel {
  public convenience init() {
    self.init({
        $0.textColor = Colors.primaryText
        $0.font = Fonts.Cyberpunk.b1
        $0.sizeToFit()
    })
  }
}
