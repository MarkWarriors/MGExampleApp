//
//  TimeZone+Extension.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation

public extension TimeZone {

  static var UTC: TimeZone? {
    return TimeZone(secondsFromGMT: 0)
  }

  static var IT: TimeZone? {
    return TimeZone(identifier: "Europe/Italy")
  }

  static var UK: TimeZone? {
    return TimeZone(identifier: "Europe/London")
  }

  static var USA_LosAngeles: TimeZone? {
    return TimeZone(identifier: "America/Los_Angeles")
  }
}
