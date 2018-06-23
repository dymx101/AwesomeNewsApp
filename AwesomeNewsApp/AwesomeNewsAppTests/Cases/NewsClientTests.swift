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
        
        newsClient = NewsClient()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testApiKeyIsNotNil() {
        XCTAssertNotNil(newsClient.apiKey)
    }
    
    func testHeadlinesUrlIsCorrect() {
        let headlinesURL = newsClient.getEndpointURL(NewsClient.Endpoints.headlines)
        XCTAssertEqual(headlinesURL?.absoluteString, "https://newsapi.org/v2/top-headlines")
    }
}
