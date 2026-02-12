import XCTest
@testable import TheMiddleWay

class WisdomGardenRepositoryTests: XCTestCase {
    
    var repository: NetworkWisdomGardenRepository!
    
    override func tearDown() {
        repository = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testGetWeeklyData_NetworkFailure_ReturnsFallback() async throws {
        // Setup configuration that uses MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        repository = NetworkWisdomGardenRepository(session: session)
        
        // Simulate Network Error
        MockURLProtocol.requestHandler = { request in
            throw URLError(.notConnectedToInternet)
        }
        
        // Execute
        let data = try await repository.getWeeklyData(week: 1)
        
        // Assert: Should return fallback data
        XCTAssertEqual(data.weekNumber, 1)
        XCTAssertFalse(data.categories.isEmpty)
        // Check specific fallback data content to be sure
        XCTAssertEqual(data.categories.first?.id, "mindfulness")
    }
    
    func testGetWeeklyData_ServerError_ReturnsFallback() async throws {
         let config = URLSessionConfiguration.ephemeral
         config.protocolClasses = [MockURLProtocol.self]
         let session = URLSession(configuration: config)
         
         repository = NetworkWisdomGardenRepository(session: session)
         
         // Simulate 500 Error
         MockURLProtocol.requestHandler = { request in
             let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
             return (response, Data())
         }
         
         let data = try await repository.getWeeklyData(week: 1)
         
         // Assert: Should return fallback data
         XCTAssertFalse(data.categories.isEmpty)
         XCTAssertEqual(data.categories.first?.id, "mindfulness")
    }
    
    func testGetWeeklyData_MalformedResponse_ReturnsFallback() async throws {
         let config = URLSessionConfiguration.ephemeral
         config.protocolClasses = [MockURLProtocol.self]
         let session = URLSession(configuration: config)
         
         repository = NetworkWisdomGardenRepository(session: session)
         
         // Simulate 200 OK but bad JSON
         MockURLProtocol.requestHandler = { request in
             let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
             let badData = "Not JSON".data(using: .utf8)!
             return (response, badData)
         }
         
         let data = try await repository.getWeeklyData(week: 1)
         
         // Assert: Should return fallback data
         XCTAssertFalse(data.categories.isEmpty)
         XCTAssertEqual(data.categories.first?.id, "mindfulness")
    }
}

// MARK: - MockURLProtocol
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
