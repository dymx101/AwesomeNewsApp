//
//  HeadlinesRequestParameters.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class HeadlinesRequestParameters {
    
    enum Countries: String {
        case us = "us"
        case cn = "cn"
        case sg = "sg"
    }
    
    enum Categories: String {
        case business = "business"
        case entertainment = "entertainment"
        case general = "general"
        case health = "health"
        case science = "science"
        case sports = "sports"
        case technology = "technology"
    }
    
    enum Keys: String {
        case country = "country"
        case category = "category"
        case sources = "sources"
        case keywords = "q"
        case pageSize = "pageSize"
        case page = "page"
        case apiKey = "apiKey"
    }
    
    var country: String = ""
    var category: String = ""
    var sources: String = ""
    var keywords: String = ""
    var apiKey: String = ""
    
    var pageSize: Int = 20
    
    private var _page: Int = 0
    var page: Int {
        return _page
    }
    
    convenience init(country: String? = nil, category: String? = nil, sources: String? = nil, keywords: String? = nil, apiKey: String? = nil, pageSize: Int = 20) {
        self.init()
        
        self.country = country ?? ""
        self.category = category ?? ""
        self.sources = sources ?? ""
        self.keywords = keywords ?? ""
        self.apiKey = apiKey ?? ""
        self.pageSize = pageSize
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
    
    func paramString() -> String {
        var paramStrings = [String]()
        
        if !country.isEmpty {
            paramStrings.append(Keys.country.rawValue + "=" + country)
        }
        
        if !category.isEmpty {
            paramStrings.append(Keys.category.rawValue + "=" + category)
        }
        
        if !sources.isEmpty {
            paramStrings.append(Keys.sources.rawValue + "=" + sources)
        }
        
        if !keywords.isEmpty {
            paramStrings.append(Keys.keywords.rawValue + "=" + keywords)
        }
        
        if !apiKey.isEmpty {
            paramStrings.append(Keys.apiKey.rawValue + "=" + apiKey)
        }
        
        paramStrings.append(Keys.pageSize.rawValue + "=" + String(pageSize))
        paramStrings.append(Keys.page.rawValue + "=" + String(page))
        
        return paramStrings.joined(separator: "&")
    }
}
