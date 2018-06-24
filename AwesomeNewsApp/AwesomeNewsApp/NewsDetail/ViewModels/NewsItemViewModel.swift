//
//  NewsItemViewModel.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class NewsItemViewModel {
    var title: String?
    var desc: String?
    var url: String?
    var urlToImage: String?
    
    convenience init(newsItem: NewsItem) {
        self.init()
        self.title = newsItem.title
        self.desc = newsItem.desc
        self.url = newsItem.url
        self.urlToImage = newsItem.urlToImage
    }
}
