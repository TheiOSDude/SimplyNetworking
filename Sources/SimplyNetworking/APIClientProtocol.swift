//
//  APIClient.swift
//  RXMovie
//
//  Created by Lee Burrows on 28/10/2019.
//  Copyright © 2019 Lee Burrows. All rights reserved.
//

import Foundation

struct NetworkLoaderError: Error, Codable {
    let message: String
}

protocol APIClient {
    func request<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkLoaderError>) -> Void)

}
