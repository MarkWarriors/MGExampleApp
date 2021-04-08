//
//  DateFormatter+Extension.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation

extension DateFormatter {

  public func string(from date: Date, with timeZone: TimeZone) -> String {
    let oldTimeZone = self.timeZone
    self.timeZone = timeZone
    let dateString = string(from: date)
    self.timeZone = oldTimeZone
    return dateString
  }

  public static func createStringFormatForTimeslotWith(startDate: Date, endDate: Date) -> String {
    return "\(dayOfWeekDateMonth.string(from: startDate)), \(timeRange(start: startDate, end: endDate))"
  }
  
  /// Returns a formatted Date Period `String`
  /// e.g. Dates in the same year: 10 February - 10 March 2020
  /// e.g. Dates in distinct years: 10 December 2019 - 10 January 2020
  ///
  /// - Parameters:
  ///   - startDate:  The start date of the period.
  ///   - endDate: The end date of the period.
  public static func createStringFormatForPeriod(startDate: Date, endDate: Date) -> String {
    let dateFormatter = DateFormatter()

    let calendar = Calendar.current
    let startDateYear = calendar.component(.year, from: startDate)
    let endDateYear = calendar.component(.year, from: endDate)

    guard startDateYear == endDateYear else {
      let startDateString = dateFormatter.string(from: startDate)
      let endDateString = dateFormatter.string(from: endDate)
      return "\(startDateString) - \(endDateString)"
    }

    let startDateString = dateMonth.string(from: startDate)
    let endDateString = dateFormatter.string(from: endDate)
    return "\(startDateString) - \(endDateString)"
  }

  /// Example: J for January
  public static var abbreviatedMonth: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMMM"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: 12 Dec
  public static var abbreviatedDateMonth: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: 12 December
  public static var dateMonth: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: Tue, 12 Dec
  public static var shortDayOfWeekDateShortMonth: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EE, dd MMM"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: Tuesday 12 December
  public static var dayOfWeekDateMonth: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE dd MMMM"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: APRIL 2020
  public static var dateMonthAndYear: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM YYYY"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: 01/12/20
  public static var dateDayMonthAndYear: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/YY"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: 1 December 2020
  public static var dateDayMonthAndYearLongform: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM YYYY"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// full  Year, example:  2020
  public static var dateYear: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Month, example: 12
  public static var dateMonthNumber: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: Tuesday, 12 December 2020
  public static var dayOfWeekDateMonthYear: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: 1pm
  public static var timeWithAmPm: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.amSymbol = "am"
    dateFormatter.pmSymbol = "pm"
    dateFormatter.dateFormat = "ha"
    dateFormatter.timeZone = .UK
    return dateFormatter
  }()

  /// Example: 12pm[nbsp]-[nbsp]3pm
  /// - Parameter start: the first date to use
  /// - Parameter end: the second date to use
  public static func timeRange(start: Date, end: Date) -> String {
    let first = timeWithAmPm.string(from: start)
    let second = timeWithAmPm.string(from: end)
    return "\(first)\u{00a0}\u{2011}\u{00a0}\(second)"
  }
}
