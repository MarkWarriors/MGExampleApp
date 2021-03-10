//
//  Routes.swift
//  
//
//  Created by Marco Guerrieri on 18/12/2020.
//

import UIKit
import Swifter

protocol RoutesProvider {
  static func routes() -> [String: Route]
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

struct Routes {
  static func allRoutes() -> [String: Route] {
    var routes = EventsRoutes.routes()
    routes.update(other: CategoriesRoutes.routes())
    routes.update(other: LoginRoute.routes())
    return routes
  }
}

enum Route {
  case jsonFile(_ file: String)
  case mapping(_ map: ((HttpRequest) -> HttpResponse))

  func handle(request: HttpRequest) -> HttpResponse {
    let responseToReturn = MockServerStore.shared.get(key: request.path)
    switch responseToReturn {
    case .failure:
      return Response.Error.generic
    default:
      break
    }

    switch self {
    case .jsonFile(let fileName):
      guard let filePath = Bundle.module.path(forResource: fileName, ofType: "json") else {
        return Response.Error.generic
      }

      return generateJsonResponse(filePath)

    case .mapping(let handler):
      return handler(request)
    }
  }

  private func generateJsonResponse(_ filePath: String) -> HttpResponse {
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
      let response = String(data: data, encoding: .utf8)!
      let _ = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
      return HttpResponse.raw(200, "OK", nil, { try $0.write([UInt8](response.utf8)) })
    } catch {
      assertionFailure("Invalid json format: \(filePath)")
    }
    return Response.Error.generic
  }
}




