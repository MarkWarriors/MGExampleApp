//
//  ErrorsResponse.swift
//  
//
//  Created by Marco Guerrieri on 18/12/2020.
//

import Foundation
import Swifter

extension Response {
  
  struct Error {
    public static let generic: HttpResponse = {
      let reply = "{ \"Error\":\"STUB ERROR\" }"
      return HttpResponse.raw(400, "FAILURE", nil, { try $0.write([UInt8](reply.utf8))})
    }()
  }
}
