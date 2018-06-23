//
//  NewsItem.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsItem: Mappable {
    
    var source: NewsSource?
    var author: String?
    var title: String?
    var desc: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        source <- map["source"]
        author <- map["author"]
        title <- map["title"]
        desc <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
}
