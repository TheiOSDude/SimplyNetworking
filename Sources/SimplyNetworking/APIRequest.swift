//
//  APIRequest.swift
//  SimplyNetworking
//
//  Created by Lee Burrows on 28/10/2019.
//  Copyright © 2019 Lee Burrows. All rights reserved.
//

import Foundation

enum APIRequestError: LocalizedError {
    case badURL
}

protocol Requestable {
    func urlRequest() throws -> URLRequest
}

public struct APIRequest: Requestable {
    let path: String
    let method: String
    let root: String
    var queryItems = [URLQueryItem]()

    public init(root: String, path: String, method: String = "GET") {
        self.path = path
        self.root = root
        self.method = method
    }

    public mutating func addingQueryItem(name: String, value: String) {
        queryItems.append(URLQueryItem(name: name, value: value))
    }

    //TODO: Refactor Looks painful, but safe?
    public func urlRequest() throws -> URLRequest  {
        guard var components = URLComponents(string: root) else {
            throw APIRequestError.badURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIRequestError.badURL
        }

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method
        return request
    }
}

extension URLRequest: Requestable {
    public func urlRequest() -> URLRequest { return self }
}

extension APIRequestError {
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "URL is badly constructed."
        }
    }
}
