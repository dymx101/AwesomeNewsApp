//
//  MockDatabaseManager.swift
//  AwesomeNewsAppTests
//
//  Created by Yiming Dong on 2018/6/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
@testable import AwesomeNewsApp

class MockDatabaseManager: DatabaseManager {
    
    var htmlsMap: [String: String] = [:]
    var newsList: NewsList?
    
    func saveHtml(_ html: String, forUrl url:String) {
        htmlsMap[url.toMD5()] = html
    }
    
    func loadHtml(forUrl url: String, completion: @escaping (String) -> Void) {
        let html = htmlsMap[url.toMD5()] ?? ""
        completion(html)
    }
    
    func saveNewsList(newslist: NewsList) {
        self.newsList = newslist
    }
    
    func loadNewsList(completion:@escaping (NewsList?)->Void) {
        completion(newsList)
    }
}
