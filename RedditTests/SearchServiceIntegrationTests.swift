//
//  SearchServiceIntegrationTests.swift
//  RedditTests
//
//  Created by Slehyder Martinez on 8/11/23.
//

import XCTest
@testable import Reddit

final class SearchServiceIntegrationTests: XCTestCase {
    
    var searchService: SearchService!
    var realNetworkService: NetworkService!

    override func setUp() {
        super.setUp()
        self.realNetworkService = NetworkService()
        self.searchService = SearchService(networkService: realNetworkService)
    }
    
    func testGetFeedIntegration() {
        // Use an expectation to wait for the async call.
        let expectation = self.expectation(description: "Integration test feed network service")

        let request = SearchModel.Get.Request()
        searchService.getFeed(request: request) { result in
            switch result {
            case .success(let response):
                
                XCTAssertNotNil(response, "The response should not be nil.")
                
                if let response = response {
                    XCTAssertFalse(response.data.children.isEmpty, "There should be at least one post.")
                    
                    if let firstPost = response.data.children.first?.data {
                        XCTAssertFalse(firstPost.title.isEmpty, "The post title should not be empty.")
                        XCTAssertGreaterThanOrEqual(firstPost.score, 0, "The post score should not be negative.")
                        XCTAssertGreaterThanOrEqual(firstPost.numComments, 0, "The number of comments should not be negative.")
                        
                        XCTAssertNotNil(response.data.after, "The 'after' field should be present for pagination.")
                    }
                } else {
                    XCTFail("The children property should not be nil.")
                }
            case .failure(let error):
                XCTFail("test failed error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil) // You might need to increase the timeout for real network calls.
    }
    
    func testGetSearchIntegration() {
        // Use an expectation to wait for the async call.
        let expectation = self.expectation(description: "Integration test search network service")

        let request = SearchModel.Get.Request(query: "Lol")
        searchService.getSearch(request:request) { result in
            switch result {
            case .success(let response):
                
                XCTAssertNotNil(response, "The response should not be nil.")
                
                if let response = response {
                    XCTAssertFalse(response.data.children.isEmpty, "There should be at least one post.")
                    
                    if let firstPost = response.data.children.first?.data {
                        XCTAssertFalse(firstPost.title.isEmpty, "The post title should not be empty.")
                        XCTAssertGreaterThanOrEqual(firstPost.score, 0, "The post score should not be negative.")
                        XCTAssertGreaterThanOrEqual(firstPost.numComments, 0, "The number of comments should not be negative.")
                        
                        XCTAssertNotNil(response.data.after, "The 'after' field should be present for pagination.")
                    }
                } else {
                    XCTFail("The children property should not be nil.")
                }
  
            case .failure(let error):
                XCTFail("test failed error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil) // You might need to increase the timeout for real network calls.
    }
    
    override func tearDown() {
        self.searchService = nil
        self.realNetworkService = nil
        super.tearDown()
    }
}
