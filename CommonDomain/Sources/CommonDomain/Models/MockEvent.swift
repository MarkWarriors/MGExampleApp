//
//  MockEvent.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import Foundation

public class MockEvent {
  public static func mock(id: String = "123",
                   name: String = "Event Name",
                   description: String = "Event Description",
                   date: Date = Date(timeIntervalSince1970: 50000000),
                   price: String = "12",
                   currency: String = "£",
                   imageURL: String = "http://imageUrl",
                   category: String = "Category") -> Event {
    return Event(id: id,
                 name: name,
                 description: description,
                 date: date,
                 price: price,
                 currency: currency,
                 imageURL: imageURL,
                 category: category)
  }
}
