import XCTest
@testable import SimplyNetworking

final class SimplyNetworkingTests: XCTestCase {
    
    func testMocking_success() {
        let response =
            """
              [
                  {
                      "firstName": "Lee",
                      "lastName": "Burrows"
                  },
                  {
                      "firstName": "Dolly",
                      "lastName": "Burrows"
                  }
              ]
              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://theiosdude.api.com/test")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        
        let nameService = NameService(apiClient: MockNetworking())
        let sucessExpectation = expectation(description: "should succeed")
        try! nameService.getNames { response in
            switch response {
            case .success(_):
                sucessExpectation.fulfill()
            default:
                break
            }
        }
        
        wait(for: [sucessExpectation], timeout: 5.0)
    }
    
    func testMocking_failureCode() {
        let response =
            """
              [
                  {
                      "firstName": "Lee",
                      "lastName": "Burrows"
                  },
                  {
                      "firstName": "Dolly",
                      "lastName": "Burrows"
                  }
              ]
              """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://theiosdude.api.com/test")!,
                                           statusCode: 304,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        
        let nameService = NameService(apiClient: MockNetworking())
        let failureExpectation = expectation(description: "should fail")
        try! nameService.getNames { response in
            switch response {
            case .failure(let error):
                if error == .statusCodeFailure(code: 304) {
                    failureExpectation.fulfill()
                }
                
            default:
                break
            }
        }
        
        wait(for: [failureExpectation], timeout: 5.0)
    }
    static var allTests = [
        ("testMocking_success", testMocking_success),
        ("testMocking_failureCode", testMocking_failureCode)
    ]
}
