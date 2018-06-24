//
//  NewsListViewModel.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

/// The view model class for NewsListViewController
class NewsListViewModel {
    
    private var newsClient: NewsClient!
    private var paramters: HeadlinesRequestParameters!
    
    /// The news list data loaded from remote api
    var newsList: NewsList?
    
    private let newsItemViewModelsVar = Variable([NewsItemViewModel]())
    /// The observable for news item view models
    var newsItemViewModelsObservable:Observable<[NewsItemViewModel]> {
        return newsItemViewModelsVar.asObservable()
    }
    
    init() {
        newsClient = NewsClient()
        paramters = HeadlinesRequestParameters(country: HeadlinesRequestParameters.Countries.cn.rawValue, apiKey: NewsClient.apiKey)
    }
    
    
    private func loadNewsListData(completion:@escaping (NewsList?) -> Void) {
        newsClient.loadHeaderlines(params: paramters) { [weak self] (newsList) in
            
            if (self?.paramters.page == 0) {
                self?.newsList = newsList
            } else if let articles = newsList?.articles {
                self?.newsList?.articles?.append(contentsOf: articles)
            }
            
            if let newsItemViewModels = self?.newsList?.articles?.map({ (newsItem) -> NewsItemViewModel in
                return NewsItemViewModel(newsItem: newsItem)
            }) {
                self?.newsItemViewModelsVar.value = newsItemViewModels
            }
            
            completion(newsList)
        }
    }
    
    /// Load more news data from api
    ///
    /// - Parameter completion: The completion block which returns a `NewsList` object.
    func loadMoreNews(completion:@escaping (NewsList?) -> Void) {
        paramters.gotoNextPage()
        loadNewsListData(completion: completion)
    }
    
    /// Reload news data from api
    ///
    /// - Parameter completion: The completion block which returns a `NewsList` object.
    func reloadNews(completion:@escaping (NewsList?) -> Void) {
        paramters.gotoFirstPage()
        loadNewsListData(completion: completion)
    }
}
