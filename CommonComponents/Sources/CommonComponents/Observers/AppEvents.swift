//
//  AppEvents.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation

public enum AppEventKey {
  case userDidLogout
  case userDidLogin

  public func notificationName() -> NSNotification.Name {
    switch self {
    case .userDidLogout:
      return NSNotification.Name.userDidLogout
    case .userDidLogin:
      return NSNotification.Name.userDidLogin
    }
  }

  public init?(rawValue: NSNotification.Name) {
    switch rawValue {
    case .userDidLogout:
      self = .userDidLogout
    case .userDidLogin:
      self = .userDidLogin
    default:
      return nil
    }
  }
}

extension NSNotification.Name {
  public static let userDidLogout = NSNotification.Name("UserDidLogOutEvent")
  public static let userDidLogin = NSNotification.Name("UserDidLogInEvent")
}
