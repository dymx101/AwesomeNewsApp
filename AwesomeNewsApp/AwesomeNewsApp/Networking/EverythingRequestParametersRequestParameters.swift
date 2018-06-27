//
//  EverythingRequestParameters.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EverythingRequestParameters {
    
    enum Languages: String {
        case en = "en"
        case zh = "zh"
    }
    
    enum Sources: String {
        case cnn = "cnn"
        case abcNews = "abc-news"
        case bbcNews = "bbc-news"
    }
    
    enum Keys: String {
        case language = "language"
        case sources = "sources"
        case keywords = "q"
        case pageSize = "pageSize"
        case page = "page"
        case apiKey = "apiKey"
    }
    
    struct Constants {
        static let firstPageIndex = 1
        static let defaultPageSize = 10
    }
    
    var language: String = ""
    var sources: String = ""
    var keywords: String = ""
    var apiKey: String = ""
    
    var pageSize: Int = Constants.defaultPageSize
    
    private var _page: Int = Constants.firstPageIndex
    var page: Int {
        return _page
    }
    
    convenience init(language: String? = nil, sources: String? = nil, keywords: String? = nil, apiKey: String? = nil, pageSize: Int = Constants.defaultPageSize) {
        self.init()
        
        self.language = language ?? ""
        self.sources = sources ?? ""
        self.keywords = keywords ?? ""
        self.apiKey = apiKey ?? ""
        self.pageSize = pageSize
    }
    
    func isReady() -> Bool {
        return !(language.isEmpty && sources.isEmpty && keywords.isEmpty)
    }
    
    // MARK: page control methods
    func gotoPage(_ page: Int) {
        _page = page
    }
    
    func gotoFirstPage() {
        _page = Constants.firstPageIndex
    }
    
    func gotoPrevousPage() {
        if (_page > Constants.firstPageIndex) {
            _page -= 1
        }
    }
    
    func gotoNextPage() {
        _page += 1
    }
    
    // MARK: url param string
    func paramString() -> String {
        var paramStrings = [String]()
        
        if !language.isEmpty {
            paramStrings.append(Keys.language.rawValue + "=" + language)
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
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
