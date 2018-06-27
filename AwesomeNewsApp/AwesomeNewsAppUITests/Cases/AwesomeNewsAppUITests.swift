//
//  AwesomeNewsAppUITests.swift
//  AwesomeNewsAppUITests
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest

class AwesomeNewsAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanGoToNewsDetailFromNewsList() {
        
        app.tables.cells.element(boundBy: 0).tap()
        
        let newsDetailLabel = app.otherElements["newsDetailView"]
//        print(app.debugDescription)
        XCTAssertTrue(newsDetailLabel.exists, "Should go to news detail page")
    }
    
    func testCanSearchAndGetCorrectResults() {

        app.navigationBars["Awesome News"].buttons["Search"].tap()
        
        let searchForNewsSearchField = app.searchFields["Search for news"]
        searchForNewsSearchField.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["A"]/*[[".keyboards.keys[\"A\"]",".keys[\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let bKey = app/*@START_MENU_TOKEN@*/.keys["b"]/*[[".keyboards.keys[\"b\"]",".keys[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bKey.tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()

        app/*@START_MENU_TOKEN@*/.buttons["Go"]/*[[".keyboards.buttons[\"Go\"]",".buttons[\"Go\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let newsItemTitle = app.tables.cells.element(boundBy: 0).staticTexts["newsItemTitle"]
        waitForElementToAppear(element:newsItemTitle)
        
        XCTAssertTrue(newsItemTitle.label.contains("Abc"))
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}
