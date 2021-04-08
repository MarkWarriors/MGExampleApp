//
//  SwitchTimePeriodManager.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//


import Foundation

struct TimePeriod {
  let start: Date
  let end: Date
  let timeMeasureUnit: TimeMeasureUnit
}

enum TimeMeasureUnit: Int, Comparable {
  case daily
  case weekly
  case monthly

  func toString() -> String {
    switch self {
    case .daily: return "Daily"
    case .weekly: return "Weekly"
    case .monthly: return "Monthly"
    }
  }

  static func == (lhs: TimeMeasureUnit, rhs: TimeMeasureUnit) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

  static func < (lhs: TimeMeasureUnit, rhs: TimeMeasureUnit) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

protocol SwitchTimePeriodManagerType {
  func startingTimePeriod() -> TimePeriod
  func canMoveForward(for timePeriod: TimePeriod) -> Bool
  func switchTimeMeasureUnit(of currentTimePeriod: TimePeriod, toTimeMeasureUnit: TimeMeasureUnit) -> TimePeriod
  func moveForward(_ timePeriod: TimePeriod) -> TimePeriod
  func moveBackward(_ timePeriod: TimePeriod) -> TimePeriod
  func titleFor(_ timePeriod: TimePeriod) -> String
}

class SwitchTimePeriodManager: SwitchTimePeriodManagerType {

  private lazy var yesterday: Date = {
    let today = currentDateProvider.currentDate()
    return calendar.date(byAdding: .day, value: -1, to: today) ?? today
  }()

  private let calendar: Calendar
  private let currentDateProvider: CurrentDateProviderType

  init(calendar: Calendar, currentDateProvider: CurrentDateProviderType) {
    self.calendar = calendar
    self.currentDateProvider = currentDateProvider
  }

  // MARK: Public methods

  func startingTimePeriod() -> TimePeriod {
    let startDate = calendar.startOfMonth(for: yesterday)
    let endDate = calendar.endOfMonth(for: yesterday)
    let timeMeasureUnit: TimeMeasureUnit = .monthly
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timeMeasureUnit)
  }

  func canMoveForward(for timePeriod: TimePeriod) -> Bool {
    let nextTimePeriod: TimePeriod
    switch timePeriod.timeMeasureUnit {
    case .monthly:
      nextTimePeriod = moveOneMonthForward(timePeriod)
    case .weekly:
      nextTimePeriod = moveOneWeekForward(timePeriod)
    case .daily:
      nextTimePeriod = moveOneDayForward(timePeriod)
    }
    return nextTimePeriod.start < endOfYesterday()
  }

  func switchTimeMeasureUnit(of currentTimePeriod: TimePeriod, toTimeMeasureUnit newTimeMeasureUnit: TimeMeasureUnit) -> TimePeriod {
    switch currentTimePeriod.timeMeasureUnit {
    case .monthly:
      return timePeriodFromMonthylTo(newTimeMeasureUnit, timePeriod: currentTimePeriod)
    case .weekly:
      return timePeriodFromWeeklyTo(newTimeMeasureUnit, timePeriod: currentTimePeriod)
    case .daily:
      return timePeriodFromDailyTo(newTimeMeasureUnit, timePeriod: currentTimePeriod)
    }
  }

  func moveForward(_ timePeriod: TimePeriod) -> TimePeriod {
    switch timePeriod.timeMeasureUnit {
    case .monthly:
      return moveOneMonthForward(timePeriod)
    case .weekly:
      return moveOneWeekForward(timePeriod)
    case .daily:
      return moveOneDayForward(timePeriod)
    }
  }

  func moveBackward(_ timePeriod: TimePeriod) -> TimePeriod {
    switch timePeriod.timeMeasureUnit {
    case .monthly:
      return moveOneMonthBackward(timePeriod)
    case .weekly:
      return moveOneWeekBackward(timePeriod)
    case .daily:
      return moveOneDayBackward(timePeriod)
    }
  }

