//
//  MockAppEventBroadcaster.swift
//  
//
//  Created by Marco Guerrieri on 07/04/2021.
//

import Foundation
import CommonComponents

public final class MockAppEventBroadcaster: AppEventBroadcasterType {
  public var broadcastCalled = false
  public var broadcastEvent: AppEventKey?

  public init(notificationCenter: NotificationCenter = .default) {}

  public func broadcast(event: AppEventKey) {
    broadcastCalled = true
    broadcastEvent = event
  }
}
