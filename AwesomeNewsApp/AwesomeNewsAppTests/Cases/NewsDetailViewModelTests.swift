//
//  NewsDetailViewModelTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import AwesomeNewsApp

class NewsDetailViewModelTests: XCTestCase {
    
    var databaseMananger: DatabaseManager!
    
    override func setUp() {
        super.setUp()
        databaseMananger = MockDatabaseManager()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveAndLoadHtml() {
        
        let expectation = self.expectation(description: "Expect could save and load html for url")
        
        let html = "<html><body>This is a test html file</body></html>"
        let url = "http://google.com"
        
        databaseMananger.saveHtml(html, forUrl: url)
        
        databaseMananger.loadHtml(forUrl: url) { (htmlLoaded) in
            expectation.fulfill()
            
            XCTAssertEqual(htmlLoaded, html, "Loaded html should be the same as the saved html.")
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
}
