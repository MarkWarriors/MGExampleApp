//
//  AppEventsEventsListener.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation

public protocol AppEventListenerType: AnyObject {
  var delegate: AppEventListenerDelegate? { get set }
  init(notificationCenter: NotificationCenter)
  func subscribe(to keys: [AppEventKey])
  func unsubscribe()
}

public protocol AppEventListenerDelegate: AnyObject {
  func eventReceived(_ event: AppEventKey)
}

public final class AppEventListener: AppEventListenerType {
  private var keys: [AppEventKey] = []
  public weak var delegate: AppEventListenerDelegate?
  private let notificationCenter: NotificationCenter

  public init(notificationCenter: NotificationCenter) {
    self.notificationCenter = notificationCenter
  }

  public func subscribe(to keys: [AppEventKey]) {
    let filteredKeys = keys.filter { !self.keys.contains($0) }
    if filteredKeys.isEmpty { return }
    self.keys.append(contentsOf: filteredKeys)

    addObserver(for: filteredKeys)
  }

  private func addObserver(for keys: [AppEventKey]) {
    keys.forEach { key in
      notificationCenter.addObserver(self, selector: #selector(didReceive(_:)), name: key.notificationName(), object: nil)
    }
  }

  @objc private func didReceive(_ notification: NSNotification) {
    guard let appEvent = AppEventKey(rawValue: notification.name) else {
      return assertionFailure("No mapping from \(notification.name.rawValue) to a corresponding EventKey found")
    }

    delegate?.eventReceived(appEvent)
  }

  public func unsubscribe() {
    notificationCenter.removeObserver(self)
  }
}
