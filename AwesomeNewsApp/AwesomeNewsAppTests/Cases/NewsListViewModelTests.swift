//
//  NewsListViewModelTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
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
    
    func testLoadNewsListData() {
        let expectation = self.expectation(description: "Expect load news list data")
        
        viewModel.loadNewsListData { [weak self] (newsList) in
            expectation.fulfill()
            XCTAssertNotNil(self?.viewModel.newsList)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testLoadMoreNews() {
        let expectation = self.expectation(description: "Expect load more news list data")
        
        viewModel.loadNewsListData { [weak self] (newsList) in
            XCTAssertEqual(self?.viewModel.paramters.page, 0)
            
            self?.viewModel.loadMoreNews { [weak self] (newsList2) in
                expectation.fulfill()
                
                XCTAssertEqual(self?.viewModel.paramters.page, 1)
                XCTAssertNotNil(self?.viewModel.newsList?.articles)
                XCTAssertNotNil(newsList2?.articles)
                XCTAssertGreaterThan((self?.viewModel.newsList?.articles?.count)!, (newsList2?.articles?.count)!)
            }
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testReloadNews() {
        let expectation = self.expectation(description: "Expect reload news list data")
        
        viewModel.reloadNews { [weak self] (newsList) in
            expectation.fulfill()
            XCTAssertNotNil(self?.viewModel.newsList)
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
