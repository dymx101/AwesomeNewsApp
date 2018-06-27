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
    var dbManager: DatabaseManager!
    private var paramters: EverythingRequestParameters!
    private let newsItemViewModelsVar = Variable([NewsItemViewModel]())
    private let isRequestingVar = Variable(false)
    
    /// The news list data loaded from remote api
    var newsList: NewsList?
    
    /// The observable for news item view models
    var newsItemViewModelsObservable:Observable<[NewsItemViewModel]> {
        return newsItemViewModelsVar.asObservable()
    }
    
    /// The observable for requesting status
    var isRequestingObservable: Observable<Bool> {
        return isRequestingVar.asObservable()
    }
    
    init() {
        newsClient = NewsClient()
        dbManager = FirebaseManager()
        
        paramters = EverythingRequestParameters(language: EverythingRequestParameters.Languages.en.rawValue, sources: EverythingRequestParameters.Sources.cnn.rawValue, apiKey: NewsClient.apiKey)
    }
    
    
    private func loadNewsListData(completion:@escaping (NewsList?) -> Void) {
        
        guard !isRequestingVar.value
            && paramters.isReady()
            && (hasMoreNews() || paramters.page == EverythingRequestParameters.Constants.firstPageIndex) else {
            return
        }
        
        newsClient.loadEverything(params: paramters) { [weak self] (newsList) in
            
            guard let _ = newsList else {
                // No data from the server, might be some error, let's load from firebase
                self?.dbManager.loadNewsList(completion: { (newsListCached) in
                    // Delay 0.5 sec, to make the animation smoother
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self?.newsList = newsListCached
                        self?.generateNewsItemViewModels()
                        completion(newsListCached)
                    })
                })
                self?.isRequestingVar.value = false
                return
            }
            
            if (self?.paramters.page == EverythingRequestParameters.Constants.firstPageIndex
                || self?.newsList  == nil) {
                self?.newsList = newsList
            } else {
                self?.newsList?.append(newsList: newsList)
            }
            
            self?.generateNewsItemViewModels()
            
            completion(newsList)
            
            self?.isRequestingVar.value = false
            
            // Save data to firebase if it's the first page
            if self?.paramters.page == EverythingRequestParameters.Constants.firstPageIndex {
                if let newsList = newsList {
                    self?.dbManager.saveNewsList(newslist: newsList)
                }
            }
        }
        
        isRequestingVar.value = true
    }
    
    private func generateNewsItemViewModels() {
        if let newsItemViewModels = newsList?.articles?.map({ (newsItem) -> NewsItemViewModel in
            return NewsItemViewModel(newsItem: newsItem)
        }) {
            newsItemViewModelsVar.value = newsItemViewModels
        }
    }
    
    func newsCount() -> Int {
        return newsList?.articles?.count ?? 0
    }
    
    func currentPage() -> Int {
        return paramters.page
    }
    
    func hasMoreNews() -> Bool {
        guard let current = newsList?.articles?.count, let total = newsList?.totalResults else {
            return true
        }
        
        return current < total
    }
    
    func isRequesting() -> Bool {
        return isRequestingVar.value
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
        loadNewsListData { (newslist) in
            completion(newslist)
        }
    }
}
