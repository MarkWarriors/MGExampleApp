//
//  Collection+Extension.swift
//  
//
//  Created by Marco Guerrieri on 10/03/2021.
//

import Foundation

public extension Collection {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }

  var isNotEmpty: Bool {
    return !isEmpty
  }
}

