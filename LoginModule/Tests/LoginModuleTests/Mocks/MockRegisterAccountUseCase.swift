//
//  MockRegisterAccountUseCase.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import Foundation
@testable import LoginModule

class MockRegisterAccountUseCase: RegisterAccountUseCaseType {
  public var resultToReturn: Result<RegisterResponse, Error> = .failure(NSError())
  public var fetchCalled = false

  public init() {}

  func fetch(completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
    fetchCalled = true
    completion(resultToReturn)
  }
}
