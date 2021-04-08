//
//  UIAlertController+Extension.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public extension UIAlertController {
  static func loadingAlert(message: String) -> UIAlertController {
    let alert = UIAlertController(title: nil,
                    message: message,
                    preferredStyle: .alert)
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    activityIndicator.style = .medium
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    alert.view.addSubview(activityIndicator)
    return alert
  }
}
