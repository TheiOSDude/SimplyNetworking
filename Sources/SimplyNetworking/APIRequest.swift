//
//  APIRequest.swift
//  SimplyNetworking
//
//  Created by Lee Burrows on 28/10/2019.
//  Copyright © 2019 Lee Burrows. All rights reserved.
//

import Foundation

protocol Requestable {
    func urlRequest() -> URLRequest
}

struct APIRequest: Requestable {
    let path: String
    let method: String
    let root: String
    var queryItems = [URLQueryItem]()

    init(root: String, path: String, method: String = "GET") {
        self.path = path
        self.root = root
        self.method = method
    }

    mutating func addingQueryItem(name: String, value: String) {
        queryItems.append(URLQueryItem(name: name, value: value))
    }

    //TODO: Refactor Looks painful, but safe?
    func urlRequest() -> URLRequest {
        guard var components = URLComponents(string: root) else {
            return URLRequest(url: URL(fileURLWithPath: ""))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            return URLRequest(url: URL(fileURLWithPath: ""))
        }

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method
        return request
    }
}

extension URLRequest: Requestable {
    func urlRequest() -> URLRequest { return self }
}
