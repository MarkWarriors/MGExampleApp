//
//  URLOpener.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public protocol URLOpenerProtocol {
  func open(_ url: URL)
}

public struct URLOpener: URLOpenerProtocol {
  public init() {}
  
  public func open(_ url: URL) {
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}
