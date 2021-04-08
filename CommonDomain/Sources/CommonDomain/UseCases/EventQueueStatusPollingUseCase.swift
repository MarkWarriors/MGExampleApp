//
//  EventQueueStatusPollingUseCase.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation
import Networking
import CommonComponents

protocol EventQueueStatusPollingUseCaseType {
  func fetch(eventId: String, _ completion: @escaping (EventQueueStatusPollingUseCaseResult) -> Void)
  func cancelPolling()
}

struct QueueStatus: Decodable {
  let status: Status

  enum Status: String, Decodable {
    case eventCancelled
    case eventFullyBooked
    case eventQueueOpen
    case failed
  }

}

enum EventQueueStatusPollingUseCaseResult {
  case queueClosed(QueueStatus)
  case taskFailed
  case timeoutReached
  case pollingCancelled
}

final class EventQueueStatusPollingUseCase: EventQueueStatusPollingUseCaseType {
  private enum PollingStatus {
    case receivedFinalStatus(QueueStatus)
    case taskIsPending
    case taskIsFailed
    case networkError
  }

  private var pollingTimer: DispatchTimerRepeater?
  private var timeoutTimer: Timer?

  private let timeoutInterval: Double = 120
  private var cancelPollingRequested = false

  init() { }

  deinit {
    safelyRemoveTimerIfNeeded()
  }

  func cancelPolling() {
    cancelPollingRequested = true
  }

  func fetch(eventId: String, _ completion: @escaping (EventQueueStatusPollingUseCaseResult) -> Void) {
    timeoutTimer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false, block: { [weak self] _ in
      self?.safelyRemoveTimerIfNeeded()
      completion(.timeoutReached)
    })

    pollingTimer = DispatchTimerRepeater(timeInterval: 1)
    cancelPollingRequested = false

    pollingTimer?.eventHandler = {
      self.pollingTimer?.suspend()

      if self.cancelPollingRequested {
        self.safelyRemoveTimerIfNeeded()
        completion(.pollingCancelled)
        return
      }

      self.polling(eventId: eventId) { pollingStatus in
        switch pollingStatus {
        case let .receivedFinalStatus(status):
          self.safelyRemoveTimerIfNeeded() // Need to be called before completion
          DispatchQueue.main.async { completion(.queueClosed(status)) }

        case .taskIsPending, .networkError: // Silent retry on network error
          self.pollingTimer?.resume()

        case .taskIsFailed:
          self.safelyRemoveTimerIfNeeded() // Need to be called before completion
          DispatchQueue.main.async { completion(.taskFailed) }
        }
      }
    }
    pollingTimer?.resume()
  }

  private func polling(eventId: String, _ completion: @escaping (PollingStatus) -> Void) {
    Networking.get(url: "event/\(eventId)/queueStatus", model: QueueStatus.self) { result in
      switch result {
      case let .success(queueStatus):
        switch queueStatus.status {
        case .eventCancelled:
          completion(.receivedFinalStatus(queueStatus))
        case .eventFullyBooked:
          completion(.receivedFinalStatus(queueStatus))
        case .eventQueueOpen:
          completion(.taskIsPending)
        case .failed:
          completion(.taskIsFailed)
        }
      case .failure:
        completion(.networkError)
      }
    }
  }

  private func safelyRemoveTimerIfNeeded() {
    timeoutTimer?.invalidate()
    timeoutTimer = nil
    pollingTimer?.suspend()
    pollingTimer = nil
  }

}
