//
//  MainAppDependencies.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation
import CommonComponents
import CommonInstances
import CommonDomain
import NotificationCenter

final class MainAppDependencies {
  static let shared = MainAppDependencies()

  private init() {}

  func currentDateProvider() -> CurrentDateProviderType {
    return CurrentDateProvider()
  }

  func accountCache() -> AccountCacheType {
    return AccountCache(with: CommonInstances.shared.userDefaults)
  }

  func appEventListener() -> AppEventListenerType {
    return AppEventListener(notificationCenter: CommonInstances.shared.notificationCenter)
  }

  func appEventBroadcaster() -> AppEventBroadcasterType {
    return AppEventBroadcaster(notificationCenter: CommonInstances.shared.notificationCenter)
  }

  func eventDetailUseCase() -> EventDetailUseCaseType {
    return EventDetailUseCase()
  }
}
