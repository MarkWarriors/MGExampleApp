//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import UIKit

public struct Haptic {
  public static let selection = Haptic(.selection)
  public static let impactLight = Haptic(.impact(.light))
  public static let impactMedium = Haptic(.impact(.medium))
  public static let impactHeavy = Haptic(.impact(.heavy))
  public static let error = Haptic(.notification(.error))
  public static let warning = Haptic(.notification(.warning))
  public static let success = Haptic(.notification(.success))

  public enum HapticType {
    case selection
    case impact(ImpactType)
    case notification(NotificationType)

    public enum ImpactType: Int {
      case light
      case medium
      case heavy
    }

    public enum NotificationType: Int {
      case error
      case success
      case warning
    }
  }

  private let type: HapticType
  private(set) var generator: Any? = nil

  public init(_ type: HapticType) {
    self.type = type
    guard #available(iOS 10.0, *) else { return }
    switch self.type {
    case .selection: generator = UISelectionFeedbackGenerator()
    case .impact(let type):
      guard let impactFeedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: type.rawValue) else {
        assertionFailure("Unable to create Apple's feedback style from raw value")
        return
      }
      generator = UIImpactFeedbackGenerator(style: impactFeedbackStyle)
    case .notification: generator = UINotificationFeedbackGenerator()
    }
  }

  public func generate(prepareForReuse: Bool = false) {
    guard Thread.isMainThread else {
      assertionFailure("Haptics should be generated on the main thread")
      return
    }
    guard #available(iOS 10.0, *) else { return }
    switch type {
    case .selection: (generator as? UISelectionFeedbackGenerator)?.selectionChanged()
    case .impact: (generator as? UIImpactFeedbackGenerator)?.impactOccurred()
    case .notification(let type):
      guard let notificationFeedbackType = UINotificationFeedbackGenerator.FeedbackType(rawValue: type.rawValue) else {
        assertionFailure("Unable to create Apple's feedback type from raw value")
        return
      }
      (generator as? UINotificationFeedbackGenerator)?.notificationOccurred(notificationFeedbackType)
    }
    if prepareForReuse {
      prepareForUse()
    }
  }

  public func prepareForUse() {
    guard Thread.isMainThread else {
      assertionFailure("Haptics should be prepared for reuse on the main thread")
      return
    }
    guard #available(iOS 10.0, *) else { return }
    (generator as? UIFeedbackGenerator)?.prepare()
  }
}
