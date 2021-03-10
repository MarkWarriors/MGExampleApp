//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 29/03/2021.
//

import Foundation
@testable import LoginModule

class MockLoginResponse {
  static func mock() -> LoginResponse {
    return LoginResponse(success: true)
  }
}
