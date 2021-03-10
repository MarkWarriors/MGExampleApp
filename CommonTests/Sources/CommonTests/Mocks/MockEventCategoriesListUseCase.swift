//
//  MockEventCategoriesListUseCase.swift
//  
//
//  Created by Marco Guerrieri on 01/04/2021.
//

import Foundation
import CommonDomain

public class MockEventCategoriesListUseCase: EventCategoriesListUseCaseType {
  public var resultToReturn: Result<[String], Error> = .failure(NSError())
  public var fetchCalled = false

  public init() {}

  public func fetch(completion: @escaping (Result<[String], Error>) -> Void) {
    fetchCalled = true
    completion(resultToReturn)
  }
}
