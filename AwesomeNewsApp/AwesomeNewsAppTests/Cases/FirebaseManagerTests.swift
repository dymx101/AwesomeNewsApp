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
        
        let jsonString = """
{"status":"ok","totalResults":20,"articles":[{"source":{"id":"cnn","name":"CNN"},"author":"Danielle Wiener-Bronner","title":"The Coffee Bean & Tea Leaf is betting on 'Starbucks fatigue'","description":"The Coffee Bean & Tea Leaf is ready to join the big leagues.","url":"http://money.cnn.com/2018/06/26/news/companies/coffee-bean-tea-leaf-new-york/index.html","urlToImage":"https://i2.cdn.turner.com/money/dam/assets/180626152915-coffee-bean--tea-leaf-780x439.jpg","publishedAt":"2018-06-27T02:11:49Z"}]}
"""
        let newsListToBeSaved = NewsList(JSONString: jsonString)
        
        firebaseManager.saveNewsList(newslist: newsListToBeSaved!)
        
        firebaseManager.loadNewsList { (newsListLoaded) in
            expectation.fulfill()
            XCTAssertNotNil(newsListLoaded)
            XCTAssertEqual(newsListLoaded?.articles?.count, 1)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
}
