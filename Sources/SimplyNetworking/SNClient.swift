//
//  APIClientProtocol.swift
//  Simply Networking
//
//  Created by Lee Burrows on 28/10/2019.
//  Copyright © 2019 Lee Burrows. All rights reserved.
//

import Foundation

public enum NetworkLoaderError: Error, Equatable {
    case message(_ message: String)
    case statusCodeFailure(code: Int)
    
}

public protocol APIClientProtocol {
    var urlSession: URLSession { get }
    func request<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkLoaderError>) -> Void)
}

public struct SNClient: APIClientProtocol {
    
    public init() {
        
    }
}

extension APIClientProtocol {
    
    public var urlSession: URLSession {
        return URLSession.shared
    }
    
    public func request<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkLoaderError>) -> Void) {
        let task = urlSession.dataTask(with: request) { data, response, error in
            var result: Result<T, NetworkLoaderError>
            if let error = error {
                result = .failure(.message(error.localizedDescription))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                  return completion(.failure(.message("Request Failed")))
              }
            
             guard (200 ... 299).contains(httpResponse.statusCode) else { 
                 return completion(.failure(.statusCodeFailure(code: httpResponse.statusCode)))
             }
             
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    result = .success(decoded)
                } catch {
                    result = .failure(.message(error.localizedDescription))
                }
            } else {
                result = .failure(.message("No Data Error"))
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }

        task.resume()
    }
}
