//
//  UIImageView+Extension.swift
//  
//
//  Created by Marco Guerrieri on 18/12/2020.
//

import UIKit

public extension UIImageView {
  func load(url: String) {
    let loader = UIActivityIndicatorView(style: .large)
    DispatchQueue.main.async {
      loader.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(loader)
      loader.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      loader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      self.layoutIfNeeded()
      loader.startAnimating()
    }
    guard let requestUrl = URL(string: url) else { return }
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: requestUrl) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
      DispatchQueue.main.async {
        loader.stopAnimating()
        loader.isHidden = true
        loader.removeFromSuperview()
      }
    }
  }
}
