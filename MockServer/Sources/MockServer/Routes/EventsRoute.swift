//
//  EventsRoute.swift
//  
//
//  Created by Marco Guerrieri on 18/12/2020.
//

import Foundation

struct EventsRoutes: RoutesProvider {
  static func routes() -> [String: Route] {
    return [
      "/event/123": .jsonFile("eventDetails"),
      "/events/": .jsonFile("events"),
      "/events/all": .jsonFile("events"),
      "/events/art": .jsonFile("eventsArt"),
      "/events/movie": .jsonFile("eventsMovie"),
      "/events/music": .jsonFile("eventsMusic"),
      "/events/travel": .jsonFile("eventsTravel")
    ]
  }
}
