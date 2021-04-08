//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation

public extension Date {

  var year: Int {
    return year(for: Calendar.current)
  }
  
  func year(for calendar: Calendar) -> Int {
    let components = calendar.dateComponents([.year], from: self)
    return components.year ?? 0
  }

  func month(for calendar: Calendar) -> Int {
    let components = calendar.dateComponents([.month], from: self)
    return components.month ?? 0
  }

  func isNotBetween(date date1: Date, andDate date2: Date) -> Bool {
    return !isBetween(date: date1, andDate: date2)
  }

  func isBetween(date date1: Date, andDate date2: Date) -> Bool {
    return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
  }
}
