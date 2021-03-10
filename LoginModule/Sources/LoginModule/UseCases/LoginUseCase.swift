//
//  LoginUseCase.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import Networking

protocol LoginUseCaseType {
  func fetch(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
}

struct LoginUseCase: LoginUseCaseType {
  init() {}

  func fetch(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
    let url = "/login"
    let params = ["username": username,
                  "password": password]

    Networking.post(url: url, model: LoginResponse.self, params: params, completion: { result in
      DispatchQueue.main.async {
        completion(result)
      }
    })
  }
}

struct LoginResponse: Decodable {
  let success: Bool
}
