//
//  HeadlinesRequestParametersTest.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import AwesomeNewsApp

class HeadlinesRequestParametersTest: XCTestCase {
    
    var parameters: HeadlinesRequestParameters!
    
    override func setUp() {
        super.setUp()
        
        parameters = HeadlinesRequestParameters()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGoToPageTen() {
        parameters.gotoPage(10)
        XCTAssertEqual(parameters.page, 10)
    }
    
    func testGoToFirstPage() {
        parameters.gotoPage(10)
        parameters.gotoFirstPage()
        XCTAssertEqual(parameters.page, 0)
    }
    
    func testGoToNextPage() {
        parameters.gotoPage(10)
        parameters.gotoNextPage()
        XCTAssertEqual(parameters.page, 11)
    }
    
    func testGoToPreviousPage() {
        parameters.gotoPage(10)
        parameters.gotoPrevousPage()
        XCTAssertEqual(parameters.page, 9)
    }
    
    func testIsReadyIfHasCategoryValue() {
        parameters.category = HeadlinesRequestParameters.Categories.business.rawValue
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsReadyIfHasSourceValue() {
        parameters.sources = "cnn"
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsReadyIfHasCountryValue() {
        parameters.country = "en"
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsReadyIfHasKeywordsValue() {
        parameters.keywords = "bitcoin"
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsNotReadyIfHasNoCriterias() {
        XCTAssertFalse(parameters.isReady())
    }
    
    func testIsNotReadyIfHasBothCountryAndSourcesValues() {
        parameters.country = "en"
        parameters.sources = "cnn"
        XCTAssertFalse(parameters.isReady())
    }
    
    func testIsNotReadyIfHasBothCategoryAndSourcesValues() {
        parameters.category = HeadlinesRequestParameters.Categories.business.rawValue
        parameters.sources = "cnn"
        XCTAssertFalse(parameters.isReady())
    }
}
