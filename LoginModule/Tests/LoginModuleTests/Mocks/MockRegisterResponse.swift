//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import Foundation
@testable import LoginModule

class MockRegisterResponse {
  static func mock() -> RegisterResponse {
    return RegisterResponse(success: true)
  }
}
