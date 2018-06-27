//
//  NewsList.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsList: Mappable {
    
    enum Keys: String {
        case status = "status"
        case totalResults = "totalResults"
        case code = "code"
        case message = "message"
        case articles = "articles"
    }
    
    var articles: [NewsItem]?
    var status: String?
    var code: String?
    var message: String?
    var totalResults: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        articles <- map[Keys.articles.rawValue]
        status <- map[Keys.status.rawValue]
        code <- map[Keys.code.rawValue]
        message <- map[Keys.message.rawValue]
        totalResults <- map[Keys.totalResults.rawValue]
    }
    
    func append(newsList: NewsList?) {
        guard let moreArticles = newsList?.articles else {return}
        
        if articles == nil {
            articles = [NewsItem]()
        }
        
        articles!.append(contentsOf: moreArticles)
    }
}
