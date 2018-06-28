//
//  NewsItem.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

/// Model of a news item (article)
class NewsItem: Mappable {
    
    enum Keys: String {
        case source = "source"
        case author = "author"
        case title = "title"
        case desc = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
    }
    
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
        source <- map[Keys.source.rawValue]
        author <- map[Keys.author.rawValue]
        title <- map[Keys.title.rawValue]
        desc <- map[Keys.desc.rawValue]
        url <- map[Keys.url.rawValue]
        urlToImage <- map[Keys.urlToImage.rawValue]
        publishedAt <- map[Keys.publishedAt.rawValue]
    }
}
