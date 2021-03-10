//
//  CategoriesRoutes.swift
//  
//
//  Created by Marco Guerrieri on 18/12/2020.
//

import Foundation

struct CategoriesRoutes: RoutesProvider {
  static func routes() -> [String: Route] {
    return [
      "/categories": .jsonFile("categories"),
    ]
  }
}
