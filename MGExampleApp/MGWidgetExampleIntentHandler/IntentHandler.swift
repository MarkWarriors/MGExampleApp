//
//  IntentHandler.swift
//  MGWidgetExampleIntentHandler
//
//  Created by Marco Guerrieri on 23/03/2021.
//

import Intents
import CommonDomain
import MockServer
import Networking

class IntentHandler: INExtension, ConfigurationIntentHandling {
  private let useCase = EventCategoriesListUseCase()

  func provideFilterCategoryOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<FilterCategory>?, Error?) -> Void) {
    guard MainAppConfig.isProdEnv else {
      fakeCategories(completion: completion)
      return
    }

    useCase.fetch(completion: { result in
      switch result {
      case .success(let categoriesList):
        let categories = categoriesList.map { category -> FilterCategory in
          let item = FilterCategory(identifier: category,
                                    display: category.capitalized)
          return item
        }
        let collection = INObjectCollection(items: categories)
        completion(collection, nil)
      default:
        completion(nil, NSError())
      }
    })
  }

  private func fakeCategories(completion: @escaping (INObjectCollection<FilterCategory>?, Error?) -> Void) {
    Networking.setup(with: MainAppConfig.self)
    let stubCategories = [FilterCategory(identifier: "art",
                                         display: "Art"),
                          FilterCategory(identifier: "movie",
                                         display: "Movies"),
                          FilterCategory(identifier: "music",
                                         display: "Music"),
                          FilterCategory(identifier: "Travel",
                                         display: "Travel")]
    let collection = INObjectCollection(items: stubCategories)
    completion(collection, nil)
  }
}
