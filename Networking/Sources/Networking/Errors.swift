//
//  Errors.swift
//  
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import Foundation

public enum NetworkError: Error {
  case unknownError
  case connectionError
  case invalidCredentials
  case invalidRequest
  case notFound
  case invalidResponse
  case serverError
  case serverUnavailable
  case timeOut
  case unsuppotedURL
  case parsingError
}
