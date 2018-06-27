//
//  File.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class NewsSearchViewModel {
    private var newsClient: NewsClient!
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
        
        paramters = EverythingRequestParameters(language: EverythingRequestParameters.Languages.en.rawValue, apiKey: NewsClient.apiKey)
    }
    
    
    private func doSearch(keywords: String, completion:@escaping (NewsList?) -> Void) {
        
        paramters.keywords = keywords
        if (paramters.page == EverythingRequestParameters.Constants.firstPageIndex) {
            newsList = nil
        }
        
        guard !isRequestingVar.value
            && paramters.isReady()
            && (hasMoreNews() || paramters.page == EverythingRequestParameters.Constants.firstPageIndex) else {
                return
        }
        
        newsClient.loadEverything(params: paramters) { [weak self] (newsList) in
            
            if (self?.paramters.page == EverythingRequestParameters.Constants.firstPageIndex
                || self?.newsList  == nil) {
                self?.newsList = newsList
            } else {
                self?.newsList?.append(newsList: newsList)
            }
            
            if let newsItemViewModels = self?.newsList?.articles?.map({ (newsItem) -> NewsItemViewModel in
                return NewsItemViewModel(newsItem: newsItem)
            }) {
                self?.newsItemViewModelsVar.value = newsItemViewModels
            }
            
            completion(newsList)
            
            self?.isRequestingVar.value = false
        }
        
        isRequestingVar.value = true
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
    
    func searchMoreNews(keywords: String, completion:@escaping (NewsList?) -> Void) {
        paramters.gotoNextPage()
        doSearch(keywords:keywords, completion: completion)
    }
    
    
    func searchNews(keywords: String, completion:@escaping (NewsList?) -> Void) {
        paramters.gotoFirstPage()
        doSearch(keywords:keywords, completion: completion)
    }
}
