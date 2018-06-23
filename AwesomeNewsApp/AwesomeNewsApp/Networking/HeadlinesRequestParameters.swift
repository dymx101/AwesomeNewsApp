//
//  HeadlinesRequestParameters.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class HeadlinesRequestParameters {
    
    enum Categories: String {
        case business = "business"
        case entertainment = "entertainment"
        case general = "general"
        case health = "health"
        case science = "science"
        case sports = "sports"
        case technology = "technology"
    }
    
    var country: String = ""
    var category: String = ""
    var sources: String = ""
    var keywords: String = ""
    
    var pageSize: Int = 20
    
    private var _page: Int = 0
    var page: Int {
        return _page
    }
    
    func isReady() -> Bool {
        if country.isEmpty && category.isEmpty && sources.isEmpty && keywords.isEmpty {
            return false
        }
        
        if !sources.isEmpty && (!country.isEmpty || !category.isEmpty) {
            return false
        }
        
        return true
    }
    
    func gotoPage(_ page: Int) {
        _page = page
    }
    
    func gotoFirstPage() {
        _page = 0
    }
    
    func gotoPrevousPage() {
        if (_page > 0) {
            _page -= 1
        }
    }
    
    func gotoNextPage() {
        _page += 1
    }
}
