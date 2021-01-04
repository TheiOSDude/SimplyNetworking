//
//  File.swift
//  
//
//  Created by Lee Burrows on 04/01/2021.
//

import Foundation
@testable import SimplyNetworking

struct PersonName: Codable {
    var firstName: String
    var lastName: String
}

final class NameService {
    
    private var apiClient: APIClientProtocol
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getNames(_ completion: @escaping (Result<[PersonName], NetworkLoaderError>) -> ()) throws {
        let request = try APIRequest(root: "https://theiosdude.api.com", path: "test", method: "GET").urlRequest()
        self.apiClient.request(request) { (result: Result<[PersonName], NetworkLoaderError> ) in
            completion(result)
        }
    }
}
