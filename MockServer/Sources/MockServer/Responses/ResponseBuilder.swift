//
//  ResponseBuilder.swift
//  
//
//  Created by Marco Guerrieri on 30/03/2021.
//

import Foundation
import Swifter

class ResponseBuilder: NSObject {

  required override init() {
    super.init()
  }

  public func staticResponse(endPoint: String) -> HttpResponse {
    guard var pathIndex = endPoint.lastIndex(of: "/") else {
      return ResponseBuilder().notFoundResponse("Not Found")
    }

    pathIndex = endPoint.index(after: pathIndex)
    let fileName = String(endPoint[pathIndex...])
    guard var index = fileName.lastIndex(of: ".") else {
      return ResponseBuilder().errorResponse()
    }

    let fname = String(fileName[..<index])
    index = fileName.index(after: index)
    let ftype = String(fileName[index...])

    if let htmlPath = Bundle.module.path(forResource: fname, ofType: ftype), let file = try? htmlPath.openForReading()  {
      return .raw(200, "OK", [:], { writer in
        try? writer.write(file)
        file.close()
      })
    } else {
      return ResponseBuilder().errorResponse()
    }
  }

  func generateResponse(_ input: HttpRequest) -> HttpResponse {
    return self.errorResponse()
  }

  public func goodResponse(_ response: String) -> HttpResponse {
    return HttpResponse.raw(200, "OK", nil, { try $0.write([UInt8](response.utf8)) })
  }

  public func goodResponseWithHdrs(_ response: String, _ hdrs: [String: String]) -> HttpResponse {
    return HttpResponse.raw(200, "OK", hdrs, { try $0.write([UInt8](response.utf8)) })
  }

  public func noContent(_ response: String) -> HttpResponse {
    return HttpResponse.raw(204, "", nil, { try $0.write([UInt8](response.utf8)) })
  }

  public func redirectionResponse(location: String) -> HttpResponse {
    return HttpResponse.raw(302, "", ["Location": location], { try $0.write([UInt8]("".utf8)) })
  }

  public func unAuthorizedResponse(_ response: String) -> HttpResponse {
    return HttpResponse.raw(401, "OK", nil, { try $0.write([UInt8](response.utf8)) })
  }

  public func serverErrorResponse(_ response: String) -> HttpResponse {
    return HttpResponse.raw(500, "OK", nil, { try $0.write([UInt8](response.utf8))})
  }

  public func notFoundResponse(_ response: String) -> HttpResponse {
    return HttpResponse.raw(404, "OK", nil, { try $0.write([UInt8](response.utf8))})
  }

  public func errorResponse() -> HttpResponse {
    let reply = "{ \"Error\":\"STUB ERROR\" }"
    return HttpResponse.raw(400, "FAILURE", nil, { try $0.write([UInt8](reply.utf8))})
  }

  public func errorResponse(code: Int, error: Error) -> HttpResponse {
    return HttpResponse.raw(code, "FAILURE", nil, nil)
  }

  public func serverErrorResponse() -> HttpResponse {
    return HttpResponse.internalServerError
  }

  public func serverTimeOutResponse() -> HttpResponse {
    sleep(100)
    return HttpResponse.notFound
  }

  public func generateResponse(type:String) -> HttpResponse{
    switch type {
    case "timeout":
      return self.serverTimeOutResponse()
    case "serverError":
      return self.serverErrorResponse()
    default:
      return self.errorResponse()
    }
  }

  public func generateJsonResponse(_ jsonFile: String, changes: [String: String]? = nil) -> HttpResponse {
    let response = jsonContent(jsonFile, changes: changes)
    return self.goodResponse(response)
  }

  public func generateJsonResponseWithHdrs(_ jsonFile: String, changes: [String: String]? = nil, hdrs: [String: String]) -> HttpResponse {
    let response = jsonContent(jsonFile, changes: changes)
    return self.goodResponseWithHdrs(response, hdrs)
  }

  public func jsonContent(_ jsonFile: String, changes: [String: String]? = nil) -> String {
    var response = ""
    if let path = Bundle.module.path(forResource: jsonFile, ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        var str: String = String(data: data, encoding: .utf8)!

        if let uchanges = changes {
          for key in uchanges.keys {
            str = str.replacingOccurrences(of: key, with: uchanges[key]!)
          }
        }
        response = str
        let newData = str.data(using: .utf8)
        let _ = try JSONSerialization.jsonObject(with: newData!, options: .mutableLeaves)
      } catch {
        assertionFailure("Invalid json format: \(jsonFile)")
      }
    } else {
      assertionFailure("Invalid json file: \(jsonFile)")
    }

    return response
  }

}
