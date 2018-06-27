//
//  FirebaseManagerTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import AwesomeNewsApp

class FirebaseManagerTests: XCTestCase {
    
    var firebaseManager: FirebaseManager!
    
    override func setUp() {
        super.setUp()
        firebaseManager = FirebaseManager()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveAndLoadNewsHtml() {
        let expectation = self.expectation(description: "should be able to read news html from firebase")
        let url = "https://www.google.com"
        let htmlString = "<html><body>This is a test html file</body></html>"
        
        firebaseManager.saveHtml(htmlString, forUrl: url)
        firebaseManager.loadHtml(forUrl:url) { (htmlStringLoaded) in
            expectation.fulfill()
            XCTAssertEqual(htmlStringLoaded, htmlString)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSaveAndLoadNewsList() {
        let expectation = self.expectation(description: "should be able to read news list from firebase")
        
        var fullFilled = false
        firebaseManager.loadNewsList { (newsListLoaded) in
            if !fullFilled {
                expectation.fulfill()
                fullFilled = true
            }
            
            XCTAssertNotNil(newsListLoaded)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
}
