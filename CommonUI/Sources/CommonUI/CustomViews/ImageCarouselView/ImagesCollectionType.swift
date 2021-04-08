//
//  ImagesCollectionType.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public enum ImagesCollectionType {
  case local(with: [UIImage])
  case remote(from: [URL])

  var count: Int {
    switch self {
    case .local(let images):
      return images.count
    case .remote(let images):
      return images.count
    }
  }
}
