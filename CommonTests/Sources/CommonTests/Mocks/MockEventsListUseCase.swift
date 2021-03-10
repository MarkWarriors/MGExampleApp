//
//  MockEventsListUseCase.swift
//  
//
//  Created by Marco Guerrieri on 24/03/2021.
//

import Foundation
import CommonDomain

public class MockEventsListUseCase: EventsListUseCaseType {
  public var resultToReturn: Result<[Event], Error> = .failure(NSError())
  public var fetchCalled = false

  public init() {}

  public func fetch(filterCategory category: String?, completion: @escaping (Result<[Event], Error>) -> Void) {
    fetchCalled = true
    completion(resultToReturn)
  }
}
