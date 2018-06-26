//
//  HeadlinesRequestParametersTest.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import AwesomeNewsApp

class EverythingRequestParametersTest: XCTestCase {
    
    var parameters: EverythingRequestParameters!
    
    override func setUp() {
        super.setUp()
        
        parameters = EverythingRequestParameters()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConvenienceInitializer() {
        // Given
        parameters = EverythingRequestParameters(language: "en", sources: "cnn", keywords: "bitcoin", apiKey: "fakeKey", pageSize: 100)
        
        // Then
        XCTAssertEqual(parameters.language, "en")
        XCTAssertEqual(parameters.sources, "cnn")
        XCTAssertEqual(parameters.keywords, "bitcoin")
        XCTAssertEqual(parameters.apiKey, "fakeKey")
        XCTAssertEqual(parameters.pageSize, 100)
        XCTAssertEqual(parameters.page, 1)
    }
    
    func testGoToPageTen() {
        parameters.gotoPage(10)
        XCTAssertEqual(parameters.page, 10)
    }
    
    func testGoToFirstPage() {
        parameters.gotoPage(10)
        parameters.gotoFirstPage()
        XCTAssertEqual(parameters.page, 1)
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
    
    func testIsReadyIfHasSourceValue() {
        parameters.sources = "cnn"
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsReadyIfHasLanguageValue() {
        parameters.language = "en"
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsReadyIfHasKeywordsValue() {
        parameters.keywords = "bitcoin"
        XCTAssertTrue(parameters.isReady())
    }
    
    func testIsNotReadyIfHasNoCriterias() {
        XCTAssertFalse(parameters.isReady())
    }
    
    func testGetParamStrings() {
        //Given
        parameters.language = "en"
        parameters.sources = "cnn"
        parameters.keywords = "bitcoin"
        parameters.apiKey = NewsClient.apiKey
        
        // When
        let paramString = parameters.paramString()
        
        //Then
        XCTAssertEqual(paramString, "language=en&sources=cnn&q=bitcoin&apiKey=\(NewsClient.apiKey)&pageSize=10&page=1")
    }
}
