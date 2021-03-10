//
//  Event.swift
//  
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import Foundation

public struct Event {
  public let id: String
  public let name: String
  public let description: String
  public let date: Date
  public let price: String
  public let currency: String
  public let imageURL: String
  public let category: String

  public init(id: String, name: String, description: String, date: Date, price: String, currency: String, imageURL: String, category: String) {
    self.id = id
    self.name = name
    self.description = description
    self.date = date
    self.price = price
    self.currency = currency
    self.imageURL = imageURL
    self.category = category
  }
}

public extension Event {
  enum CodingKeys: String, CodingKey {
    case id, name, description, date, price, currency, image, category
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: CodingKeys.id)
    name = try container.decode(String.self, forKey: CodingKeys.name)
    description = try container.decode(String.self, forKey: CodingKeys.description)
    let stringDate = try container.decode(String.self, forKey: CodingKeys.date)
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    guard let dateObject = formatter.date(from: stringDate) else {
      throw NSError()
    }
    date = dateObject
    price = try container.decode(String.self, forKey: CodingKeys.price)
    currency = try container.decode(String.self, forKey: CodingKeys.currency)
    imageURL = try container.decode(String.self, forKey: CodingKeys.image)
    category = try container.decode(String.self, forKey: CodingKeys.category)
  }

  func dateToString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    return formatter.string(from: date)
  }

  static func mock() -> Event {
    return Event(id: "123",
                 name: "Event",
                 description: "A simple event description",
                 date: Date(),
                 price: "99.99",
                 currency: "£",
                 imageURL: "",
                 category: "Movie")
  }
}

extension Event: Decodable, Identifiable {}

extension Event: Equatable {
  public static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.id == rhs.id &&
    lhs.name == rhs.name &&
    lhs.description == rhs.description &&
    lhs.date == rhs.date &&
    lhs.price == rhs.price &&
    lhs.currency == rhs.currency &&
    lhs.imageURL == rhs.imageURL &&
    lhs.category == rhs.category
  }
}
