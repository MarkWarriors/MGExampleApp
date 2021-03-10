//
//  LoginRoute.swift
//  
//
//  Created by Marco Guerrieri on 26/03/2021.
//

import Foundation
import Swifter

struct LoginRoute: RoutesProvider {
  private static let builder = ResponseBuilder()

  static func routes() -> [String: Route] {
    return [
      "/register": .mapping(registerResponse),
      "/login": .mapping(loginResponse)
    ]
  }
}

extension LoginRoute {
  private enum Keys {
    case name
  }

  private static func loginResponse(_ request: HttpRequest) -> HttpResponse {
    let jsonFileName = "login"

    if Bundle.module.path(forResource: jsonFileName, ofType: "json") != nil {
      return builder.generateJsonResponse(jsonFileName)
    }

    return builder.errorResponse()
  }

  private static func registerResponse(_ request: HttpRequest) -> HttpResponse {
    let jsonFileName = "register"

    if Bundle.module.path(forResource: jsonFileName, ofType: "json") != nil {
      return builder.generateJsonResponse(jsonFileName)
    }

    return builder.errorResponse()
  }
}
