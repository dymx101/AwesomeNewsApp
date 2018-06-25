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
        let newsItem = NewsItem(JSON: ["title" : "111", "description" : "222", "url" : "333", "urlToImage" : "444"])
        
        // When
        viewModel = NewsItemViewModel(newsItem: newsItem!)
        
        // Then
        _ = viewModel.titleObservable.subscribe(onNext:{ title in
            XCTAssertEqual(title, newsItem?.title)
        })
        
        _ = viewModel.descObservable.subscribe(onNext:{ desc in
            XCTAssertEqual(desc, newsItem?.desc)
        })
        
        _ = viewModel.urlObservable.subscribe(onNext:{ url in
            XCTAssertEqual(url, newsItem?.url)
        })
        
        _ = viewModel.urlToImageObservable.subscribe(onNext:{ urlToImage in
            XCTAssertEqual(urlToImage, newsItem?.urlToImage)
        })
    }
}
