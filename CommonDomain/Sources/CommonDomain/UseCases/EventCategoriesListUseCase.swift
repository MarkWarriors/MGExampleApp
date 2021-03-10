//
//  EventCategoriesListUseCase.swift
//  
//
//  Created by Marco Guerrieri on 23/03/2021.
//

import Foundation
import Networking

public protocol EventCategoriesListUseCaseType {
  func fetch(completion: @escaping (Result<[String], Error>) -> Void)
}

public struct EventCategoriesListUseCase: EventCategoriesListUseCaseType {

  public init() {}

  public func fetch(completion: @escaping (Result<[String], Error>) -> Void) {
    let url = "/categories"

    Networking.get(url: url, model: [String].self) { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }

}
