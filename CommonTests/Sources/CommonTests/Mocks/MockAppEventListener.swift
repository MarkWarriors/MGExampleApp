//
//  MockAppEventListener.swift
//  
//
//  Created by Marco Guerrieri on 07/04/2021.
//

import Foundation
import CommonComponents

public final class MockAppEventListener: AppEventListenerType {

  public var delegate: AppEventListenerDelegate?

  public var subscribeCalled = false
  public var unsubscribeCalled = false
  public var keysAdded: [AppEventKey] = []
  public init(withKeys: [AppEventKey], notificationCenter: NotificationCenter = .default) {
    keysAdded.append(contentsOf: withKeys)
  }

  public init(notificationCenter: NotificationCenter = .default) {}

  public func subscribe(to keys: [AppEventKey]) {
    keysAdded.append(contentsOf: keys)
    subscribeCalled = true
  }

  public func unsubscribe() {
    unsubscribeCalled = true
  }
}
