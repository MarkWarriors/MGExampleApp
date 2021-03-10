//
//  Networking.swift
//
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import Foundation
import Alamofire

public struct Networking {
  public static func setup(with config: NetworkingConfigType.Type) {
    ConfigType.shared = ConfigType(config)
  }

  public static func get<T: Decodable>(url: String, model: T.Type, completion: @escaping (Result<T, Error>)->()) {
    guard let requestUrl = generateCompleteURL(path: url) else {
      completion(.failure(NSError()))
      return
    }

    let request = AF.request(requestUrl, method: .get)

    request.responseDecodable { (response: DataResponse<T, AFError>) in
      guard response.error == nil else {
        completion(.failure(NSError()))
        return
      }

      guard let decodedData = response.value else {
        completion(.failure(NSError()))
        return
      }

      completion(.success(decodedData))
    }
  }

  public static func post<T: Decodable>(url: String, model: T.Type, params: [String: Any], completion: @escaping (Result<T, Error>)->()) {
    guard let requestUrl = generateCompleteURL(path: url) else {
      completion(.failure(NSError()))
      return
    }

    let request = AF.request(requestUrl, method: .post, parameters: params)

    request.responseDecodable { (response: DataResponse<T, AFError>) in
      guard response.error == nil else {
        completion(.failure(NSError()))
        return
      }

      guard let decodedData = response.value else {
        completion(.failure(NSError()))
        return
      }

      completion(.success(decodedData))
    }
  }

  internal static func generateCompleteURL(path: String) -> URL? {
    return Config.baseURL.appendingPathComponent(path)
  }
}
