//
//  NewsItemViewModelTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
import AlamofireObjectMapper
@testable import AwesomeNewsApp

class NewsItemViewModelTests: XCTestCase {
    
    var viewModel: NewsItemViewModel!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConvinienceInitializer() {
        // Given
        let newsItem = NewsItem(JSON: ["title" : "111", "desc" : "222", "url" : "333", "urlToImage" : "444"])
        
        // When
        viewModel = NewsItemViewModel(newsItem: newsItem!)
        
        // Then
        XCTAssertEqual(viewModel.title, newsItem?.title)
        XCTAssertEqual(viewModel.desc, newsItem?.desc)
        XCTAssertEqual(viewModel.url, newsItem?.url)
        XCTAssertEqual(viewModel.urlToImage, newsItem?.urlToImage)
    }
}
