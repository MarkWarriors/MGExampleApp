//
//  AppEventsBroadcaster.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation

public protocol AppEventBroadcasterType {
  func broadcast(event: AppEventKey)
  init(notificationCenter: NotificationCenter)
}

public final class AppEventBroadcaster: AppEventBroadcasterType {
  private let notificationCenter: NotificationCenter

  public init(notificationCenter: NotificationCenter) {
    self.notificationCenter = notificationCenter
  }

  public func broadcast(event: AppEventKey) {
    notificationCenter.post(name: event.notificationName(), object: nil)
  }
}
