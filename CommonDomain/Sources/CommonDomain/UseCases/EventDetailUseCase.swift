//
//  EventDetailUseCase.swift
//  
//
//  Created by Marco Guerrieri on 01/04/2021.
//

import Foundation
import Networking

public protocol EventDetailUseCaseType {
  func fetch(eventId: String, completion: @escaping (Result<Event, Error>) -> Void)
}

public struct EventDetailUseCase: EventDetailUseCaseType {

  public init() {}

  public func fetch(eventId: String, completion: @escaping (Result<Event, Error>) -> Void) {
    let url = "/event/\(eventId)"

    Networking.get(url: url, model: Event.self) { result in
      print(result)
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }

}
