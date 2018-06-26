//
//  NewsSearchViewModelTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
import RxSwift
@testable import AwesomeNewsApp

class NewsSearchViewModelTests: XCTestCase {
    
    var viewModel: NewsSearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = NewsSearchViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSearchNewsAndCanGetNewsItemViewModels() {
        let expectation = self.expectation(description: "Expect searching news gets results")
        let expectationNewsItemViewModel = self.expectation(description: "news item view models should be generated")
        
        _ = viewModel.newsItemViewModelsObservable.filter({ (newsItemViewModels) -> Bool in
            return newsItemViewModels.count > 0
        }).subscribe(onNext: { (newsItemViewModels) in
            expectationNewsItemViewModel.fulfill()
            XCTAssertTrue(true)
        })
        
        viewModel.searchNews(keywords: "bitcoin") { [weak self] (newsList) in
            expectation.fulfill()
            XCTAssertNotNil(self?.viewModel.newsList)
        }
        
        wait(for: [expectation, expectationNewsItemViewModel], timeout: 20)
    }
    
    func testLoadMoreNews() {
        let expectation = self.expectation(description: "Expect load more news list data")
        
        viewModel.searchMoreNews(keywords: "bitcoin") { [weak self] (newsList) in
            expectation.fulfill()
            
            XCTAssertEqual((self?.viewModel.currentPage())!, EverythingRequestParameters.Constants.firstPageIndex + 1)
            
            XCTAssertNotNil(self?.viewModel.newsList?.articles)
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
