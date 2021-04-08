//
//  CharacterSet+Extension.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import Foundation

extension CharacterSet {
  public static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
