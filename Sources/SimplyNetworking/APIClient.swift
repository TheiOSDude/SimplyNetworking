//
//  APIClient.swift
//  Simply Networking
//
//  Created by Lee Burrows on 28/10/2019.
//  Copyright © 2019 Lee Burrows. All rights reserved.
//

import Foundation

public struct SNClient: APIClientProtocol {

    public func request<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkLoaderError>) -> Void) {

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            let result: Result<T, NetworkLoaderError>
            if let error = error {
                result = .failure(NetworkLoaderError(message: error.localizedDescription))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    result = .success(decoded)
                } catch {
                    result = .failure(NetworkLoaderError(message: error.localizedDescription))
                }
            } else {
                result = .failure(NetworkLoaderError(message: "No Data Error"))
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }

        task.resume()

    }
}
