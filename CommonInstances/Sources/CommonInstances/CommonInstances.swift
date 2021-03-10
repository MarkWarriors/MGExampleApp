import Foundation

public struct CommonInstances {
  public static let shared = CommonInstances()

  private init() {}

  public let notificationCenter = NotificationCenter()
  public let userDefaults = UserDefaults.standard
}
