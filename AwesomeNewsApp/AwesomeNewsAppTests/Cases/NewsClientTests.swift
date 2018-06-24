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
    func testLoadHeaderlinesFailsIfAPIKeyIsMissing() {
        
        let expectation = self.expectation(description: "Expect load header lines has data")
        
        // Given
        let parameters = HeadlinesRequestParameters()
        
        // When
        newsClient.loadHeaderlines(params: parameters) { newsList in
            expectation.fulfill()
            
            // Then
            XCTAssertNotNil(newsList, "load headlines api returns no data")
            XCTAssertEqual(newsList?.status, "error")
            XCTAssertEqual(newsList?.code, "apiKeyMissing")
            XCTAssertEqual(newsList?.message, "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header.")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    // FIXME: This test should be move to integration tests later
    func testLoadHeaderlinesFailsIfCriteriasMissing() {
        
        let expectation = self.expectation(description: "Expect load header lines has data")
        
        // Given
        let parameters = HeadlinesRequestParameters(apiKey: NewsClient.apiKey)
        
        // When
        newsClient.loadHeaderlines(params: parameters) { newsList in
            expectation.fulfill()
            
            // {"status":"error","code":"parametersMissing","message":"Required parameters are missing. Please set any of the following parameters and try again: sources, q, language, country, category."}
            
            // Then
            XCTAssertNotNil(newsList, "load headlines api returns no data")
            XCTAssertEqual(newsList?.status, "error")
            XCTAssertEqual(newsList?.code, "parametersMissing")
            XCTAssertEqual(newsList?.message, "Required parameters are missing. Please set any of the following parameters and try again: sources, q, language, country, category.")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    // FIXME: This test should be move to integration tests later
    func testLoadHeaderlinesSuccess() {
        
        let expectation = self.expectation(description: "Expect load header lines has data")
        
        // Given
        let parameters = HeadlinesRequestParameters(country:HeadlinesRequestParameters.Countries.us.rawValue, apiKey: NewsClient.apiKey)
        
        // When
        newsClient.loadHeaderlines(params: parameters) { newsList in
            expectation.fulfill()
            
            // Then
            XCTAssertNotNil(newsList, "load headlines api returns no data")
            XCTAssertEqual(newsList?.status, "ok")
            XCTAssertEqual(newsList?.articles?.count, 20)
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
