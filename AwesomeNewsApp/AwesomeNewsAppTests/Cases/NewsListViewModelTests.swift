//
//  NewsListViewModelTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
import RxSwift
@testable import AwesomeNewsApp

class NewsListViewModelTests: XCTestCase {
    
    var viewModel: NewsListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = NewsListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReloadNewsAndCanGetNewsItemViewModels() {
        let expectation = self.expectation(description: "Expect load news list data")
        let expectationNewsItemViewModel = self.expectation(description: "news item view models should be generated")
        
        _ = viewModel.newsItemViewModelsObservable.filter({ (newsItemViewModels) -> Bool in
            return newsItemViewModels.count > 0
        }).subscribe(onNext: { (newsItemViewModels) in
            expectationNewsItemViewModel.fulfill()
            XCTAssertTrue(true)
        })
        
        viewModel.reloadNews { [weak self] (newsList) in
            expectation.fulfill()
            XCTAssertNotNil(self?.viewModel.newsList)
        }
        
        wait(for: [expectation, expectationNewsItemViewModel], timeout: 20)
    }
    
    func testLoadMoreNews() {
        let expectation = self.expectation(description: "Expect load more news list data")
        
        viewModel.reloadNews { [weak self] (newsList) in
            
            self?.viewModel.loadMoreNews { [weak self] (newsList2) in
                expectation.fulfill()
                
                XCTAssertNotNil(self?.viewModel.newsList?.articles)
                XCTAssertNotNil(newsList2?.articles)
                XCTAssertGreaterThan((self?.viewModel.newsList?.articles?.count)!, (newsList2?.articles?.count)!)
            }
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
