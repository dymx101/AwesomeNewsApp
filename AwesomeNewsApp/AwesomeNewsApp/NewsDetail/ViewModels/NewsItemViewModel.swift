//
//  NewsItemViewModel.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class NewsItemViewModel {
    private var title = Variable(String(""))
    private var desc = Variable(String(""))
    private var url = Variable(String(""))
    private var urlToImage = Variable(String(""))
    
    var titleObservable:Observable<String> {
        return title.asObservable()
    }
    
    var descObservable:Observable<String> {
        return desc.asObservable()
    }
    
    var urlObservable:Observable<String> {
        return url.asObservable()
    }
    
    var urlToImageObservable:Observable<String> {
        return urlToImage.asObservable()
    }
    
    convenience init(newsItem: NewsItem) {
        self.init()
        self.title.value = newsItem.title ?? ""
        self.desc.value = newsItem.desc ?? ""
        self.url.value = newsItem.url ?? ""
        self.urlToImage.value = newsItem.urlToImage ?? ""
    }
}
