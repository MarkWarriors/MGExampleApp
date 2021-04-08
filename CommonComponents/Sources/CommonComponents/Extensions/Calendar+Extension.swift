//
//  Calendar+Extension.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation

public extension Calendar {

  func isDateTodayOrInTheFuture(_ date: Date) -> Bool {
    let todayStart = startOfDay(for: Date())
    return date >= todayStart
  }

  func isDateNotToday(_ date: Date) -> Bool {
    return !isDateInToday(date)
  }

  func endOfDay(for date: Date) -> Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1
    return self.date(byAdding: components, to: startOfDay(for: date))!
  }

  func startOfMonth(for date: Date) -> Date {
    let components = dateComponents([.year, .month], from: date)
    let firstDay = self.date(from: components)!
    return startOfDay(for: firstDay)
  }

  func endOfMonth(for date: Date) -> Date {
    var components = DateComponents()
    components.month = 1
    components.day = -1
    let endDate = self.date(byAdding: components, to: startOfMonth(for: date))!
    return endOfDay(for: endDate)
  }

  func startOfWeek(for date: Date) -> Date {
    let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfDay(for: date))
    return self.date(from: components)!
  }

  func endOfWeek(for date: Date) -> Date {
    var components = DateComponents()
    components.day = 6
    let endDate = self.date(byAdding: components, to: startOfWeek(for: date))!
    return endOfDay(for: endDate)
  }

  func previousMonthStart(for date: Date) -> Date {
    var components = DateComponents()
    components.month = -1
    return self.date(byAdding: components, to: startOfMonth(for: date))!
  }

  func nextMonthStart(for date: Date) -> Date {
    var components = DateComponents()
    components.month = 1
    return self.date(byAdding: components, to: startOfMonth(for: date))!
  }

  func previousWeekStart(for date: Date) -> Date {
    var components = DateComponents()
    components.weekOfYear = -1
    return self.date(byAdding: components, to: startOfDay(for: date))!
  }

  func nextWeekStart(for date: Date) -> Date {
    var components = DateComponents()
    components.weekOfYear = 1
    return self.date(byAdding: components, to: startOfDay(for: date))!
  }

  func previousDayStart(for date: Date) -> Date {
    var components = DateComponents()
    components.day = -1
    return self.date(byAdding: components, to: startOfDay(for: date))!
  }

  func nextDayStart(for date: Date) -> Date {
    var components = DateComponents()
    components.day = 1
    return self.date(byAdding: components, to: startOfDay(for: date))!
  }

  func numberOfDays(from startDate: Date, to endDate: Date) -> Int? {
    let trimStartDate = startOfDay(for: startDate)
    let trimEndDate = startOfDay(for: endDate)
    let calendarComponents = dateComponents([.day], from: trimStartDate, to: trimEndDate)
    return calendarComponents.day
  }
}
