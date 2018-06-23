//
//  NewsClientTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import AwesomeNewsApp



class NewsClientTests: XCTestCase {
    
    var newsClient: NewsClient!
    
    override func setUp() {
        super.setUp()
        
        // Given
        newsClient = NewsClient()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testApiKeyIsNotNil() {
        XCTAssertNotNil(newsClient.apiKey)
    }
    
    func testHeadlinesUrlIsCorrect() {
        // When
        let headlinesURL = newsClient.getURL(endpoint: NewsClient.Endpoints.headlines)
        // Then
        XCTAssertEqual(headlinesURL?.absoluteString, "https://newsapi.org/v2/top-headlines")
    }
    
    // FIXME: This test should be move to integration tests later
    func testLoadHeaderlinesFailsIfAPIKeyIsMissing() {
        
        let expectation = self.expectation(description: "Expect load header lines has data")
        
        // When
        newsClient.loadHeaderlines(endpoint: .headlines) { newsList in
            expectation.fulfill()
            
            // Then
            XCTAssertNotNil(newsList, "load headlines api returns no data")
            XCTAssertEqual(newsList?.status, "error")
            XCTAssertEqual(newsList?.code, "apiKeyMissing")
            XCTAssertEqual(newsList?.message, "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header.")
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
