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
        XCTAssertNotNil(NewsClient.apiKey)
    }
    
    func testHeadlinesUrlIsCorrect() {
        // When
        let headlinesURL = newsClient.getURL(endpoint: NewsClient.Endpoints.headlines)
        // Then
        XCTAssertEqual(headlinesURL?.absoluteString, "https://newsapi.org/v2/top-headlines")
    }
    
    // FIXME: This test should be move to integration tests later
    func testLoadHeaderlinesSuccess() {
        
        let expectation = self.expectation(description: "Expect load header lines has data")
        
        // Given
        let parameters = EverythingRequestParameters(language:"en", sources:"cnn", apiKey: NewsClient.apiKey)
        
        // When
        newsClient.loadEverything(params: parameters) { newsList, error in
            expectation.fulfill()
            
            // Then
            XCTAssertNil(error, "should has no error")
            XCTAssertNotNil(newsList, "load headlines api returns no data")
            XCTAssertEqual(newsList?.status, "ok")
            XCTAssertEqual(newsList?.articles?.count, EverythingRequestParameters.Constants.defaultPageSize)
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
