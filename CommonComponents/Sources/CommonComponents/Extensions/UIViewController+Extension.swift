//
//  UIViewController+Extension.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import UIKit

public protocol Trackable: AnyObject {
  var className: String { get }
}

extension UIViewController: Trackable {
  public var className: String {
    return ""
  }
}
