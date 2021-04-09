//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public protocol XIBLoadable: class {
  static func loadFromXib() -> Self
}

public extension XIBLoadable {
  static func loadFromXib() -> Self {
    let nibName = String(describing: self)
    let bundle = Bundle(for: self)
    let nib = UINib(nibName: nibName, bundle: bundle)
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
      fatalError("could not instantiate nib")
    }
    return view
  }
}
