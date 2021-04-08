//
//  DispatchTimerRepeater.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation

public class DispatchTimerRepeater {
  private enum State {
    case suspended
    case resumed
  }

  private var state: State = .suspended

  public let timeInterval: TimeInterval
  public var eventHandler: (() -> Void)?

  private lazy var timer: DispatchSourceTimer = {
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
    timer.schedule(deadline: .now(), repeating: self.timeInterval)
    timer.setEventHandler(handler: { [weak self] in
      self?.eventHandler?()
    })
    return timer
  }()

  public init(timeInterval: TimeInterval) {
    self.timeInterval = timeInterval
  }

  deinit {
    timer.setEventHandler {}
    timer.cancel()
    // If the timer is suspended, calling cancel without resuming triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
    resume()
    eventHandler = nil
  }

  public func resume() {
    if state == .resumed {
      return
    }
    state = .resumed
    timer.resume()
  }

  public func suspend() {
    if state == .suspended {
      return
    }
    state = .suspended
    timer.suspend()
  }
}
