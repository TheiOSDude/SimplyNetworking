# SimplyNetworking

## A lightweight, reusable, Swift Networking library.

### SPM Compatible.

### Usage:

``` swift
let apiClient = SNClient() // Basic Client
```

```swift
let request = try APIRequest(root: "https://theiosdude.api.com", path: "test", method: "GET").urlRequest() // URLRequest
request.addingQueryItem(name: "query", value: "Great Names") //https://theiosdude.api.com/test?query=great%20names
apiClient.request(request) { (result: Result<[PersonName], NetworkLoaderError> ) in
      switch result ...
    }
}
```



### Stubbing

Responses can be stubbed, for unit tests using the `URLProtocol` subclass provided (```MockSNClient```). View the ``` SimplyNetworkingTests ``` XCTestCase class for an example

###  By Lee Burrows @TheiOSDude

