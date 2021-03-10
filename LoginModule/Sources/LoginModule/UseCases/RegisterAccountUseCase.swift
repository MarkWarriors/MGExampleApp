//
//  RegisterAccountUseCase.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import Networking

protocol RegisterAccountUseCaseType {
  func fetch(completion: @escaping (Result<RegisterResponse, Error>) -> Void)
}

struct RegisterAccountUseCase: RegisterAccountUseCaseType {
  init() {}

  func fetch(completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
    let url = "/register"

    Networking.get(url: url, model: RegisterResponse.self) { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }
}

struct RegisterResponse: Decodable {
  let success: Bool
}
