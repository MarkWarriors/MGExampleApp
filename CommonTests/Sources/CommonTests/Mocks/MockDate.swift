//
//  MockDate.swift
//  
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import Foundation

public class MockDate {
  public static func mock() -> Date {
    return Date(timeIntervalSince1970: 50000000)
  }
}
