//
//  SelectTextOnlyTextView.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public class SelectTextOnlyTextView: UITextView {
  public var enableOnlyTextSelection = false

  open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    guard enableOnlyTextSelection else { return super.canPerformAction(action, withSender: sender) }
    if [#selector(selectAll(_:)), #selector(select(_:))].contains(action) { return super.canPerformAction(action, withSender: sender) }
    return false
  }
}
