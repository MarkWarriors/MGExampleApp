//
//  MockLoginUseCase.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import Foundation
@testable import LoginModule

class MockLoginUseCase: LoginUseCaseType {
  public var resultToReturn: Result<LoginResponse, Error> = .failure(NSError())
  public var fetchCalled = false

  public init() {}

  func fetch(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
    fetchCalled = true
    completion(resultToReturn)
  }
}