  func titleFor(_ timePeriod: TimePeriod) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = calendar.timeZone

    switch timePeriod.timeMeasureUnit {
    case .daily:
      formatter.dateFormat = "EEEE dd MMMM"
    case .weekly:
      formatter.dateFormat = "dd MMMM"
      return "\(formatter.string(from: timePeriod.start)) - \(formatter.string(from: timePeriod.end))"
    case .monthly:
      formatter.dateFormat = "MMMM yyyy"
    }

    return formatter.string(from: timePeriod.start)
  }

  // MARK: Private methods

  // MARK: - Move Time Period methods

  private func moveOneDayForward(_ timePeriod: TimePeriod) -> TimePeriod {
    var components = DateComponents()
    components.day = 1
    guard let startDate = calendar.date(byAdding: components, to: timePeriod.start) else { return timePeriod }
    guard let endDate = calendar.date(byAdding: components, to: timePeriod.end) else { return timePeriod }
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timePeriod.timeMeasureUnit)
  }

  private func moveOneDayBackward(_ timePeriod: TimePeriod) -> TimePeriod {
    var components = DateComponents()
    components.day = -1
    guard let startDate = calendar.date(byAdding: components, to: timePeriod.start) else { return timePeriod }
    guard let endDate = calendar.date(byAdding: components, to: timePeriod.end) else { return timePeriod }
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timePeriod.timeMeasureUnit)
  }

  private func moveOneWeekForward(_ timePeriod: TimePeriod) -> TimePeriod {
    var components = DateComponents()
    components.weekOfYear = 1
    guard let startDate = calendar.date(byAdding: components, to: timePeriod.start) else { return timePeriod }
    guard let endDate = calendar.date(byAdding: components, to: timePeriod.end) else { return timePeriod }
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timePeriod.timeMeasureUnit)
  }

  private func moveOneWeekBackward(_ timePeriod: TimePeriod) -> TimePeriod {
    var components = DateComponents()
    components.weekOfYear = -1
    guard let startDate = calendar.date(byAdding: components, to: timePeriod.start) else { return timePeriod }
    guard let endDate = calendar.date(byAdding: components, to: timePeriod.end) else { return timePeriod }
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timePeriod.timeMeasureUnit)
  }

  private func moveOneMonthForward(_ timePeriod: TimePeriod) -> TimePeriod {
    var components = DateComponents()
    components.month = 1
    guard let nextMonthDate = calendar.date(byAdding: components, to: timePeriod.start) else { return timePeriod }
    let startDate = calendar.startOfMonth(for: nextMonthDate)
    let endDate = calendar.endOfMonth(for: nextMonthDate)
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timePeriod.timeMeasureUnit)
  }

  private func moveOneMonthBackward(_ timePeriod: TimePeriod) -> TimePeriod {
    var components = DateComponents()
    components.month = -1
    guard let previousMonthDate = calendar.date(byAdding: components, to: timePeriod.start) else { return timePeriod }
    let startDate = calendar.startOfMonth(for: previousMonthDate)
    let endDate = calendar.endOfMonth(for: previousMonthDate)
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: timePeriod.timeMeasureUnit)
  }

  // MARK: - Time Measure Unit Switch methods

  private func timePeriodFromDailyTo(_ newMeasureUnit: TimeMeasureUnit, timePeriod: TimePeriod) -> TimePeriod {
    let startDate: Date
    let endDate: Date

    switch newMeasureUnit {
    case .daily:
      return timePeriod
    case .weekly:
      startDate = calendar.startOfWeek(for: timePeriod.start)
      endDate = calendar.endOfWeek(for: timePeriod.start)
    case .monthly:
      startDate = calendar.startOfMonth(for: timePeriod.start)
      endDate = calendar.endOfMonth(for: timePeriod.start)
    }

    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: newMeasureUnit)
  }

  private func timePeriodFromWeeklyTo(_ newMeasureUnit: TimeMeasureUnit, timePeriod: TimePeriod) -> TimePeriod {
    switch newMeasureUnit {
    case .weekly:
      return timePeriod
    case .daily:
      return timePeriodFromWeeklyToDaily(timePeriod: timePeriod)
    case .monthly:
      return timePeriodFromWeeklyToMonthly(timePeriod: timePeriod)
    }
  }

  private func timePeriodFromMonthylTo(_ newMeasureUnit: TimeMeasureUnit, timePeriod: TimePeriod) -> TimePeriod {
    switch newMeasureUnit {
    case .monthly:
      return timePeriod
    case .daily:
      return timePeriodFromMonthlyToDaily(timePeriod: timePeriod)
    case .weekly:
      return timePeriodFromMonthlyToWeekly(timePeriod: timePeriod)
    }
  }

  /// Return TimePeriod for yesterday's month or the month of the first day of the week of the original TimePeriod
  private func timePeriodFromWeeklyToMonthly(timePeriod: TimePeriod) -> TimePeriod {
    let targetDay: Date

    if yesterdayIsIn(timePeriod: timePeriod) {
      targetDay = yesterday
    } else {
      if dateIsInYesterdayMonth(date: timePeriod.end) {
        targetDay = timePeriod.end
      } else {
        targetDay = timePeriod.start
      }
    }
    let startDate = calendar.startOfMonth(for: targetDay)
    let endDate = calendar.endOfMonth(for: targetDay)
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: .monthly)
  }

  /// Return TimePeriod for yesterday or the last day of the week
  private func timePeriodFromWeeklyToDaily(timePeriod: TimePeriod) -> TimePeriod {
    let targetDay = yesterdayIsIn(timePeriod: timePeriod) ? yesterday: timePeriod.end
    let startDate = calendar.startOfDay(for: targetDay)
    let endDate = calendar.endOfDay(for: targetDay)
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: .daily)
  }

  /// Return TimePeriod for yesterday or the last day of the month
  private func timePeriodFromMonthlyToDaily(timePeriod: TimePeriod) -> TimePeriod {
    let targetDay = yesterdayIsIn(timePeriod: timePeriod) ? yesterday: timePeriod.end
    let startDate = calendar.startOfDay(for: targetDay)
    let endDate = calendar.endOfDay(for: targetDay)
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: .daily)
  }

  /// Return TimePeriod for yesterday's week or the last week of the month
  private func timePeriodFromMonthlyToWeekly(timePeriod: TimePeriod) -> TimePeriod {
    let targetDay = yesterdayIsIn(timePeriod: timePeriod) ? yesterday: timePeriod.end
    let startDate = calendar.startOfWeek(for: targetDay)
    let endDate = calendar.endOfWeek(for: targetDay)
    return TimePeriod(start: startDate, end: endDate, timeMeasureUnit: .weekly)
  }

  // MARK: - Helpers

  private func endOfYesterday() -> Date {
    return calendar.endOfDay(for: yesterday)
  }

  private func yesterdayIsIn(timePeriod: TimePeriod) -> Bool {
    return yesterday.isBetween(date: timePeriod.start, andDate: timePeriod.end)
  }

  private func dateIsInYesterdayMonth(date: Date) -> Bool {
    let dateComponents = calendar.dateComponents([.month, .year],
                                                 from: date)
    let currentComponents = calendar.dateComponents([.month, .year],
                                                    from: yesterday)
    return currentComponents.month == dateComponents.month && currentComponents.year == dateComponents.year
  }

  private func dateIsInYesterdayWeek(date: Date) -> Bool {
    let dateComponents = calendar.dateComponents([.weekOfYear, .year],
                                                 from: date)
    let currentComponents = calendar.dateComponents([.weekOfYear, .year],
                                                    from: yesterday)
    return currentComponents.weekOfYear == dateComponents.weekOfYear && currentComponents.year == dateComponents.year
  }

}
