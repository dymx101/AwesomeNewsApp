//
//  NewsListViewModel.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class NewsListViewModel {
    var newsClient: NewsClient!
    var paramters: HeadlinesRequestParameters!
    
    var newsList: NewsList?
    var newsItemViewModels: [NewsItemViewModel]?
    
    init() {
        newsClient = NewsClient()
        paramters = HeadlinesRequestParameters(country: HeadlinesRequestParameters.Countries.cn.rawValue, apiKey: NewsClient.apiKey)
    }
    
    func loadNewsListData(completion:@escaping (NewsList?) -> Void) {
        newsClient.loadHeaderlines(params: paramters) { [weak self] (newsList) in
            
            if (self?.paramters.page == 0) {
                self?.newsList = newsList
            } else if let articles = newsList?.articles {
                self?.newsList?.articles?.append(contentsOf: articles)
            }
            
            self?.newsItemViewModels = self?.newsList?.articles?.map({ (newsItem) -> NewsItemViewModel in
                return NewsItemViewModel(newsItem: newsItem)
            })
            
            completion(newsList)
        }
    }
    
    func loadMoreNews(completion:@escaping (NewsList?) -> Void) {
        paramters.gotoNextPage()
        loadNewsListData(completion: completion)
    }
    
    func reloadNews(completion:@escaping (NewsList?) -> Void) {
        paramters.gotoFirstPage()
        loadNewsListData(completion: completion)
    }
}
