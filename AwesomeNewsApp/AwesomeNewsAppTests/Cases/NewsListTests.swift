//
//  NewsListTests.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import XCTest
@testable import AwesomeNewsApp

class NewsListTests: XCTestCase {
    
    var newsList: NewsList!
    
    override func setUp() {
        super.setUp()
        
        let listString1 = """
{"status":"ok","totalResults":20,"articles":[{"source":{"id":null,"name":"Wftv.com"},"author":"EndPlay","title":"Conagra buying Pinnacle Foods in $10.9 billion deal","description":"CHICAGO (AP) - Conagra is buying Pinnacle Foods Inc. in a cash-and-stock deal valued at about $10.9 billion that will help the food company expand in the frozen food and snacks categories.","url":"https://www.wftv.com/news/conagra-buying-pinnacle-foods-in-109-billion-deal/777991669","urlToImage":"https://mediaweb.wftv.com/theme/images/logo-main-wftv.png","publishedAt":"2018-06-27T10:42:00Z"}]}
"""
        
        newsList = NewsList(JSONString: listString1)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanAppendAnotherNewsList() {
        // Given
        let listString2 = """
    {"status":"ok","totalResults":20,"articles":[{"source":{"id":"reuters","name":"Reuters"},"author":"Reuters Editorial","title":"Bank of England says UK banks can manage hard Brexit","description":"Britain's banks could deal with a hard Brexit next March if need be, the Bank of England said on Wednesday, rejecting European Union warnings that lenders are inadequately prepared.","url":"https://uk.reuters.com/article/uk-britain-boe/bank-of-england-says-uk-banks-can-manage-hard-brexit-idUKKBN1JN12Q","urlToImage":"https://s2.reutersmedia.net/resources/r/?m=02&d=20180627&t=2&i=1276995786&w=1200&r=LYNXMPEE5Q0UD","publishedAt":"2018-06-27T09:35:00Z"}]}
"""
        let newsList2 = NewsList(JSONString: listString2)
        
        XCTAssertEqual(newsList?.articles?.count, 1)
        XCTAssertEqual(newsList2?.articles?.count, 1)
        
        // When
        newsList.append(newsList: newsList2)
        
        // Then
        XCTAssertEqual(newsList?.articles?.count, 2)
    }
}
