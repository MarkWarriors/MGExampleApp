//
//  MockEventDetailsUseCase.swift
//  
//
//  Created by Marco Guerrieri on 01/04/2021.
//

import Foundation
import CommonDomain

public class MockEventDetailsUseCase: EventDetailUseCaseType {
  public var resultToReturn: Result<Event, Error> = .failure(NSError())
  public var fetchCalled = false

  public init() {}

  public func fetch(eventId: String, completion: @escaping (Result<Event, Error>) -> Void) {
    fetchCalled = true
    completion(resultToReturn)
  }
}
