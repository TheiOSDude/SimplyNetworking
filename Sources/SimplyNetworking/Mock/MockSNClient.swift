//
//  File.swift
//  
//
//  Created by Lee Burrows on 04/01/2021.
//

import Foundation

struct MockNetworking: APIClientProtocol {
    
    var urlSession: URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
