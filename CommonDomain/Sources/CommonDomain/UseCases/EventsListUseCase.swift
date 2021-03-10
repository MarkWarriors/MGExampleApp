//
//  EventsListUseCase.swift
//  
//
//  Created by Marco Guerrieri on 23/03/2021.
//

import Foundation
import Networking

public protocol EventsListUseCaseType {
  func fetch(filterCategory category: String?, completion: @escaping (Result<[Event], Error>) -> Void)
}

public struct EventsListUseCase: EventsListUseCaseType {
  
  public init() {}

  public func fetch(filterCategory category: String? = nil, completion: @escaping (Result<[Event], Error>) -> Void) {
    let url = "/events/\(category ?? "")"

    Networking.get(url: url, model: [Event].self) { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }

}
