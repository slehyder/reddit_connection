//
//  SearchServiceTests.swift
//  RedditTests
//
//  Created by Slehyder Martinez on 8/11/23.
//

import XCTest
@testable import Reddit

final class SearchServiceTests: XCTestCase {
    
    var searchService: SearchService!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        self.mockNetworkService = MockNetworkService()
        self.searchService = SearchService(networkService: mockNetworkService)
    }
    
    func testGetFeedSuccess() {
        let expectation = self.expectation(description: "Success response")
        
        let mockResponseData = Data(MockNetworkService.jsonMockSuccessResponseString.utf8)
        mockNetworkService.configureMock(response: mockResponseData)
        
        let request = SearchModel.Get.Request()
        searchService.getFeed(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTFail("\(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetFeedNilResponse() {
        let expectation = self.expectation(description: "Nil response")

        // Configura el mock para devolver nil como respuesta.
        mockNetworkService.configureMock(response: nil)
        
        let request = SearchModel.Get.Request()
        searchService.getFeed(request: request) { result in
            if case .success(let response) = result {
                XCTAssertNil(response)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetFeedAPIError() {
        let expectation = self.expectation(description: "API error")

        let simulatedError = ErrorModel.server(description: "server error")
        mockNetworkService.configureMock(error: simulatedError)
        
        let request = SearchModel.Get.Request()
        searchService.getFeed(request: request) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, simulatedError.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    override func tearDown() {
        self.mockNetworkService = nil
        self.searchService = nil
        super.tearDown()
    }
}
