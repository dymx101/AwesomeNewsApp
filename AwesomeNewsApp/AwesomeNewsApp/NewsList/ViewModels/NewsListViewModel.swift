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
    private let newsItemViewModelsVar = Variable([NewsItemViewModel]())
    
    /// The news list data loaded from remote api
    var newsList: NewsList?
    
    /// The observable for news item view models
    var newsItemViewModelsObservable:Observable<[NewsItemViewModel]> {
        return newsItemViewModelsVar.asObservable()
    }
    
    init() {
        newsClient = NewsClient()
        paramters = HeadlinesRequestParameters(country: HeadlinesRequestParameters.Countries.us.rawValue, apiKey: NewsClient.apiKey)
    }
    
    
    private func loadNewsListData(completion:@escaping (NewsList?) -> Void) {
        newsClient.loadHeaderlines(params: paramters) { [weak self] (newsList) in
            
            if (self?.paramters.page == HeadlinesRequestParameters.Constants.firstPageIndex) {
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
    
    func newsCount() -> Int {
        return newsList?.articles?.count ?? 0
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
